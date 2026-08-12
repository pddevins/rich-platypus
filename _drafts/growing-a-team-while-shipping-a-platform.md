---
layout: post
kind: post
title: "Growing a team while shipping a platform"
subtitle: "Three developers to twenty-one, one QA to eight, and a compliance problem developers could not solve alone."
date: 2023-06-30 17:00:00 -0400
categories: [leadership]
tags: [teams, consulting, career]
published: false
---

The most useful thing I learned this year is that scaling a team and scaling a system
fail for the same reason. Both break at the interfaces, not inside the components. I
spent twelve months architecting a multi-national marketing platform and growing the
team building it, and every genuinely hard problem in both was a handoff.

<!--more-->

I can't say much about the client. What I can describe is the shape of the problem,
because the shape is what made it interesting: a platform for producing marketing
material for healthcare professionals and patients, across multiple countries, where
every asset has to be legally compliant in the jurisdiction it's used and every claim
has to be traceable to something approved.

That last constraint is the one that reorganises everything. In an ordinary content
system, a user makes something and publishes it. Here, a user assembles something from
approved components, and the system's real job is to make the compliant path the easy
path, because if it's not, people will do the work in Word and email it around, and
you've made a very expensive way of not solving the problem.

Designing a full system under that constraint was the best technical work I've had in
years, and not because it was novel. It's that the requirements were sharp. When "this
claim must be approved for this market" is a hard rule rather than a preference, most
architectural arguments resolve themselves. You stop debating taste and start deriving
structure from something nobody can wave away.

I'm going to leave the architecture there deliberately. The specifics of how compliance
and approval are modeled are exactly the details that would be useful to somebody
looking for a way around them, and a blog post is a poor place to publish the shape of a
control system.

## Talking to users directly

Nothing on this project mattered more than being able to speak to the people using it
without a layer in between.

The loop was short enough to be qualitatively different. Someone describes a frustration
on a call; you understand the workflow behind it rather than the feature they asked for;
a change goes out; they tell you within days whether it helped. Most projects I've
worked on have a version of that loop measured in quarters and filtered through three
summaries, and by the time feedback arrives it has been converted into a feature request
that no longer contains the problem.

The thing I'd tell anyone who gets this access: what users ask for is a solution they've
already designed, usually badly, from a position of not knowing what's possible. The job
on that call isn't to write down the request. It's to keep asking what they were trying
to do until you reach the part that's actually theirs, and then solve that.

## Three to twenty-one, one to eight

The team grew from three developers to twenty-one, and from one QA engineer to eight,
inside the year.

The naive expectation is that this is a hiring problem. It isn't. Hiring is a throughput
problem with a known solution. Two other things broke instead, and both were invisible
until they weren't.

**Knowledge transfer of the domain.** A three-person team runs on shared context —
everyone knows why the thing is built that way because they were there. That mechanism
has no path to twenty-one and it doesn't degrade gracefully. It works, and then one day
someone makes a locally sensible decision that contradicts a constraint they'd never
been told about, because the person who knew it had never had to say it out loud. In a
domain where the constraints are regulatory rather than technical, that's expensive.

**Velocity and developer interoperability on a single task board.** This is the one I'd
warn people about hardest, because it looks like an administrative detail. Twenty-one
developers against one board produces constant low-grade collision: people picking up
work adjacent to what someone else is already changing, merge conflicts as a routine
event rather than an exception, and no way to see at a glance whether a domain was
progressing or stalled.

What fixed it was structural. I was made overall technical lead, and the team split into
groups of three to five developers, each focused on one cluster of interconnected
domains, each with its own board. Small enough to keep running on shared context, which
is the thing that works at that size, and bounded enough that two groups rarely reached
for the same code.

That made my job the seams rather than the features: flagging where two groups' domains
overlapped before both had built something, keeping momentum where a group had quietly
stalled, and aligning with stakeholders and QA on end-to-end behavior that no single
group owned. Nobody inside a group of four can see that. It has to be somebody's actual
job.

The other thing that had to get built was everything that felt like bureaucracy at
three: written decisions, explicit ownership, an onboarding path that doesn't require a
specific person's attention, and a definition of done that a new QA engineer can apply
without having absorbed a year of institutional memory.

The QA growth is the part I'd point at hardest. Going from one to eight wasn't about
finding more bugs. It was about moving QA from the end of the process into the middle of
it, where the feedback still costs something to act on but not very much.

Two things drove that number, and neither one is "we wrote buggy code."

The first is combinatorial. Every asset, multiplied by every jurisdiction, multiplied by
every locale, is a test surface that grows faster than the feature set does. Adding a
market doesn't add one market's worth of testing. It adds a column to every row that
already existed. Automation absorbs a great deal of that, and then hits the part where a
person has to judge whether a rendered claim reads correctly in a specific language
inside a specific regulatory context. That judgment doesn't automate.

The second is that QA owned considerably more than testing. Content validation, approval
workflow checks, and release gating all sat with them, which put the function closer to
compliance operations than to classical QA. Calling all eight of them "QA" undersells
the job, and it's why the ratio looks strange from outside and made complete sense from
inside.

## Scrum masters and product owners who teach

The last thing, and the one I didn't expect to be writing about: I got to work with
scrum masters and product owners who were willing to both trust me and teach me.

Trust and teaching usually arrive separately. Plenty of people will hand you the work
and stay out of the way; plenty of others will explain the process at length while
keeping a hand on the wheel. Getting both from the same person is rare, and it is the
difference between orchestrating a workload and merely being responsible for one.

What I took from it is mostly about ceremony. I had arrived with the standard engineer's
contempt for process, which is a defensible position when the process is imposed by
people who don't do the work and an expensive one otherwise. Watching good practitioners
use the same ceremonies to surface disagreement early, rather than to report status
upward, changed my view. The ritual isn't the point. The ritual is a scheduled
opportunity for someone to say they're worried, and a team of thirty needs those
scheduled because they no longer happen by accident.

---

The through-line, and the reason both halves of this year belong in one post: at three
people, the system and the team can both survive on things nobody wrote down. At thirty,
everything that isn't explicit is a coin flip. The work of the year was making things
explicit (approvals in the platform, decisions in the team) and those are the same job
wearing different clothes.
