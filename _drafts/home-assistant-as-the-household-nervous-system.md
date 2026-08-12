---
layout: post
kind: log
title: "Home Assistant as the household nervous system"
subtitle: "Four years after mounting tablets on walls, the dashboards finally have a backend that doesn't depend on anyone else's cloud."
date: 2025-11-15 16:00:00 -0500
categories: [homelab]
tags: [home-assistant, self-hosting, proxmox, networking]
published: false
---

I mounted Fire 7 tablets around the house in 2021 and pointed them at Home Assistant
running on whatever machine was convenient. It worked, and it was fragile in the
specific way that things are fragile when the important part is running somewhere
temporary. Moving it onto Proxmox properly was less about new capability than about
making the household stop noticing when I tinker.

<!--more-->

## A VM, not a container

Home Assistant runs several ways and the choice matters more than it looks.

Home Assistant OS in a full VM is the supported path, and it's the one that gets add-ons
— the supervisor manages them, and the container-only installs don't have it. I've
previously run the container version and spent time reimplementing by hand what add-ons
provide for free. Not doing that again.

So: a VM, with the official disk image imported rather than an OS installed from
scratch.

```bash
qm create 120 --name home-assistant --memory 4096 --cores 2 \
  --net0 virtio,bridge=vmbr0 --ostype l26 --machine q35 --bios ovmf
qm importdisk 120 haos_ovf-*.qcow2 local-zfs
```

The `q35` machine type and UEFI matter here; the image expects both, and getting it
wrong produces a VM that doesn't boot with no useful diagnostic.

## The radio is the hard part

Smart home devices mostly speak Zigbee or Z-Wave, neither of which is IP, so a USB
coordinator has to be physically attached and then handed to the VM.

```bash
qm set 120 -usb0 host=10c4:ea60
```

Pass through by vendor and product ID rather than by port. Pass through by port and the
first time you reseat a cable or the host enumerates devices in a different order, your
entire smart home is offline and the cause is not obvious.

Zigbee only, in my case. Z-Wave is a perfectly good protocol and adding a second radio
is a second thing to maintain for no benefit I could identify, so I didn't.

One piece of received wisdom I can't confirm: Zigbee coordinators are said to need a USB
extension cable to get the radio away from interference from USB 3 ports and the
chassis. I didn't use one and never had the problem. That may be luck, or it may be that
this particular combination of coordinator and host doesn't suffer from it, but I'm not
going to repeat the advice as though I'd verified it. If your mesh is unreliable, try
the cable. If it isn't, don't go looking for a fix.

## Local control as the actual requirement

The reason to run this at all, rather than using each manufacturer's app, is that
integrations talking directly to devices on my network keep working when a vendor has an
outage, changes their API, or shuts down.

That's the same argument as the rest of this homelab, and it applies with more force
here because these devices are physically in my house and several have microphones or
cameras. A light that phones home is a minor annoyance. A doorbell that only works via
someone else's server is a device I don't actually own.

The practical consequence is that it changes what you buy. Local-first support is now
the first thing I check, ahead of price and features, and it rules out a lot of
otherwise reasonable hardware.

## What it does

Three categories, roughly in order of how much they get used.

**Information consolidation.** Weather, forecast, and the household calendar in one
place, which is what the wall tablets show. This is the least clever and the most used
feature, because it replaced people asking each other things.

**Schedules.** Lights on a sunset offset rather than a clock time, heating that
follows occupancy rather than a fixed program.

**Presence and conditions.** The automations that feel like magic when they work and
like a haunting when they don't, which is why I've kept these deliberately few.

Six entities. That's the whole installation, and I want to state the number plainly
because the genre this post belongs to is full of dashboards with four hundred of them.

The one that has unambiguously earned its place is the HVAC temperature schedule. In a
southern summer, cooling is the electricity bill, and a schedule that follows when the
house is occupied rather than a fixed program has been the single clearest saving in the
whole setup. Not a clever automation. A thermostat that knows what day it is.

I'd rather have six things that work than sixty I'm debugging, and the six get used
daily by people who have no idea Home Assistant exists.

## What broke

The tablets, which is fitting, since they're the reason I started this four years ago.

A Fire 7 running LineageOS makes a fine wall panel and a poor kiosk. The hardware wants
to behave like a tablet (sleep the screen, drop the wifi to save power, background the
browser) and a wall display needs the opposite of all three. Getting a dashboard to stay
up, stay awake, and reconnect after the access point blips is a set of small fights
rather than one configuration change.

The specific difficulty is that "keep the screen on" and "don't burn the battery and
cook the device" are in tension, and a tablet mounted on a wall is on mains power
permanently, which is not what its firmware assumes. Anything left at full brightness
indefinitely runs warm, and these are not well-cooled devices.

What I'd tell anyone doing this: solve wake behavior and reconnection before you spend
any time on how the dashboard looks. A beautiful panel showing a stale page is worse
than a plain one that's correct, because people stop trusting it and go back to asking
each other.

## What I'd do differently

**Pass USB through by ID from the very beginning.** I did this right only because I'd
been bitten before, and it's the single highest-value line in this post.

**Back up the configuration off the VM immediately.** Home Assistant's own backups are
good and they live inside the thing being backed up. A snapshot plus a copy elsewhere is
the actual answer, and I set it up later than I should have.

**Add automations one at a time, and live with each for a week.** Everything that has
annoyed my household was a batch of clever automations added in one sitting, where the
one causing the problem wasn't obvious because four things changed at once.

**Buy for local control, not for features.** Every regret in the device list is
something bought before I adopted that rule.
