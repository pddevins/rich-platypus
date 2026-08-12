---
layout: post
kind: post
title: "A year of small projects"
subtitle: "Seven things I built, broke, or nearly fixed while this blog sat untouched for twelve months."
date: 2021-12-05 14:00:00 -0500
categories: [personal]
tags: [tinkering, raspberry-pi, linux, self-hosting]
published: false
---

I haven't posted in about a year. The year wasn't idle. It was just spent on things that
never quite reached the threshold where I'd sit down and write them up. Collected
together, though, they add up to a reasonable picture of what I do when nobody assigns
it.

<!--more-->

## A moisture sensor that mostly works

A Pi Zero, a capacitive soil moisture sensor, and a houseplant with a documented history
of dying.

The electronics were the easy half. The hard half was calibration: "wet" and "dry" are
not values a sensor reports, they're thresholds you decide on, and the correct threshold
differs by soil composition and pot depth. I spent more time watering a plant on purpose
and writing down numbers than I did wiring anything.

What I learned is a general lesson about sensors that I keep re-learning. The sensor
gives you a number. Turning that number into a decision is the actual project, and it's
the part nobody's tutorial covers.

## Billy Beats, almost

A Mega Bloks Billy Beats dancing piano robot, which stopped dancing. Opening it up
showed several connections that had cooked: visibly browned, one lifted clean off its
pad.

I resoldered what I could reach. It came back partway: sound returned, and one motor
turned. The other stayed dead, and by then I was into the class of problem where the
fault is under something you have to destroy to reach.

I'm counting this one as a win regardless. It was making noise again, and I learned more
about desoldering braid on that board than on anything I've done deliberately.

## Four distros, judged on actual work

I ran Arch, Debian, Fedora, and Pop!_OS as daily drivers for professional work, not as
weekend curiosities. The test was the boring one: can I do a full day of coding, run the
project management side of my job, join calls, and not lose an hour to the operating
system.

Debian won, on grounds I didn't expect to care about.

Not performance, and certainly not package freshness, where Debian is famously behind.
It won on installation and convention. The install is predictable, the conventions are
old enough to be genuinely settled, and I already knew where things live because those
locations haven't moved in years. That combination is what makes "set it and forget it"
an actual property rather than a slogan.

The consequence that mattered most was environment replication. When the conventions are
stable and the install is deterministic, standing up an identical machine, or rebuilding
the one you have after doing something unwise to it, stops being an afternoon of
reconstruction from memory. Being able to reproduce a working setup is most of the value
of having settled on one at all.

The others didn't fail. Each of them just wanted more of my attention somewhere in that
loop. Debian was the one that stopped being something I thought about, and that was the
entire criterion.

## Fire 7 tablets as household dashboards

Amazon sells Fire 7s for less than a decent cable costs, and they're a perfectly good
panel with a bad operating system attached. Several of them are now mounted around the
house running Home Assistant dashboards.

What they show: the family calendar, a shared grocery list, the day's weather, and
controls for the smart devices in whatever room they're in.

Getting there meant rooting them and flashing LineageOS. Fire OS is the obstacle: it's
Android with Amazon's priorities bolted over the top, and no amount of launcher-swapping
removes the parts that actively work against you. Replacing the operating system
outright is more work once and less work permanently. What you're left with is a plain
Android tablet that will sit on a wall, hold one page indefinitely, and never decide to
show you a lock-screen advertisement.

The value isn't technical, though. It's that a wall-mounted screen showing the calendar
gets looked at by everyone in the household, including people who would never open an
app to check the same information. Ambient beats on-demand for anything shared.

## A hammer and a scribe, from scraps

Non-digital, and my favorite thing on this list.

I made a woodworking hammer and a marking scribe out of what was lying around: pine,
cedar, a nail, a bolt, and a length of old hacksaw blade. The nail became the scribe's
cutting edge and the hacksaw blade became the depth gauge, which is the kind of reuse
that feels like getting away with something.

The reason it's on a list with a Raspberry Pi is that it scratches the same itch. Making
a tool teaches you what the tool is for in a way that buying one doesn't. I now know
what I want out of a mallet, having spent the time to get it right the first time.

## A travel router with a VPN built in

Hotel and conference wifi is a hostile network you have to use anyway. A small travel
router, configured once, means every device I carry joins my network instead of theirs.
One VPN tunnel at the router, and the laptop and phone don't each need to be trusted to
do the right thing.

The hardware is a GL.iNet travel router, reflashed with vanilla OpenWrt rather than the
firmware it ships with. GL.iNet's own build is OpenWrt underneath and perfectly capable,
so this was a deliberate trade: I gave up a friendly configuration UI to get a stock
system with no vendor layer between me and the packages, which matters more to me on the
device whose entire job is to be trustworthy on someone else's network.

The tunnel is OpenVPN, terminating at my own endpoint rather than a commercial provider.
That distinction matters more than the protocol choice. A commercial VPN moves your
traffic from a hotel network you don't trust to a company you also don't especially
trust, which is an improvement but a modest one. Terminating at my own endpoint means
the other end is mine, and the thing I'm actually buying is that hotel wifi sees one
encrypted stream instead of my devices.

The setup being done in advance is the whole point. Nobody configures a tunnel correctly
at 11pm in an airport.

## Coding on a Digital Ocean box, in Neovim

The experiment was whether I could do real work on a remote server with Neovim instead
of a local editor.

The appeal was never portability in the abstract. It's that the environment stops being
tied to the laptop in front of me. Same setup from any machine, and the project's
dependencies live where the project lives instead of accumulating on my desktop.

Half of it stuck. Neovim slowed me down for the first two weeks, and I have used it
every day since. The remote server did not last the year.

The reason is mundane enough to be worth recording. The friction wasn't the editor, and
it wasn't latency. It was that everything adjacent to the code expects to be local: a
browser pointed at a dev server, a database GUI, screenshots, dragging a file into
Slack. Each of those has a remote-friendly answer, and the sum of those answers is a
second environment to maintain alongside the first one.

So the useful outcome was the opposite of the hypothesis. I went looking for a
development environment that wasn't tied to a particular machine, and what I kept was an
editor that's identical on every machine, which delivers most of what I wanted without
the tax.

---

Looking at these together, the through-line isn't technology. Four of the seven are
about taking something sealed (a toy, a tablet, a laptop's operating system, a hotel
network) and making it answer to me instead. The hammer is the same instinct with the
electronics removed.

That's a reasonable thing to notice about a year, and probably a better reason to keep a
blog than any of the individual projects.
