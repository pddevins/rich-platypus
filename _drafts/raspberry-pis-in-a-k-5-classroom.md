---
layout: post
kind: post
title: "Raspberry Pis in a K–5 classroom"
subtitle: "One forty-dollar board covers six grade levels, if you scope the activity to the age instead of the hardware."
date: 2020-05-12 10:00:00 -0400
categories: [electronics]
tags: [raspberry-pi, stem, education, scratch]
published: false
---

A Raspberry Pi is a poor computer and an excellent teaching tool, and the reason
is the same in both cases: nothing is hidden. The board arrives as a bare
rectangle with legs. Every part a student needs to understand is visible, labeled,
and reachable, which makes it the rare piece of technology that gets less
mysterious the closer you look.

<!--more-->

This comes out of two years of volunteering with local schools here in Florida, where
restrictions stayed loose enough that in-person sessions kept happening. The groups were
split by grade, which is a luxury — it meant the activity could be pitched at one age
rather than at a spread.

Everything below is a Raspberry Pi 3B. Worth naming, because the pinout and the Scratch
GPIO support differ between models, and instructions written for a 3B will not all
transfer to a Zero.

What changes across the grades isn't the hardware. It's the question being asked of it.

## Kindergarten through first grade: inputs and outputs

Before any programming, the useful idea is that a computer takes something in and
puts something out, and that both ends are physical.

A button and an LED are enough. Press the button, the light comes on. Let them
wire it — badly, then correctly. The learning moment is the failure: the light
doesn't come on, and the reason is a wire in the wrong hole rather than magic
being unavailable that day.

At this age I wouldn't introduce code. The Pi is a machine that responds, and
that's the whole lesson.

## Second grade: sensors, and what a sensor actually is

A sensor is a part that turns something about the world into something a computer
can count. That definition holds for every sensor a second-grader will meet, and
it's worth saying in those words, because "sensor" otherwise sounds like a
category of gadget rather than a job description.

A DHT11 or DHT22 temperature sensor is the easiest starting point, because the number
changes when a child cups their hands around it. That is about as short as a feedback
loop gets, and it converts "sensor" from a word into something they just did.

A PIR motion sensor is the natural second one, and it's a good contrast: it doesn't
report a measurement, it reports that something changed. Two sensors, two different
kinds of answer.

Connection is where the real content is. Sensors attach to the GPIO pins, and
those pins are not interchangeable: some carry power, some are ground, some carry
signal. Getting an eight-year-old to read a pinout diagram is genuinely teaching
them to read a technical reference, which is a skill with a much longer shelf life
than the activity.

## Third grade: Scratch, and the shape of a program

Scratch ships with Raspberry Pi OS, which removes the entire "get the software
installed" problem that otherwise eats a class period.

Blocks matter pedagogically because they make syntax errors impossible. A block
either snaps in or it doesn't. What's left to struggle with is the part that's
actually hard — the order things happen in — and that struggle is the point.

Third grade is where the durable concepts land, and they land better if they're
named. Sequence: this, then this. Loops: do it again until something changes.
Conditionals: if this is true do that, otherwise do the other thing. Events:
start when something happens rather than when you say go.

Those four ideas are most of programming. Students will meet them again in Python
and JavaScript and every language after, and the transfer is real as long as
someone said the words out loud the first time.

## Fourth grade: connecting the two halves

Scratch on the Pi can read the GPIO pins, which means the sensor from second
grade and the program from third grade can finally meet.

This is the first project that feels like engineering rather than an exercise. A
light that comes on when someone walks past, using the PIR. A room that announces how
warm it is, using the DHT. And the one that goes over best: an HC-SR04 ultrasonic
sensor measuring distance, which is where fourth grade earns its place, because the
sensor reports a round-trip time and you have to divide by two to get a distance.
That is a genuine unit-conversion problem arriving disguised as a robot.

Each project is a loop, a conditional, and a sensor — which is to say each one is
review. It doesn't feel like review, because the output is a thing that sits on a
shelf and works.

## Fifth grade: research, planning, and the part that isn't building

By fifth grade the constraint worth introducing isn't technical. It's that you
have to decide what to build before you build it, and find out whether someone
already solved it.

A short written plan — what problem, what parts, what steps, what could go wrong —
turns a project from an afternoon of poking into something with a hypothesis. Then
they go looking: the Raspberry Pi documentation, project write-ups, forum threads
where someone hit the exact wiring problem they're about to hit.

Reading someone else's incomplete answer and adapting it is the most transferable
skill on this entire list. It is also, not coincidentally, what professional
engineers spend a large share of their time doing.

## Why bother this early

The argument for early STEM is usually made in terms of pipelines and workforce
readiness, and I find that framing thin. The better reason is narrower.

Children are growing up surrounded by systems that present themselves as sealed.
A phone is a slab. A speaker answers questions. A thermostat decides. The default
relationship on offer is consumption, and the default explanation is that it just
works.

A student who has wired a sensor wrong and then fixed it has a different
relationship to all of it. Not expertise — a nine-year-old with a moisture sensor
is not an engineer. What they have is the accurate belief that these things are
made of parts, that the parts follow rules, and that the rules can be looked up.
That belief is the actual prerequisite for everything downstream, and it's much
harder to install at seventeen than at seven.

