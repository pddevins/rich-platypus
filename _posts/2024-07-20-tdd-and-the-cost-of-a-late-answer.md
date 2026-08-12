---
layout: post
kind: post
title: "TDD and the cost of a late answer"
subtitle: "The argument for writing tests first has almost nothing to do with tests and everything to do with when you find out you were wrong."
date: 2024-07-20 10:00:00 -0400
categories: [engineering]
tags: [tdd, testing, php]
---

The case for test-driven development is usually made in terms of coverage and regression
safety, which is why it loses arguments. Both of those are achievable by writing tests
afterwards, and writing them afterwards is more comfortable. The actual argument is
narrower and harder to dismiss: TDD changes the moment you discover a design is wrong,
and the cost of that discovery rises steeply with time.

<!--more-->

## The cost curve

A wrong assumption discovered while writing the test costs a rethink. Discovered during
implementation, it costs a rewrite of whatever exists. Discovered in code review, it
costs the rewrite plus someone else's context. Discovered by QA, it costs all of that
plus a ticket, a re-test, and a scheduling conversation. Discovered in production, it
costs those plus a fix under pressure, and pressure is where the second bug gets
written.

None of that is about tests. It's about the fact that the specification error is the
expensive one, and the specification error is most visible at the moment you try to
write down what "correct" means.

Writing a test first is a device for being forced to write that down before you have
sunk anything into an implementation you'll be reluctant to discard.

## Where it earns the most

TDD is not uniformly worth it, and pretending otherwise is why people bounce off it.

It pays best where the answer is genuinely unclear before you start: business rules with
edge cases, anything involving money or dates, state machines, permissions, parsers. In
those, the act of enumerating cases *is* the design work, and the test file is just
where the enumeration happens to live.

It pays least on code whose shape is dictated by something else — a controller wiring
two known things together, a migration, a view. Writing a failing test for a
`resource()` route is theater. The design has no degrees of freedom for the test to
constrain.

The honest version of the practice is therefore selective, and a team that claims 100%
TDD is either working on unusually gnarly code or not telling the truth.

## What it does to the QA relationship

This is the part I care about most, and it took me a while to see.

A test written first is an executable statement of intent. That means when QA finds a
discrepancy, there's a document saying what the developer believed correct behavior was,
so the conversation is about which of the two understandings is right, rather than about
whether the code does what the code does.

Without it, the exchange is a negotiation over intent conducted after the fact, and it
takes far longer than the actual disagreement warrants. Almost every genuinely
irritating QA-developer conflict I've watched has been a specification ambiguity that
nobody wrote down, being relitigated with a build in the way.

The corollary is that the ordering matters more than the tooling. Tests written
afterwards give you regression safety and no shared statement of intent. That's most of
the mechanical benefit and none of the organizational one.

## Practical shape in PHP

What this looks like day to day, rather than in a manifesto:

- **Start at the outermost honest boundary.** For a business rule, a test against the
service or action, not the controller and not the private method. Tests bound to
structure rather than behavior are the ones that make refactoring miserable and give TDD
its reputation.
- **Datasets for enumerated cases.** Pest's dataset syntax turns "here are the eleven
edge cases we agreed on" into something readable, which matters because someone has to
read it in a year.
- **One assertion per behavior, not per test.** The dogma about single assertions
produces a suite nobody wants to maintain.
- **Write the failing test, watch it fail, and read the failure message.** A test that
passes before the implementation is testing nothing, and this is the only step that
catches it.

## The objection I take seriously

Under deadline, TDD is the first thing dropped, and the people dropping it are not being
lazy. They're responding accurately to an incentive. The cost of writing the test is now
and visible; the cost it avoids is later and hypothetical, and might land on someone
else.

I don't think exhortation fixes that. What worked was a board status called **Needs
Refinement**, which sounds like process theater and is the single most useful thing we
had. It gave the specification conversation somewhere to happen *before* an estimate
existed, and it made "this isn't specified enough to build" a legitimate thing to say
rather than an obstruction. Once acceptance criteria arrived as concrete examples,
writing the first test stopped feeling like extra work and started feeling like
transcription.

That's a process change rather than an engineering-discipline change, which is
inconvenient for anyone who wants this to be a matter of individual rigour.

On tooling, for completeness: we run a mix of Pest and PHPUnit, and we did migrate —
Pest for new work, PHPUnit where it already existed and rewriting bought nothing. The
mix bothers people more than it should. Both drive the same engine, a developer
switching between them loses nothing, and the alternative was a rewrite whose only
product would have been consistency.
