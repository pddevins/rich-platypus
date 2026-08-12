---
layout: post
kind: essay
title: "I'm not sold on AI developer workflows"
subtitle: "The demos are all greenfield, the bottleneck was never typing, and confident wrongness is the expensive failure mode."
date: 2025-03-08 11:00:00 -0500
categories: [engineering]
tags: [ai-tooling, developer-experience]
published: false
---

Every demonstration of AI-assisted development I have watched builds something new,
small, and unconstrained. A todo app. A scraper. A landing page. That is not a
coincidence and it is not a limitation of demo formats — it is the shape of problem
these tools are genuinely good at, and it bears almost no resemblance to what I do on
a Tuesday.

<!--more-->

What I actually do is arrive at a system with eight years of accumulated decisions,
some of which are load-bearing and undocumented, and change one behaviour without
breaking four others. The hard part of that is not producing code. It never was. The
hard part is building an accurate model of what already exists, and then finding the
smallest change consistent with it. Typing has never been my constraint. On the days
I feel slowest, I am not typing at all.

So when a tool promises to write the code faster, my honest reaction is that it's
optimising a step that wasn't the problem, and I've been around long enough to be
suspicious of that specific offer. We've had it before. Code generation, scaffolding,
visual builders, the whole lineage. Each was real, each helped somewhere, and each was
sold as a change in kind when it was a change in degree.

The deeper worry is about review. Reading code is slower than writing it — this is
not controversial, it's why code review is the bottleneck on every team I've worked
on. A tool that produces plausible code shifts my work from the thing I'm fast at to
the thing I'm slow at, and it does so while removing the context that makes review
possible. When I write a function, I know which cases I considered and which I
dismissed. When I review a generated one, I know neither, so I have to reconstruct the
reasoning from the artefact. That reconstruction is the expensive part, and it is
precisely what gets skipped when a change looks fine.

Which brings me to the failure mode I actually fear, which is not that these tools are
wrong. Wrong is fine. Compilers are wrong, libraries are wrong, I am wrong several
times a day, and all of that is survivable because the wrongness is usually loud. What
worries me is confident wrongness with correct syntax and plausible naming — code that
passes review because it looks exactly like code that works. That is a genuinely new
category. A junior developer's mistakes announce themselves. This doesn't.

I'm also unconvinced by the time-savings arithmetic, mostly because nobody doing the
claiming seems to have measured it. The measurable part is the minutes spent producing
a first draft. The unmeasured parts are the review, the debugging of a subtly wrong
implementation, the occasional discovery three hours in that the approach was
structurally unsuited and the whole thing needs discarding. I've had that last
experience with my own work often enough to know it dwarfs the drafting time when it
happens. Any honest accounting has to include the sessions that end in nothing.

There's a longer-term version of this that I find harder to dismiss than the practical
objections. The ability to review generated code well is downstream of having written a
lot of code badly and then fixed it. That's how the pattern recognition gets built.
If the drafting step is delegated early enough, I don't know where the reviewing
ability is supposed to come from — and it is the reviewing ability, not the drafting,
that the whole arrangement depends on. That's a bet on a skill remaining available
while removing the process that produced it, which is at minimum worth saying out
loud.

Now the honest part, because I'd rather be accurate than consistent. I'm aware that
"the bottleneck is understanding, not typing" is exactly what someone says immediately
before a tool starts helping with understanding. And I've noticed my objections are
mostly about a particular usage pattern — generate a feature, review the diff — rather
than about the underlying capability. There are shapes I haven't seriously tried. Using
one of these things to explain an unfamiliar codebase to me, rather than to write in
it. Using it to enumerate cases I might have missed, where being wrong is cheap because
I'm the one deciding what to do with the list. Those aren't the same offer, and I've
been rejecting the whole category on the strength of the version I like least.

So the position I'll actually commit to is narrower than the one I started with.
Generating code that I then have to understand is a bad trade for the work I do,
because it moves effort from my fast activity to my slow one and hides the reasoning I
need. But that's a claim about one workflow, not about the tools. If something can
compress the understanding step rather than the typing step, that would be
addressing the real constraint, and I'd want to know.

For the record, this isn't abstract. I've been running Cursor, Junie, Codex, and Claude
against real work, not reading about them — which is the only reason I feel entitled to an
opinion, and also why the opinion is narrower than it started. Four tools, four different
bets on what a developer needs, and my complaint lands on the same part of all of them.

I want to be precise about the kind of skeptic I am, because there's a hostile version of
this position and it isn't mine. I'm not opposed to any of this on principle, and I'd
happily be shown wrong. What I object to is the size of the claims relative to the evidence
offered for them. "Developers are 40% faster" is the kind of statement that would be easy
to demonstrate and is almost never demonstrated — no methodology, no baseline, no control
for the review time it moves rather than removes. I've spent enough of my career watching
confident numbers arrive without workings to treat that pattern as informative on its own.

So: not hostile, and not sold. Show me a reproducible result on work that resembles mine
and I'll change my mind, which is the only honest position available before the evidence
exists. I'd rather find out by trying the version I've been dismissing than by continuing
to be right about the version I've already rejected.
