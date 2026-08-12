---
layout: post
kind: essay
title: "Verifying children by photographing them"
subtitle: "Two vendors, two failures, and a verification pipeline whose weakest link was never the cryptography."
date: 2026-05-16 11:00:00 -0400
categories: [privacy]
tags: [surveillance, digital-rights, threat-modeling]
published: false
---

In October, Discord disclosed that around seventy thousand government ID photographs had
been exposed through a third-party provider it named as 5CA. In February, it announced
global age assurance. Eleven days after that announcement, security researchers found that
Persona, the vendor actually running the verification, had left its entire government
dashboard codebase on a publicly reachable endpoint. Within days, Discord ended the
relationship.

<!--more-->

Neither of those failures was a cryptographic failure. That is the thing I want to dwell
on, because the public argument about age verification is almost entirely about encryption
and almost entirely misses where the risk lives.

The problem being solved is real, and I want to establish that before criticising the
solution, because a lot of privacy commentary treats child safety online as a pretext
rather than a genuine concern. It isn't. Platforms built for adults are used by children,
adults who want access to children go where children are, and "we ask users to state their
age" has never been a control. Regulators in several jurisdictions have decided that's no
longer acceptable and they are not obviously wrong.

Discord's design is also better than the version its critics describe, and accuracy
requires saying so. This is not universal facial recognition. Over ninety per cent of users
are expected to have an age inferred from existing signals with no action required; the
verification path applies to a minority seeking access to age-restricted spaces. Facial
scans are processed on-device, and Discord says neither it nor its vendors receive them.
IDs are used to extract an age and then discarded, with only the age retained. If that
description holds end to end, the residual risk is genuinely modest.

The trouble is the phrase "if that holds end to end," because the two things that have
gone wrong were both about the ends.

Consider what the October disclosure and the February discovery have in common. In October,
ID photographs leaked from a company in the support chain, and 5CA has publicly denied
that its systems were involved or that it ever handled government IDs for Discord, which
means that months later the basic question of who was holding those images is contested by
the two parties best placed to know. In February, the verification provider exposed its own
government-facing dashboard code on a public endpoint. Neither event required anyone to
break an algorithm. Both were the ordinary operational failure of a subcontractor, which is
the most common way sensitive data escapes and the least discussed.

This is why on-device processing, while a good design, does not answer the objection. The
architecture describes the intended path. The failures happened beside it — in appeals
handling, in a vendor's own infrastructure, in the parts of the pipeline that exist because
real systems have exceptions and humans reviewing them. You cannot verify a claim about
end-to-end behaviour by reading the description of the happy path, and users are being asked
to do exactly that.

There's a structural point underneath, and it's the one I'd want a regulator to internalise.
A system that determines who is under eighteen has necessarily processed the
under-eighteens. If it stores an outcome, it has produced a high-confidence register of
which accounts belong to minors. If you were designing a resource for somebody who wanted
to find children online, a verified list of accounts known to belong to them would be close
to ideal. The safety mechanism and the targeting mechanism are the same artefact viewed
from different directions, and the more reliable you make the verification, the more
valuable the register becomes.

To Discord's credit, and this deserves acknowledgement, it responded to the Persona
disclosure by ending the relationship, and it has since delayed the global rollout to the
second half of the year in order to expand verification options, increase vendor
transparency, and publish technical documentation. That is roughly the correct set of
responses. It is also a delay bought with two incidents involving real people's identity
documents, which is an expensive way to arrive at "we should be more transparent about our
vendors."

I don't have a clean position to offer, and I've come to think anyone who does is skipping a
step. The people who say age verification is unacceptable surveillance are right that it
concentrates risk on the population it aims to protect. The people who say the status quo is
unacceptable are right that self-declared age is not a safeguard and that children are
being harmed while we discuss it. Both are true and they do not resolve into a policy. The
honest description is that we are choosing between a diffuse ongoing harm and a
concentrated potential one, with poor information about the magnitude of either.

What I'd hold to is procedural rather than substantive, and it follows directly from where
these two failures occurred. Any system collecting non-revocable identifiers from minors
should have to justify every link in its chain, not just its cryptography — including the
support vendors, the appeals processes, and the subcontractors nobody named in the press
release. Age signals should degrade to the minimum: a boolean, not a document, not a stored
image, not a date. Users should be told which verification path they are on and what is
retained, in terms that survive being read quickly. And the parties that mandate collection
and the vendors that perform it should carry liability for the consequences, because at
present the incentive to over-collect is unchecked by any cost, and the entity that bears the
harm is a child who was not consulted.

I'm naming 5CA and Persona deliberately. Not because either is uniquely careless — the
point is precisely that they aren't, and that this is what normal operational security looks
like at the third and fourth tier of a compliance pipeline. But accountability requires
names. A system where the platform apologises, the vendor is quietly replaced, and nobody
is answerable for seventy thousand identity documents will produce the same outcome again
with a different vendor, and the children whose data it was will never know which company
held it.

That's what makes the current trajectory look less like wading in carefully and more like
diving into water of unknown depth. When the failure mode is a well-indexed list of
children, the argument for moving slowly is not obstruction. It's the caution we would
apply to any other system where the blast radius lands on people who did not consent and
cannot opt out.

TODO: this moves fast and I've written it from reporting through mid-2026. Before
publishing, re-check: whether the delayed rollout has begun, whether 5CA's denial
has been resolved either way, and whether any regulator has responded to either incident.
