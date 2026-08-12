---
layout: post
kind: post
title: "Where I landed on Claude Code"
subtitle: "Fifteen months after writing that I wasn't sold, I use it daily. The time savings are roughly a wash, and that isn't the reason."
date: 2026-06-27 15:00:00 -0400
categories: [engineering]
tags: [ai-tooling, developer-experience, php]
published: false
---

Fifteen months ago I wrote that AI developer workflows optimize a step that was never my
bottleneck, and that generating code I then have to understand moves effort from the
thing I'm fast at to the thing I'm slow at. I still think that was correct about the
workflow I was describing. I now use Claude Code every working day, and the reason has
almost nothing to do with the argument I was having.

<!--more-->

## What changed, and what didn't

I'll start with the part that survived, because I don't want to pretend I was simply
wrong.

**You are still the architect.** Nothing about this arrangement chooses between two
designs, decides what the client actually needs, or tells you which of two subsystems
should own a responsibility. Those remain judgment calls made by someone who understands
the business and the codebase, and delegating them produces work that looks finished and
is structurally wrong.

**You still have to do the research.** Understanding how an application is put together
— where the seams are, which patterns are deliberate, what a change ripples into — is
still the job, and it's still done by reading and thinking. An agent working in a
codebase you don't understand produces changes you can't evaluate, which is the
confident-wrongness problem from March, arriving exactly as advertised.

**You still have to plan.** The single largest difference between a session that
produces something good and a session that wastes an afternoon is whether I knew what I
wanted before I started.

What changed is that I stopped using it to write features and started using it to
interrogate them.

## The thing it's good at

The capability that won me over is finding interactions I wouldn't have looked for.

A change to a service touches a queued job that touches an observer that fires on a
model that a scheduled command also updates. In a mature application these chains exist
in numbers no one holds in their head, and traditional workflows catch them through a
combination of tests, review, and eventually production. What I get now is a systematic
pass over the actual call graph, asking what else touches this, and it surfaces the
esoteric ones. Not the obvious dependencies, which I'd find. The fourth-order ones that
historically fell through the gaps and turned up six weeks later as a bug nobody could
reproduce.

That's the same class of work a very thorough senior reviewer does on a good day, done
consistently rather than when someone has time.

A concrete one, sanitized. While tracing an unrelated bug, the pass flagged an export
action calling a relationship that didn't exist on the model it was called against —
singular where the relation was plural. Valid-looking code, no static analysis
complaint, and a `BadMethodCallException` waiting for the first person to click that
particular export button. It had presumably been sitting there for months. Nothing in a
normal workflow was going to find it: it wasn't in the diff being reviewed, it wasn't on
any path the tests covered, and it wasn't what anyone was looking for. It surfaced
because the sweep didn't know it was supposed to stay on topic.

That's the shape of the value. Not "wrote my feature." Found a latent runtime error in a
code path adjacent to the one I was working in.

Edge cases follow the same pattern. Asking what inputs break this, with an instruction
to be exhaustive rather than helpful, produces a list where most items are irrelevant
and two are things I hadn't considered. The hit rate is low and the cost of reading a
list is also low, which is a fine trade. It's the inverse of the code-generation trade I
objected to, where the cost of evaluating the output was high.

The other category worth naming is specification ambiguity caught at planning time. A
requested report asked for a total "sold online," which sounds unambiguous until you
notice the data model has no online/offline distinction in it at all. Every sale is
simply a sale. The number was computable, but it could not mean what the person asking
believed it meant. Surfacing that during planning cost a conversation. Surfacing it
after delivery would have cost trust in every figure on the page.

## Skills and instructions are what make it work

Out of the box, none of the above happens reliably. What makes the difference is
persistent, project-scoped instructions — the same codified workflows I wrote about last
October.

Concretely: the project's conventions and non-obvious structure written down, review
criteria stated explicitly, and named workflows for the checks I want performed the same
way every time. Without those, each session starts from zero and I spend the first
twenty minutes re-establishing context I've already established a hundred times. With
them, the useful work starts immediately and the output matches the project rather than
matching a generic framework tutorial.

That's the actual dependency, and it's why I think a lot of people bounce off these
tools. The capability is real and it is gated behind an investment in writing your
process down, which is unglamorous and which nobody's demo shows.

## The honest accounting on time

The time savings are a wash. I want to be specific about that, because it's the claim
most often made and least often measured.

The wins are real: mechanical work is faster, boilerplate consistent with project
conventions appears in seconds rather than minutes, and the review pass described above
would take me an hour by hand.

The losses are also real, and they're lumpier. There are sessions where I spend hours
iterating on a feature (refining, correcting, re-explaining) and end up discarding all
of it and writing the thing myself in forty minutes. Those are expensive precisely
because they don't feel like failure while they're happening. Each iteration looks like
progress. The sunk cost accumulates quietly, and the point at which I should have
stopped is only visible afterwards.

It's roughly the usual eighty-twenty: four sessions in five land somewhere useful, and
the fifth is a write-off. I'd expected that ratio to improve as I got better at this,
and it mostly hasn't — what's improved is how quickly I recognize which kind of session
I'm in.

The gaps are usually comprehension gaps. When a feature depends on understanding *why*
the application is shaped a particular way (a constraint that lives in a client
conversation, a deliberate inconsistency with a reason) the output will be locally
sensible and globally wrong, and no amount of further refining fixes it, because the
missing thing isn't in the codebase to be found.

I've learned to recognize the smell earlier: when the second correction is about the
same misunderstanding as the first, stop and write it myself. That single rule has
recovered most of the wasted time.

Net across the whole stretch: I'd call it even on hours, and comfortably ahead on
defects that didn't reach a client.

## Why I still use it, given all that

Because the products are more stable, and stability is worth more than speed on client
work.

The specific mechanism is that problems move earlier. An interaction found while I'm
still holding the design in my head costs a rethink. The same interaction found in QA
costs a ticket and a context switch; found by a client, it costs credibility. The value
isn't the hours, it's the stage at which things surface — which is the same argument I
made for test-driven development a couple of years back, and it's a little embarrassing
that I didn't recognize it sooner.

It doesn't replace anything. I'm doing the same architecture, the same research, the
same planning, and I'm still responsible for every line that ships. What it does is
raise the floor on thoroughness, on the days when my own floor is lower than I'd like.

That's a real improvement and a much smaller claim than the one being marketed. I'd
rather make the smaller claim accurately.
