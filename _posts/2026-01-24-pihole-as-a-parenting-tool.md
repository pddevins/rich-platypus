---
layout: post
kind: log
title: "Pi-hole as a parenting tool"
subtitle: "DNS filtering is a blunt instrument with one real advantage: it works on every device on the network, including the ones with no parental controls at all."
date: 2026-01-24 11:00:00 -0500
categories: [homelab]
tags: [pihole, dns, networking, self-hosting]
---

Every device my kids use has its own parental controls, each with a different interface,
a different account, and a different set of gaps. A handheld console has nothing useful
at all. DNS filtering sits below all of that: one place, one set of rules, and it
applies to anything that joins the network — which is both the reason to do it and the
reason it isn't sufficient.

<!--more-->

## What DNS filtering can and can't do

Worth being precise, because it's routinely oversold.

**It can** block a request to a known domain before a connection is made, network-wide,
for devices that have no controls of their own. It removes most advertising and tracking
as a side effect, which is a genuine performance and privacy win for the whole
household.

**It cannot** filter within a site. It won't block one video on a platform you allow. It
doesn't see inside HTTPS and isn't trying to. It's trivially bypassed by anything using
a hardcoded resolver, DNS-over-HTTPS, a VPN, or cellular data instead of your wifi.

So it's a floor, not a fence. It handles the accidental and the casual — a mistyped
domain, an ad leading somewhere unpleasant, a link in a game. It does not handle a
motivated teenager, and treating it as though it does is the actual danger, because it
substitutes a technical measure for a conversation.

## The install

An LXC container on Proxmox, because the one thing a DNS server must be is boringly
available.

```bash
pct create 130 local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst \
  --hostname pihole \
  --cores 1 --memory 512 \
  --net0 name=eth0,bridge=vmbr0,ip=10.0.0.53/24,gw=10.0.0.1 \
  --unprivileged 1
```

A static address, obviously, since every device on the network is about to depend on it.

Then the part people skip: the router hands out Pi-hole as the *only* resolver via DHCP.
Leaving a secondary public resolver in the DHCP options means clients will silently use
it whenever it answers first, and you'll conclude filtering doesn't work.

That creates a single point of failure for all name resolution in the house, which is
the honest cost. A second instance with `keepalived` is the proper answer.

I run one. So when that container goes down, the internet is down for everybody, and the
first time it happened during somebody's call I heard about it in detail. There's no
clever mitigation to report. It's a known, accepted fragility, and the fix is on a list.

If you're setting this up for a household rather than for yourself, I'd genuinely
consider running two from the start. The second instance costs almost nothing on
hardware you already have, and the cost of the outage is not measured in downtime, it's
measured in whether anyone lets you keep doing this.

## Per-device policy, which is the actually useful bit

A single blocklist for the whole house is the wrong shape. Adults and a six-year-old
need different rules, and my own devices need to not be filtered while I'm working.

Pi-hole groups handle this: define groups, assign clients by IP or MAC, and apply
different adlists per group. Which makes DHCP reservations a prerequisite — a device
whose address changes falls out of its group and silently gets the default policy.

```
Default group   → ads and trackers only
Kids' devices   → ads, trackers, plus category lists
My workstation  → ads and trackers, with a permissive allowlist
```

For the kids' group I'm using the standard curated blocklists maintained by one of the
parental-safety projects on GitHub, rather than assembling categories myself. That's a
deliberate choice: a maintained list gets updated as domains move, and my hand-rolled
list would be accurate the week I wrote it and rotting thereafter.

Safe Search is enforced for their devices too, which is a separate piece of
configuration from blocking. It works by DNS rewrite — the major search engines publish
dedicated hostnames that force their filtered variant, and you point the normal hostname
at those. Worth doing, and worth knowing it's a different mechanism, because it means
Safe Search holds even where a blocklist has no opinion.

## What broke

A device with a hardcoded resolver, which is the failure that matters most because it
doesn't look like a failure.

Plenty of consumer hardware ignores the DNS server handed out by DHCP and talks to a
public resolver it was shipped with. From the Pi-hole side everything appears healthy —
the dashboard shows queries, blocking works, other devices behave. The device in
question simply isn't asking you, so none of your rules apply to it, and you have no
signal that this is happening because absence of queries looks like absence of activity.

The fix is at the router rather than at Pi-hole: a firewall rule that intercepts
outbound DNS and redirects it to your own resolver, so a device asking elsewhere gets
your answer regardless of what it intended.

```
# redirect any outbound port 53 from the LAN to Pi-hole
iptables -t nat -A PREROUTING -i br-lan -p udp --dport 53 \
  -j DNAT --to-destination 10.0.0.53
iptables -t nat -A PREROUTING -i br-lan -p tcp --dport 53 \
  -j DNAT --to-destination 10.0.0.53
```

This is the step that turns filtering from something that works on cooperative devices
into something that works on the network. Without it, the whole exercise is opt-in, and
the devices least likely to cooperate are exactly the cheap ones you have the least
control over otherwise.

It does nothing about DNS-over-HTTPS, which travels over 443 and is indistinguishable
from ordinary web traffic. That gap is real and I haven't closed it.

## What I'd do differently

**Set up per-device groups from the start, not one global list.** I ran a single policy
for a few weeks and it was simultaneously too strict for me and too loose for the kids,
which is the worst of both and made me doubt the whole exercise.

**Reserve every device's address in DHCP before creating groups.** Group membership is
address-based, so without reservations the policy quietly stops applying and nothing
tells you.

**Run two instances, or accept the outage and tell the household.** I picked the second 
option, which is a tradeoff I'm willing to take.

**Say out loud what this is for.** The most useful thing wasn't technical. Telling the
kids the network filters some things, and why, and that it's imperfect, turned it from
something to route around into something ordinary. The filtering handles accidents. The
conversation handles intent, and only one of those is in the container.
