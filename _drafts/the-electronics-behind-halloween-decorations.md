---
layout: post
kind: note
title: "The electronics behind motion-sensing Halloween decorations"
subtitle: "The screaming skeleton on your porch is a two-dollar sensor, a timer, and no microcontroller at all."
date: 2022-10-31 18:00:00 -0400
categories: [electronics]
tags: [sensors, tinkering]
published: false
---

Nearly every motion-activated Halloween prop on a porch tonight is built from the same
part: a PIR sensor, which costs about two dollars and contains no intelligence
whatsoever.

<!--more-->

PIR stands for passive infrared. It doesn't emit anything, hence passive. It reads
infrared radiation, which every warm body gives off, across a lens divided into zones.
When the reading in one zone changes relative to another, something warm moved across
the boundary. That's the entire mechanism. It cannot tell a person from a dog, and under
a porch light it will occasionally be triggered by a moth.

What's genuinely clever is how little else the prop needs. The sensor produces a plain
HIGH signal for a fixed period after it trips, so it can drive a relay or an audio
trigger directly. No microcontroller, no code, no logic. The two trimpots on the back of
the board, sensitivity and time delay, are the entire configuration interface, which is
why a cheap decoration can be tuned by a person who has never heard the word GPIO.

The failure modes are the interesting part, and they explain the ones that misbehave.
PIR sensors need a warm-up period after power-on, typically under a minute, during which
they report nonsense. They're triggered by *changes* in heat, so a prop aimed at a
driveway in direct afternoon sun will fire at nothing all day. And the time delay
retriggers rather than queues, so a steady stream of trick-or-treaters keeps a prop
stuck in its animation instead of restarting it. That's why the good ones sit back from
the walkway with a narrow field of view rather than aimed straight down the path.

If you wanted to do better than the store version, that's the place to start: not a
better sensor, but a sensor pointed somewhere smarter.
