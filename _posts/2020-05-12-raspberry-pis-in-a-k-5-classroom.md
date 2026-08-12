---
layout: post
kind: post
title: "Raspberry Pis in a K–5 classroom"
subtitle: "One board covers six grade levels, if you scope the activity to the age instead of the hardware. Written from volunteering on a Model B, updated for what you can buy in 2020."
date: 2020-05-12 10:00:00 -0400
categories: [electronics]
tags: [raspberry-pi, stem, education, scratch]
---

A Raspberry Pi is a poor computer and an excellent teaching tool, and the reason is the
same in both cases: nothing is hidden. The board arrives as a bare rectangle with legs.
Every part a student needs to understand is visible, labeled, and reachable, which makes
it the rare piece of technology that gets less mysterious the closer you look.

<!--more-->

This comes out of two years of volunteering with local schools, 2012 to 2014, back when
the Pi was new and nobody had settled yet on what it was for in a classroom. I used an
original Model B, because that was the only thing there was.

I have updated everything below for hardware you can actually buy in 2020, because the
grade-by-grade structure held up and the equipment around it did not. Where the modern
answer is easier than what I had, I have said so.

## What changed since the Model B

Four things matter if you are working from older instructions.

**The header.** The Model B had 26 GPIO pins. Every board since the B+ in 2014 has 40.
Pin numbers in anything written before then will not map onto a current Pi, so read your
own pinout rather than a tutorial's.

**Scratch talks to the pins by itself now.** On the Model B this needed a third-party
add-on that you installed and hoped about. Scratch 3 ships with a GPIO extension built
in. This is the single biggest improvement in the whole setup and it removes an entire
class period of troubleshooting.

**Python got a friendly library.** `gpiozero` did not exist in 2013. It does now, and it
is part of the standard image.

**The cables are different.** A Model B took a full-size SD card and a normal HDMI lead.
A Pi 4 takes microSD, has two micro-HDMI sockets, and is powered over USB-C. None of your
old cables fit.

## What to buy in 2020

A **Raspberry Pi 4 with 2GB of RAM** is the right classroom board. That is not my
preference, it is what the Raspberry Pi Foundation recommends for running Scratch 3, and
Scratch 3 will not run at all on anything older than a Pi 3.

A 3B+ is the cheaper option and works. It also uses full-size HDMI and micro-USB power,
which is worth something if the school already owns a drawer of those cables.

Two things to budget for that nobody mentions. The Pi 4 wants a real 3A USB-C supply, and
a phone charger will brown out under load in a way that looks like a software fault. And
it runs warm, so buy cases with some airflow or a heatsink.

Write the card with **Raspberry Pi Imager**, which arrived in March and replaced the older
routine of downloading an image and finding something to flash it with. Pick the OS from a
menu, pick the card, done. Use Raspbian Buster, since Scratch 3 requires it.

## Kindergarten through first grade: inputs and outputs

Before any programming, the useful idea is that a computer takes something in and puts
something out, and that both ends are physical.

A button and an LED are enough. Press the button, the light comes on. Let them wire it
badly first, then correctly. The learning moment is the failure. The light doesn't come
on, and the reason is a wire in the wrong hole, not magic being unavailable that day.

At this age I wouldn't introduce code. The Pi is a machine that responds. That is the
entire lesson.

## Second grade: sensors, and what a sensor is

A sensor is a part that turns something about the world into a number a computer can read.
That definition holds for every sensor a second-grader will meet. Say it in those words.
Otherwise "sensor" sounds like a category of gadget instead of a job description.

A DHT11 or DHT22 temperature sensor is the easiest starting point, because the number
changes when a child cups their hands around it. That is about as short as a feedback loop
gets, and it converts "sensor" from a word into something they just did.

A PIR motion sensor is a good second one, because it answers a different kind of question.
It does not report a measurement. It reports that something changed.

