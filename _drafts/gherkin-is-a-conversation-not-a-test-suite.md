---
layout: post
kind: post
title: "Gherkin is a conversation, not a test suite"
subtitle: "Teams adopt it expecting better tests and get worse ones. Its actual value sits upstream of any code being written."
date: 2023-09-14 10:00:00 -0400
categories: [engineering]
tags: [testing, tdd, php]
published: false
---

Most teams that adopt Cucumber or Behat end up with a slower, more brittle test suite
than the one they replaced, and conclude that Gherkin was a mistake. It wasn't a
mistake, it was a misidentification. The value of `Given / When / Then` is almost
entirely extracted before anyone writes a step definition, and if you're measuring it
by the tests it produces you've bought an expensive testing framework to solve a
specification problem.

<!--more-->

## What it costs

Be honest about the bill first, because it's real.

Every Gherkin scenario needs step definitions, and step definitions are a translation
layer between English and code. That layer has to be maintained, it has no compiler
watching it, and it drifts. You get near-duplicate steps, `Given I am logged in` and
`Given I have signed in`, that do subtly different things. Refactoring the
application means hunting through `.feature` files that nothing type-checks. And the
suite is slow, because scenarios written in business language tend to be end-to-end by
default.

Against that, a plain PHPUnit or Pest test is one file, one language, and a stack
trace that points at the actual line.

## What it buys

The thing worth paying for is that you cannot write a good Gherkin scenario without
agreeing on vocabulary.

"Given an approved asset for the German market, when a user swaps a claim, then the
asset returns to draft" is a sentence that forces four questions into the open. What
counts as approved? Is market eligibility a property of the asset or the claim? What
is a claim, exactly, as a noun in the system? Does swapping one invalidate the whole
approval or part of it?

Those questions get answered during specification or they get answered during
development, by whichever developer hits them first, alone, at 4pm. That's the choice
Gherkin actually presents. It isn't testing versus not testing. It's deciding
together versus deciding by accident.

That's also why it earns its keep specifically in regulated or
compliance-shaped domains, where the cost of a developer quietly inventing a
definition is not a bug report but a legal exposure. On a CRUD app with a clear
domain, it's ceremony.

## The comparison, concretely

**PHPUnit**. the default, and still correct for most things. Verbose, explicit,
mature. Its ceremony is a genuine cost on the hundredth test and a genuine benefit
when a new engineer reads it cold. Best for unit and integration work where the
audience is exclusively developers.

**Pest**. the same engine with the ceremony removed. Higher-level `it()` blocks,
expressive expectations, datasets that make parameterised cases readable instead of
arduous. What it changes is not capability but the marginal cost of writing one more
test, and that marginal cost is what determines how many tests exist. Best as
the default for new PHP work.

**Behat / Gherkin**. a specification tool that happens to execute. Best used for a
small number of scenarios describing business rules that non-developers need to read
and confirm. Worst used as your integration suite.

The failure mode is treating these as competitors and picking one. They answer different
questions: does this unit behave, does this system hold together, and do we agree on what
we're building.

## What we settled on

Pest and PHPUnit side by side for the application suite. That's where developers live,
and the mix is pragmatic rather than principled.

Then Selenium driving the browser for QA automation, with Gherkin sitting between the
two as the **contract** between the application test suite and the QA automation suite.
That word is the whole point, and it's the arrangement I'd recommend to anyone.

Gherkin isn't our integration suite and it isn't the developers' test framework. It's the
shared artefact both sides commit against. Developers know a scenario describes behaviour
they're responsible for; QA knows a scenario is what their automation is asserting; and
when the two disagree, the disagreement is about a sentence that both parties previously
agreed to, which is a very short argument.

Compare that with the usual arrangement, where developers have their tests, QA has their
automation, the two overlap in undefined ways, and nobody can say which suite owns a
given behaviour. That's the problem Gherkin solved for us, not coverage, not regression
safety, but jurisdiction.

## What seemed to help most

I want to be careful here, because I don't have numbers. We didn't measure rework rate
or cycle time before and after, so what follows is an impression formed from the inside
and should be read as one.

The change that seemed to matter wasn't a framework. It was writing acceptance criteria
as concrete examples before the ticket was estimated, and treating a story without them
as not ready.

The mechanism is unglamorous. A story with three concrete examples attached can be
tested by someone who wasn't in the conversation. A story described as "user can
manage approvals" cannot, so QA reconstructs intent by asking, which happens after
the code exists and therefore after the expensive part.

That's what "QA readiness" means in practice, and it's a writing discipline rather
than a tooling decision. Gherkin is one way to enforce it, and its syntax is a
convenient forcing function. A bulleted list of examples in the ticket gets you most
of the same benefit for none of the step-definition tax, which is the trade most teams
should probably make.
