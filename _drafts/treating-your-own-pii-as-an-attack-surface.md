---
layout: post
kind: post
title: "Treating your own PII as an attack surface"
subtitle: "Most personal data leaks because someone asked for it and you had no policy for saying no."
date: 2026-04-11 10:00:00 -0400
categories: [privacy]
tags: [osint, threat-modeling, surveillance]
published: false
---

Last summer I ran open-source research on myself and produced an inventory. The
follow-up question is harder: what do you actually change? The answer that has worked
for me is to stop thinking about privacy as a set of tools and start treating personal
information the way I'd treat any other attack surface — inventoried, tiered, and
reduced where reduction is cheap.

<!--more-->

## Why "attack surface" is the right frame

An attack surface is the set of points where an adversary can interact with a system,
and it is reduced by removing entry points rather than by hardening every one of them.

Personal data behaves the same way. Every field you hand over is a point of exposure
that persists after you've forgotten it, on infrastructure you don't control, governed
by a retention policy you never read. And the exposure isn't the field on its own. It's
what the field enables in combination with the others.

That combinatorial property is where the difficulty lives. Your date of birth is nearly
harmless, your mother's maiden name is nearly harmless, and your childhood address is
nearly harmless, but together they are a successful call to a support desk.

## Tier by what it unlocks, not by how private it feels

The instinct is to rank data by how personal it feels, which produces bad decisions —
people guard their home address closely while handing out the phone number that is the
recovery path for their bank.

The better question is what an attacker can do with each field.

**Tier 1: authentication and recovery material.** Phone number used for 2FA or account
recovery, email address used for recovery, security-question answers, anything
biometric. Compromise here is account takeover. This tier is small and should be guarded
disproportionately.

**Tier 2: identity documents and numbers.** Government ID numbers, passport, driving
license, images of any of them. Compromise means identity fraud, and unlike a password
you cannot rotate these.

**Tier 3: locators.** Home address, workplace, daily routine, children's school. This
tier is about physical safety rather than fraud, and it's the one that matters most if
your concern is a person rather than a criminal enterprise.

**Tier 4: correlation material.** Date of birth, usernames, employment history,
relatives' names. Individually mundane, collectively the raw material for defeating Tier
1.

Most privacy advice addresses Tier 3 and ignores Tier 1, which is backwards for almost
everyone.

## Reductions, roughly by value

**Get your phone number out of Tier 1.** SIM swapping is cheap, well-documented, and
defeats SMS-based recovery entirely. Move to an authenticator app or a hardware key
everywhere it's offered, and where a phone number is mandatory, use one that isn't your
primary — a VoIP number reserved for this does the job.

**Stop answering security questions honestly.** They are a shared secret that your
relatives, your old classmates, and any data broker also possess. Generate random
answers and store them in your password manager. This costs nothing and closes an entire
category.

**Segment email by function.** Financial, personal, shopping, public. The purpose isn't
secrecy, it's that a breach of one doesn't hand over the recovery path for the others.
On your own domain, so it survives changing provider.

**Refuse optional fields.** A surprising share of collected data was never required. Date
of birth for a retailer, phone number for a newsletter, full address for a digital
purchase. The habit worth building is a half-second pause: does this transaction need
this field to complete?

**Give ranges and approximations where exactness isn't needed.** A birth year rather
than a date, where a form will accept it. This degrades correlation without lying about
anything that matters.

**Opt out of data brokers annually.** From last summer's post, and the reason it's here
again is that it repopulates. An entry in the calendar is the mechanism; good intentions
are not.

**Audit what your devices publish.** Photo EXIF including GPS, document metadata, git
author details. All of it permanent once distributed.

## The part you can't fix alone

Your exposure is partly other people's decisions. A relative's public post, a
colleague's tagged photograph, a school newsletter with your child's name and year
group, a former employer's staff page still online.

There's no technical remedy, and what works instead is asking, specifically and without
making it weird, since most people will honour "please don't tag my kids" and simply
hadn't considered it. What doesn't work is treating this as a solved problem because
your own settings are tidy.

## The uncomfortable structural point

Nearly every reduction above is you compensating for institutions that collect more than
they need and secure it worse than they claim. You did not choose to have your ID
photographed by a third-party vendor with unclear retention. You cannot rotate a
government ID number after a breach. And the party bearing the cost of over-collection
is consistently not the party doing the collecting.

Individual hygiene is worth doing and is not a substitute for that changing. I'd rather
say that plainly than imply a sufficiently careful person is safe, because the careful
person is still exposed by the tenth vendor in a chain they never agreed to.

## What I did, and what I didn't

Two things I changed, since a post like this is worthless without them.

**I cut back public social media wherever it leaked location, birthday, or routine.** Not
deleted-everything — reduced. Those three fields are the ones that combine into
something useful, and they're exactly what a social profile is designed to publish. A
birthday is a security question, a routine is a physical-safety concern, and location is
both.

**I abandoned services outright when their privacy settings weren't adequate.** The sequence
each time: export a backup of my own data first, request that they scrub what they hold,
then delete the account. Doing it in that order matters. Once you delete, you lose both
your copy and your standing to ask.

The thing I decided *not* to do is the tedious one I recommended above. I haven't worked
through the data brokers, and twenty years of address and phone history is still
circulating as a result. I know what's exposed there, I've read my own inventory, and I
concluded it's locator and correlation material rather than authentication material, so
I put the effort into tiers one and two instead and consciously left tier three alone.

I'd rather write that down than pretend otherwise. The point of an inventory is to let
you choose what to accept, and an honest list has things on it you've decided to live
with.

Do the reductions anyway. They're cheap, they compound, and they meaningfully shrink
what half an hour of open-source research turns up. Just don't mistake them for a
solution to a problem that isn't yours to solve.
