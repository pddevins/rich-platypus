---
layout: post
kind: log
title: "Proxmox and Nextcloud, the foundation"
subtitle: "Starting the homelab properly this time: a hypervisor first, then the one service that has to be reliable before any of the fun ones."
date: 2025-07-12 14:00:00 -0400
categories: [homelab]
tags: [proxmox, nextcloud, self-hosting, zfs]
published: false
---

The mistake I've made with every previous homelab is starting with the interesting
service. You install the thing you wanted, it works, and eighteen months later it's
irreplaceable, undocumented, and sitting on a filesystem you'd now choose differently.
This time I started with the boring layer and gave it a week before installing anything
I cared about.

<!--more-->

## Why a hypervisor rather than Docker on a box

Docker on bare metal is simpler and I've run it for years. The reason to put Proxmox
underneath is that it makes each service independently disposable. A container or VM I
can snapshot before an upgrade, roll back in seconds, and destroy without wondering what
else on the machine depended on it.

That property matters more than performance for a homelab, because the actual failure
mode of a homelab isn't hardware. It's me changing something on a Sunday and not being
able to get back.

Proxmox also gives you LXC containers alongside full VMs, which is the right split for
this kind of work: LXC for anything Linux-native, a VM for anything that wants its own
kernel or that I don't trust.

## Storage first

Storage before anything else, because converting later means moving data you've started
depending on.

Three 2TB spinning disks in RAID5 (RAIDZ1, in ZFS terms) which gives roughly 4TB usable
and survives one disk failing.

```bash
zpool create -o ashift=12 tank raidz1 /dev/sda /dev/sdb /dev/sdc
zfs set compression=lz4 tank
zfs set atime=off tank
```

`ashift=12` for 4K-sector drives, and it cannot be changed after pool creation — getting
that wrong is one of the very few genuinely unrecoverable mistakes available here.

Three disks is the minimum for RAIDZ1 and it's a deliberate trade rather than a
compromise. A two-disk mirror resilvers faster and gives you half the capacity; three in
RAIDZ1 gives you two thirds and a longer rebuild window during which a second failure is
fatal. At 2TB per disk the rebuild is measured in hours rather than days, which is what
makes that risk acceptable. It would not be at 16TB.

Then snapshots, which are most of the reason for choosing ZFS at all:

```bash
zfs set com.sun:auto-snapshot=true tank
```

And separately, because this is the part people conflate, a dedicated 1TB SSD holding
backups of everything on the array, rolling, diffs only. Snapshots and that SSD are
doing different jobs. A snapshot protects me from myself. The backup disk protects me
from the array.

## Nextcloud in an LXC container

Nextcloud went first because it's the service with the highest cost of failure. If the
media server is down I watch something else. If file sync is broken or, worse, quietly
lying about having synced, that's real data.

Created unprivileged, with the ZFS dataset passed through as a bind mount rather than
living inside the container's own disk. That separation is the point: the container is
disposable, the data is not.

```bash
pct create 110 local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst \
  --hostname nextcloud \
  --cores 2 --memory 4096 \
  --rootfs local-zfs:16 \
  --net0 name=eth0,bridge=vmbr0,ip=dhcp \
  --unprivileged 1

pct set 110 -mp0 /tank/nextcloud,mp=/var/www/nextcloud/data
```

## What broke

The bind mount, and specifically UID mapping on an unprivileged container. This catches
everybody exactly once and it's worth understanding rather than just fixing.

An unprivileged LXC container shifts its user IDs relative to the host. The container's
`www-data` is user 33 inside the container and something like 100033 on the host. So a
directory on the host owned by the host's `www-data` is, from inside the container,
owned by a completely unrelated user, and Nextcloud can't write to its own data
directory.

The symptom is unhelpful. Not a permission error you can read, but Nextcloud's installer
failing to complete, or completing and then being unable to store a file, which looks
like a Nextcloud bug and is a container configuration issue.

Two ways out. Either chown the host directory to the shifted UID:

```bash
chown -R 100033:100033 /tank/nextcloud
```

Or add an explicit ID map so the container's 33 lands on the host's 33. The chown is
simpler and I took it. The map is better if multiple containers need to share a dataset,
because otherwise you're chowning the same directory to two different shifted UIDs and
losing.

The general lesson, which applies to every bind mount you'll ever pass into an
unprivileged container: the container and the host do not agree about who anyone is, and
the mount is where that disagreement surfaces.

## What I'd do differently

**Set the storage layout before installing a single service.** This is the one thing I
got right this time, having got it wrong twice, and it's the whole reason the rest was
calm.

**Write down the container IDs and what they do, immediately.** By the fourth service
`pct list` is a puzzle. A text file with `110 nextcloud` in it costs nothing and I
didn't start one until later than I should have.

**Be honest with yourself about what the backup disk does and doesn't cover.** I have a
dedicated 1TB SSD taking rolling diffs of everything on the array, which is a real
backup and not just a snapshot — different disk, different failure mode. What I do not
have is anything offsite. Both copies are in the same room, on the same circuit, behind
the same front door.

That's a deliberate acceptance rather than an oversight, and I'd rather write it down
than imply the problem is solved. Flood, fire, or theft takes both copies. For the files
where that actually matters, an offsite copy is the remaining piece of work, and it's
been the remaining piece of work for a while now.
