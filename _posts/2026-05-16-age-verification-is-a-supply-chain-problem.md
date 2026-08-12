---
layout: post
kind: essay
title: "Age verification is a supply-chain problem"
subtitle: "Discord lost seventy thousand government ID photographs to a vendor in October, then announced a larger vendor pipeline in February. The failure mode was not hard to foresee."
date: 2026-05-16 11:00:00 -0400
categories: [privacy]
tags: [surveillance, digital-rights, threat-modeling]
redirect_from:
  - /2026/05/verifying-children-by-photographing-them/
---

Last October, Discord disclosed that around seventy thousand government ID photographs
had been exposed through a third-party provider it identified as 5CA. This February, four
months later, it announced that age assurance was going global. Eleven days after that
announcement, security researchers found that Persona, the vendor actually running the
verification, had left its entire government dashboard codebase on a publicly reachable
endpoint. Discord ended the relationship days later.

<!--more-->

The order of those events is the argument. Everything else here is detail.

Let me concede the hard part first, because the problem is real and I have no interest in
pretending otherwise. Platforms built for adults are used by children. Adults who want
access to children go where children are. "We ask users to state their age" has never
been a control, and regulators in several jurisdictions have decided that is no longer
acceptable. They are not obviously wrong, and there is no clean answer available to
anyone.

There is a strand of privacy writing that treats child safety as a cover story, a lever
for acquiring monitoring powers that would be refused outright if they were argued on
their own merits. That reading is often correct about a specific law or a specific
product, and I am about to make a version of it myself. It is wrong as a claim about the
underlying danger. Children are harmed on these platforms. The risk is not manufactured in order to justify
anything, and it does not become less real because the remedies on offer are bad ones.

None of which obliges me to accept that what Discord built is a serious attempt to solve
the problem.

Discord's claims are worth stating fairly. This is not universal facial recognition. Over
ninety percent of users are expected to have an age inferred from existing signals with
no action required, and the verification path applies to a minority seeking access to
age-restricted spaces. Facial scans are processed on device, and Discord says neither it
nor its vendors ever receive them. IDs are used to extract an age and then discarded,
with only the age retained. Taken at face value, that is a thoughtful design.

The trouble is that a design is a description of the intended path, and both failures so
far happened somewhere else. In October, ID photographs escaped through a company in the
support chain that handled age-related appeals. In February, the verification provider
exposed its own government-facing dashboard code to the open internet. Neither event
required anyone to break an algorithm. Both were ordinary operational failures at a
subcontractor. That is the most common way sensitive data escapes, and the least
discussed.

So the vendor chain was not an unforeseeable risk. It was the risk that had already
materialized, at Discord, with the same category of data, four months before it announced
it was expanding the pipeline. Whatever internal review followed October, it did not
produce enough caution to change the February decision. You cannot describe that as
caution. Discord had been shown exactly where the floor gives way, and chose to stand
there again.

The details make it worse. At the moment Discord announced this expansion, the vendor it
had chosen was already leaving government-facing code on a public endpoint. Discord did
not find that. Researchers did, and the relationship ended only once the finding was
public. Separately, 5CA has publicly denied that its systems were involved or that it ever
handled government IDs for Discord at all, which means that months after the fact the
basic question of who was holding seventy thousand identity documents is contested by the
two parties best placed to know. A company that cannot say with confidence which
subcontractor held the last set of ID photographs is not a company positioned to promise
anything about the next set.

And the promises themselves did not survive contact with the rollout. Users in the UK
reported notices indicating the verification vendor could process and temporarily retain
submitted data for up to seven days, which is difficult to reconcile with the on-device
framing. I don't think that is necessarily dishonesty. Large systems have multiple paths
and the ID route is plainly not on device. But it means the guarantee a user
receives depends on which path they were silently routed down, and the only account of
that path they are given is interface copy inside a flow designed to be completed
quickly. The guarantee may well be sound. The user's ability to know which guarantee
applies to them is not.

There is a structural point underneath all of this that no amount of vendor diligence
fixes. A system that determines who is under eighteen has necessarily processed the
under-eighteens. If it stores an outcome, it has produced a high-confidence register of
which accounts belong to minors. If you were designing a resource for somebody who wanted
to find children online, a verified list of accounts known to belong to them would be
close to ideal. The safety mechanism and the targeting mechanism are the same artifact
viewed from different directions, and the more reliable the verification, the more
valuable the register becomes.

Which brings me to the part I cannot prove, and am not going to pretend I can. I have no
window into anyone's motives at Discord. What I can describe is what the arrangement
produces regardless of motive: every user defaulted into a state where full access
requires proving who they are, an age signal retained on the platform's side, a
high-confidence index of which accounts belong to children, and a subcontractor chain the
platform has already demonstrated it cannot fully account for. An identity-verified user
base is commercially valuable for reasons that have nothing to do with safety, and the
incentive to acquire one does not need to be stated to operate.

I am not claiming that is the plan. I am saying the outcome is the same either way, and
that a company genuinely optimizing for child safety would have had to work quite hard to
arrive at an architecture this convenient. When the safety case and the data-collection
case recommend identical actions, the burden of proof sits with the party doing the
collecting, and Discord has not met it.

To be fair about what has happened since: the Persona relationship is over, and the
global rollout is delayed to the second half of the year to expand verification options,
increase vendor transparency, and publish technical documentation. Those are broadly the
right moves. They are also entirely reactive. Every one of them followed public
criticism rather than internal review, and the whole set was paid for with two incidents
involving real people's identity documents. That is an expensive route to "we should be
clearer about our vendors." And the bill does not land on Discord. It lands on the next
user asked to photograph an identity document, who now has to price in the possibility
that the request is being serviced three tiers down by a company nobody has named, and
who has been given no way to work out whether this is the careful kind of ask.

What I would hold to is procedural, and it follows from where these failures
occurred. Any system collecting non-revocable identifiers from minors should have to
justify every link in its chain, not merely its cryptography, and that includes the
support vendors, the appeals processes, and the subcontractors nobody names in the press
release. Age signals should degrade to the minimum: a boolean, not a document, not a
stored image, not a date. Users should be told which verification path they are on and
what is retained, in terms that survive being read quickly. And the parties that mandate
collection, along with the vendors performing it, should carry liability for the
consequences, because right now the incentive to over-collect is unchecked by any cost
and the entity absorbing the harm is a child who was not consulted.

I am naming 5CA and Persona deliberately. Not because either is uniquely careless, since
the point is that they are not, and this is what ordinary operational security looks like
at the third and fourth tier of a compliance pipeline. But accountability requires names.
A system where the platform apologizes, the vendor is quietly replaced, and nobody is
answerable for seventy thousand identity documents will produce this outcome again with a
different vendor, and the children those documents belonged to will never learn which
company held them.

The failure mode here is a well-indexed list of children. Anyone building toward that
should be able to show they understood the risk before the second incident rather than
after it, and on the evidence available, Discord cannot.