There is now a shortcut worth knowing about. A **Sense HAT** sits on the header with no
wiring at all and brings temperature, humidity, pressure, a joystick, and an 8x8 LED
matrix. Scratch 3 has a built-in extension for it. If your session is one hour long, or
the group is large, or you are doing this alone with twenty children, the Sense HAT is the
sane choice.

It also skips the part I think is most valuable, so I would not use it every time.
Connection is where the real content is. Sensors attach to the GPIO pins, and those pins
are not interchangeable. Some carry power. Some are ground. Some carry signal. Getting an
eight-year-old to read a pinout diagram is teaching them to read a technical reference.
That skill has a much longer shelf life than the activity does.

## Third grade: Scratch, and the shape of a program

Scratch ships with Raspbian, which removes the entire "get the software installed" problem
that otherwise eats a class period.

Blocks matter because they make syntax errors impossible. A block either snaps in or it
doesn't. What is left to struggle with is the order things happen in. That struggle is the
point.

Third grade is where the durable concepts land, and they land better if they're named.
Sequence: this, then this. Loops: do it again until something changes. Conditionals: if
this is true do that, otherwise do the other thing. Events: start when something happens
rather than when you say go.

Those four ideas are most of programming. Students will meet them again in Python and
JavaScript and every language after. The transfer is real, as long as someone said the
words out loud the first time.

## Fourth grade: connecting the two halves

Turn on the GPIO extension in Scratch 3 and the sensor from second grade and the program
from third grade can finally meet. On my Model B this was the hard part of the whole
curriculum. Now it is a menu item.

This is the first project that feels like engineering rather than an exercise. A light
that comes on when someone walks past, using the PIR. A room that announces how warm it
is, using the DHT. And the one that goes over best: an HC-SR04 ultrasonic sensor measuring
distance, which is where fourth grade earns its place, because the sensor reports a
round-trip time and you have to divide by two to get a distance. That is a genuine
unit-conversion problem arriving disguised as a robot.

One thing to get right before you hand that one to a child. The HC-SR04 runs on 5V and its
echo pin sends 5V back, and a Pi's GPIO pins only tolerate 3.3V. This has not changed with
any board. Wired straight in it can damage the pin. Two resistors as a voltage divider on
the echo line fixes it, and it is worth building that into the kit you hand out rather than
trusting twenty nine-year-olds to wire it correctly. This is the one sensor on the list
where a mistake costs hardware instead of a lesson.

Each project is a loop, a conditional, and a sensor, so each one is review. It doesn't feel
like review, because the output is a thing that sits on a shelf and works.

## Fifth grade: research, planning, and the part that isn't building

By fifth grade the constraint worth introducing is not technical. It is that you have to
decide what to build before you build it, and find out whether someone already solved it.

A short written plan turns a project from an afternoon of poking into something with a
hypothesis. What problem, what parts, what steps, what could go wrong. Then they go
looking: the Raspberry Pi documentation, project write-ups, forum threads where someone hit
the exact wiring problem they are about to hit.

Reading someone else's incomplete answer and adapting it is the most transferable skill on
this list. It is also what professional engineers spend a large share of their time doing.

Fifth grade is also where Python becomes reasonable, and `gpiozero` is why. Turning on an
LED is three lines that read like English. A student who has done the Scratch version
already knows what the program is supposed to do, so the only new thing is the typing,
which is the right order to meet a text language in.

## Why bother this early

The argument for early STEM is usually made in terms of pipelines and workforce readiness.
I find that framing thin. The better reason is narrower.

Children are growing up surrounded by systems that present themselves as sealed. A phone
is a slab. A speaker answers questions. A thermostat decides. The relationship on offer is
consumption, and the explanation on offer is that it just works.

A student who has wired a sensor wrong and then fixed it has a different relationship to
all of it. Not expertise. A nine-year-old with a temperature sensor is not an engineer.
What they have is an accurate belief: that these things are made of parts, that the parts
follow rules, and that the rules can be looked up. That belief is the prerequisite for
everything downstream. It is much harder to install at seventeen than at seven.
