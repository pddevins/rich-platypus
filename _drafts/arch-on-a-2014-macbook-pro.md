---
layout: post
kind: log
title: "Arch on a 2014 MacBook Pro"
subtitle: "Ten-year-old hardware, a distro I'd previously rejected for being too much work, and the most pleasant machine I own."
date: 2024-03-02 15:00:00 -0500
categories: [engineering]
tags: [arch-linux, linux, developer-experience]
published: false
---

A few years ago I ran a distro bake-off for professional work and Arch lost, on the
grounds that it wanted more attention than I had to give it. I've now been running Arch
on a 2014 MacBook Pro for months, it's the machine I reach for first, and the reason
the verdict flipped has nothing to do with Arch changing.

<!--more-->

## Why this machine

The 2014 MacBook Pro is a good laptop that Apple stopped supporting. The chassis,
keyboard, and screen are all still excellent, and the last macOS it accepts is old
enough that current browsers have started complaining. That's the specific situation
where Linux stops being an ideological choice and starts being the only way to keep
using hardware you already like.

The hardware is also, crucially, old enough to be completely solved. Every quirk of
this model has been documented by someone else years ago.

## Why Arch this time, having rejected it before

The earlier verdict was right for what I was testing: a work machine where an
unexpected two-hour repair on a Tuesday is unacceptable, and where I wanted to
replicate the environment across machines. Debian won and still holds that job.

This is a different job. This machine is one I'm allowed to break. And once "don't
lose a working day" is off the requirements list, the calculus inverts — the thing that
made Arch expensive before is what makes it good here.

The specific value is that nothing is installed that I didn't install. On a
general-purpose distro I inherit a set of decisions about a desktop environment,
services, and defaults, and then spend my time discovering and undoing the ones I
disagree with. Arch has no opinion. The install is longer and every subsequent question
is shorter.

I landed on Niri, a scrollable-tiling Wayland compositor, which suits a 13-inch screen
better than a conventional tiling model does — windows live on an infinite horizontal
strip you scroll along, so a small display stops being a constraint you're fighting.

Start to finish, including styling and keybind customisation, the whole thing took about
three hours. That number is the honest answer to "is Arch a lot of work," and it's lower
than the folklore suggests, on hardware this well documented.

## What needed doing on this hardware

Less than I expected. The trackpad and fan control both worked out of the box — no
`mbpfan`, no thermal tuning, nothing. On a 2014 chassis that surprised me, and it's the
main reason the install stayed a three-hour job.

Two things did need attention.

**Wifi.** The Broadcom chip is the classic Mac-on-Linux obstacle. What fixed it was a
newer and considerably smaller driver package than the big proprietary one I'd reached for
on this hardware in the past — once that was in place it simply worked, with none of the
kernel-module wrestling this problem is famous for.

**The function keys.** The mapping was wrong out of the box, which on a Mac keyboard means
the top row and the modifier layout both need dealing with. I used a key-event viewer to
read the actual codes the hardware was emitting, then wrote custom mappings against what I
saw rather than against what any guide assumed. That's the approach worth copying: read
your own keycodes first, because Mac keyboard layouts vary by model and year and a
copy-pasted config will be subtly wrong in a way that's maddening to debug.

And macOS is gone. I wiped it rather than shrinking a partition for a dual boot, which in
hindsight was obviously correct — see below.

TODO: if the Broadcom driver package name comes back to you, name it. `brcmfmac` (the
in-kernel driver, as against the much larger `broadcom-wl`) would fit your description of
"smaller and newer," but I'm not going to assert it on your behalf.

Each of these is a sentence, and the sentences are the reason someone would read this
post rather than the Arch wiki.

## What it's actually good for

This is not my primary work machine and I'm not going to pretend it is. What it turned
out to be is the machine where I do the things that benefit from an environment I fully
understand: reading code, writing, terminal work, tinkering with the homelab.

The unexpected part is how fast it feels. Ten-year-old hardware running a system with
nothing speculative loaded is quicker at the things I do all day than newer hardware
carrying a full desktop stack. Not benchmark-fast. Fast in the sense that windows open
when I ask.

## What I'd do differently

Honestly: nothing. That's an unsatisfying answer for a build log, so let me be specific
about why, because "no regrets" usually means someone hasn't looked hard enough.

The reason this went smoothly is that the hardware is a decade old. Every quirk of this
model has been hit, documented, and solved by somebody else years ago, and the two
problems I did have — wifi and the keyboard — both had known answers I could look up.
There was no novel debugging. Wiping macOS instead of keeping a dual boot removed the one
decision I might otherwise have got wrong.

So the transferable lesson isn't about Arch. It's that "old hardware" and "difficult
hardware" are close to opposites, and choosing a machine whose problems are already solved
is worth more than any amount of preparation. If I'd tried this on a two-year-old laptop,
this section would be long.

The one thing I'd tell someone starting: read your own keycodes before writing keyboard
config, and read the model-specific wiki page all the way through before you begin rather
than consulting it after each problem. Both of those cost minutes and save an evening.
