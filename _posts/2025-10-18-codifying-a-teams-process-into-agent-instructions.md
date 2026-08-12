---
layout: post
kind: post
title: "Codifying a team's process into agent instructions"
subtitle: "Writing down how we work so a tool could follow it turned out to be worth doing regardless of whether the tool followed it."
date: 2025-10-18 11:00:00 -0400
categories: [engineering]
tags: [ai-tooling, developer-experience, teams]
---

We spent a chunk of this year encoding our project conventions into instructions an
agent could execute: per-project rules about structure, review standards, and how a
change is supposed to get made. The tooling benefit was real but not the interesting
part. The interesting part is that writing it down surfaced three disagreements about
our own process that had been live for months without anyone noticing.

<!--more-->

## What "codifying" meant in practice

Not prompts. Persistent, versioned, project-scoped instruction files sitting in the
repository next to the code, so they travel with the project and change through review
like anything else.

Four categories, and the proportions are the interesting part.

**Standards, split by domain.** The largest and most valuable set, roughly twenty
documents, one per area: architecture, migrations, Eloquent, queries, caching, queues,
validation, routing, error handling, events and notifications, mail, config, testing,
security, style. Each states what we do here and, more usefully, what we don't.

**Stack and library guidance.** How *this* project uses each significant dependency. Not
the library's documentation, but the subset of it we've standardized on, plus the local
conventions around it. This turned out to be about fifteen documents, which surprised
me, and in retrospect shouldn't have: most of the questions a developer asks on a mature
Laravel project are "how do we use X here," not "how does X work."

**Task workflows.** The repeatable jobs: explore an unfamiliar area, debug an issue,
investigate a ticket, refactor safely, review a change, chase something down in
production. Fewer of these than I expected, and they get the heaviest use.

**Per-feature planning documents.** One per significant piece of work, written before the
work. This is the category I didn't anticipate at all when we started, and it's now the
one I'd least want to give up.

## The part that surprised me

Twenty documents, each stating a standard for one domain, cannot be written without
somebody deciding what the standard is. That sounds obvious written down. It was not
obvious going in, and it's the whole return on this exercise.

Most of these standards existed already, in the sense that experienced people on the
team applied them consistently. What didn't exist was agreement that they were the same
standards. Writing them out forced a series of small, undramatic decisions that had
previously been resolved differently depending on who was reviewing. The kind of
difference that never causes an argument and quietly produces inconsistency in what gets
flagged and what gets waved through.

This is the same lesson I hit growing a team from three to twenty-one, arriving from a
completely different direction. At small scale, shared context does the work and nobody
writes anything down. Past a certain size, everything that isn't explicit is a coin
flip. Writing instructions for a machine is just an unusually unforgiving way of being
forced to make things explicit, because a machine cannot infer the bits you left out and
will not ask a colleague.

If the agents had produced nothing useful, the documents would still have been worth the
time. That's a strange thing to say about a tooling investment and I think it's true.

## Where it actually helped

The real benefit took me a while to name properly, and it isn't speed.

It's that coding, security, and correctness standards now **migrate**. Across projects
and across developers. A standard that lives in one senior engineer's review habits
reaches whoever that engineer happens to review; a standard written into the project
reaches everybody, including the developer who joined last week and the project that
started yesterday. What you get is a baseline: a floor below which work doesn't fall,
regardless of who did it or how tired they were.

The part I'd emphasize, because it's the objection people raise: a floor is not a
ceiling. None of this constrains how somebody solves a problem. It constrains the things
that genuinely shouldn't vary by author (how a migration is written, how input is
validated, where a query belongs) and leaves the actual design work alone. Standardizing
the boring layer is what creates room for individual judgment on the interesting one,
and teams that resist written standards usually have it backwards: the tribal-knowledge
version is far more constraining, because it enforces whatever the loudest reviewer
prefers.

Two smaller wins worth naming. **Onboarding**. A new developer reading these gets an
accurate picture of conventions considerably faster than by reading code, because the
documents state intent and code only shows outcome. And **consistency on mechanical
work**, which is scaffolding that follows the project's conventions rather than the
framework's defaults, without anyone having to remember the local deviations.

## Where it didn't

**Instructions rot, and stale instructions are worse than none.** A wrong instruction
gets followed confidently. A missing one gets asked about. We now review these files
when the conventions they describe change, and we did not do that at first, and the gap
produced exactly the class of confident-wrong output you'd expect.

**Writing good instructions is a skill and the first attempts were bad.** Too long, too
vague, full of preferences stated as rules and rules stated as preferences. The ones
that work are specific, name the consequence, and are short enough to be read.

**It doesn't help with the parts that were hard.** Nothing here made a design
decision, chose between two architectures, or told me what the client meant. It made the
known work more consistent, which is valuable and is not the same as making the hard
work easier.

## The general form

If I were starting this again at another shop, the sequence I'd follow:

1. Standards first, one domain at a time, starting with the areas where being wrong is
expensive: security, migrations, anything touching money. Highest value, least argument.
2. Then one task workflow, for the most repeated job. Not all of them.
3. Then the stack-specific guidance, which is the largest category and the one that pays
off most per document once the standards exist to reference.
4. Planning documents last, as a habit rather than a document set. One per significant
feature, written before the work.

And treat the whole set as code: reviewed, versioned, updated when reality moves. The
moment it becomes documentation nobody maintains, it's worse than the tribal knowledge
it replaced, because tribal knowledge at least knows it's uncertain.

