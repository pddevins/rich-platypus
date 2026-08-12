---
layout: post
kind: post
title: "Running OSINT on yourself"
subtitle: "An afternoon of open-source research on my own name turned up more than I expected, and almost none of it came from anywhere I'd chosen to publish."
date: 2025-08-16 10:00:00 -0400
categories: [privacy]
tags: [osint, threat-modeling, surveillance]
published: false
---

The useful thing about open-source intelligence as a defensive exercise is that it
replaces speculation with a list. I spent an afternoon researching myself using only
public sources and no paid tools, and the result was not a vague sense of exposure. It
was a document with entries, each of which had an owner and, in most cases, a removal
process.

<!--more-->

## Why do this at all

A threat model without an inventory is a mood. "I care about privacy" produces
scattered decisions (a VPN here, a password manager there) with no way to tell
whether any of them addressed something that mattered.

The specific question OSINT answers is: what can somebody assemble about me, starting
from nothing, in an afternoon, for free? That's a well-defined adversary. It isn't a
state actor and it isn't a targeted attacker with resources. It's the realistic one:
someone mildly motivated with a search engine, which describes a stalker, a social
engineer preparing a support-desk call, or a bored person with a grudge.

## The method, in order

Work outward from what an attacker starts with, which is usually a name or an email
address.

**1. Search engines, properly.** Not one query. Your name in quotes, plus each city
you've lived in, plus each employer, plus "resume", plus your usernames. Then the same
across a second and third engine, because their indexes differ meaningfully and one will
have cached something another dropped.

**2. Data broker sites.** This is where the volume is. People-search aggregators
assemble public records, marketing data, and scraped sources into a profile — commonly
your address history, age, relatives, and phone numbers. You did not consent to any of
it in any meaningful sense, and each one has its own opt-out.

**3. Breach exposure.** Check your addresses against Have I Been Pwned. The value isn't
the news that you were in a breach, it's knowing *which* accounts and therefore which
passwords need to be considered public.

**4. Username correlation across platforms.** A distinctive handle reused across
services links accounts you may not have intended to associate. This is the single most
common way an otherwise careful person gets deanonymised, and it's usually a decade of
accumulated habit.

**5. Your own published material.** Photograph EXIF data, document metadata, commit
history in public repositories. Author names and email addresses in git history are a
reliable source of a real name attached to a handle.

**6. Domain registration.** WHOIS on anything you've ever registered. Privacy
protection is standard now and wasn't always, and historical WHOIS records are archived
and sold.

**7. The people around you.** Your exposure includes what others publish about you —
family members' public posts, a colleague's conference photo, a tagged check-in. This is
the part you cannot fix unilaterally and the part most people never check.

## What thirty minutes turned up

I time-boxed this deliberately — thirty minutes, to model the realistic adversary rather
than a determined one. Here's the result.

**Residential and phone history going back twenty years.** Comprehensive and largely
accurate. Every address, in order, with phone numbers attached. This is the data broker
material and it is the bulk of the exposure.

**No valid email addresses and no social media accounts.** Genuinely nothing usable. That
surprised me more than the address history did, because it's the half that matters most for
account takeover, and it's the half I've actually managed.

**A GitHub repository on the first page of results.** First page. Which is the reminder
that professional visibility and personal exposure use the same channel, and that the
technical trail is the one I've been least careful about while being most careful
elsewhere.

**Personal information didn't appear until page four of a plain search.** Which brings me to
the most useful and least reproducible finding.

I share a name with a character from *True Blood*, and I suspect that's doing more for my
obscurity than anything I've deliberately configured. Search results for my name are
substantially about a fictional Marine from an HBO series, and a mildly motivated person
working within thirty minutes plausibly gives up before page four.

That's worth dwelling on because it's the opposite of a security control. It's luck. It
isn't a strategy, it can evaporate if the show's cultural footprint shifts, and it does
nothing whatsoever against anybody who queries a broker directly instead of a search engine.
Anyone with a distinctive name has none of it. But it does illustrate something real about
how this works in practice: obscurity is a genuine component of exposure, and most
of yours is not under your control.

## Reducing the surface

Ordered by benefit per unit of effort, because the temptation is to start with the
technical work and the technical work is not where the exposure is.

**Opt out of the brokers, and diarise it.** This is tedious, effective, and
impermanent. Records repopulate from upstream sources, so an annual pass is required. It
is the highest-value item on this list and the one people skip because it's boring.

**Break username reuse.** Different handles on services that don't need to be linked.
This prevents future correlation; it can't undo past correlation.

**Separate email identities by function.** Financial, personal, shopping, and public
should not be one address. The point isn't secrecy, it's that a breach on one doesn't
give an attacker your account-recovery path on the others.

**Get your phone number out of account recovery where possible.** SIM swapping is a
real and cheap attack, and a phone number is a poor authentication factor that a great
many services still treat as a strong one.

**Audit git history and document metadata** before publishing, not after. Both are
permanent once mirrored.

**Ask your family what's public.** Awkward, and more effective than most of the
technical measures.

## What this exercise doesn't do

It won't tell you anything about a targeted adversary with money, legal authority, or
access to non-public data. It doesn't address platform-level tracking or the advertising
ecosystem, both of which are separate problems with separate answers. And it will not
make you unfindable — if you have worked, voted, owned property, or held a professional
licence, you are in public records, and no amount of opting out changes that.

The realistic outcome is a smaller, more accurate, more current profile of you in
circulation, and a list you can revisit. That's worth thirty minutes, and it's a
considerably better use of them than another argument about which VPN to buy.

One admission, since recommending work you haven't done is a bad look. **I haven't scrubbed
the broker data.** Twenty years of address and phone history is still sitting out there,
and I've read my own list and decided not to act on that part of it.

That's a considered position rather than laziness. I know what's exposed, I know what it
enables (locators and correlation material, tiers three and four, not authentication
material) and I've accounted for it in how I've set up the parts that would hurt.
The addresses are historical. The authentication surface is where I spent the effort, and
that's the part the search came back clean on.

Which is really the argument of this whole post. The inventory isn't valuable because it
tells you to fix everything. It's valuable because it lets you decide what not to fix, on
purpose, with the list in front of you — rather than defaulting to whichever measure a blog
post recommended last.
