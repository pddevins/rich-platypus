---
name: new-post
description: Scaffold a new draft for blog.devins.me with correct front matter and the right skeleton for its kind (post, essay, log, or note). Use when the user says "new post", "start a draft", "scaffold an essay", or names a topic they want to start writing about. Optionally hands off to the post-drafter agent to fill in the body when notes are supplied or prose is explicitly requested.
---

# New post

Create a correctly-shaped draft in `_drafts/`. **Scaffolding is the default** —
write front matter and a skeleton of prompts, not prose. Generate body content
only via the handoff in step 6, and only when that step's conditions are met.

## Steps

1. Read `_data/taxonomy.yml` for the valid categories and suggested tags.
2. Determine four things. Ask only about what you can't reasonably infer from
   what the user already said:
   - **kind** — `post`, `essay`, `log`, or `note` (see the table below)
   - **title** — states the subject, no colon-subtitle
   - **category** — exactly one slug from the taxonomy
   - **tags** — one to three, reused from the taxonomy where possible
3. Write `_drafts/<slug>.md`. No date prefix — Jekyll dates drafts at build
   time, and a date prefix in `_drafts/` is a lint error here.
4. Use the front matter block and the skeleton for that kind, below.
5. Tell the user the path and how to preview:
   `bundle exec jekyll serve --drafts`
6. Only if the conditions below are met, hand off to `post-drafter` to fill in
   the body. See **Handing off to post-drafter**.

## Choosing the kind

| kind    | words     | shape                                              |
|---------|-----------|----------------------------------------------------|
| `post`  | 1500–3000 | subheads, thesis up front, takeaway at the end     |
| `essay` | 800–1500  | one argument, **no subheads**, renders a drop cap  |
| `log`   | 600–2000  | chronological, real commands, "What I'd do differently" required |
| `note`  | 100–500   | one insight, no preamble, title carries the piece  |

## Front matter

Always exactly this, with `published: false` retained:

```yaml
---
layout: post
kind: <post|essay|log|note>
title: "<Title>"
subtitle: "<One line that makes a claim, not a topic label>"
date: <YYYY-MM-DD HH:MM:SS -0400>
categories: [<one-slug-from-taxonomy>]
tags: [<tag>, <tag>]
published: false
---
```

`categories` must be a one-item list. `categories: a, b` is a single category
named `"a, b"` — never write it that way.

## Skeletons

**`post`** — leave the headings as prompts, not filler prose:

```markdown
<Opening paragraph: the claim, and why it matters. No throat-clearing.>

<!--more-->

## <Why this isn't obvious>

## <The evidence, or the walkthrough>

## <The strongest objection>

## What I'd do

<Something to do or decide. Not a recap.>
```

**`essay`** — no headings at all:

```markdown
<First sentence carries a drop cap. Make it land.>

<!--more-->

<The reasoning, carried straight through.>

<The counterargument, taken seriously.>

<Where that leaves me.>
```

**`log`** — note the 4-backtick outer fence; this skeleton contains code blocks
of its own, and a 3-backtick wrapper would be closed early by the first of them:

````markdown
<What I set out to do, and why.>

<!--more-->

## The setup

```bash
# real commands, real flags
```

## What broke

```
<verbatim error output — never paraphrased>
```

## What I'd do differently

<Required. A build log without this is a changelog.>
````

**`note`** — start at the insight:

```markdown
<The insight, immediately. Three sentences is a complete note.>
```

## Handing off to post-drafter

Scaffold-and-stop is the default. Hand off **only** when one of these is true:

- The user explicitly asked for prose — "and draft it", "write it up", "fill it
  in", "expand these".
- The user supplied substantive raw material to work from: notes, an outline,
  bullet points, a transcript, pasted logs, a link dump.

**A topic by itself is not raw material.** "New post about LoRa range testing"
is a scaffold request. The same sentence plus a page of notes is a draft
request. When it's ambiguous, scaffold first, then ask whether to draft — that
ordering is cheap to recover from, and the reverse isn't.

### The one thing that will go wrong

`post-drafter` creates its own file in `_drafts/` by default. If you hand off
without telling it the file already exists, you get **two drafts of the same
piece** with slightly different slugs. Always pass the exact path and an
instruction to edit in place.

Spawn it with the Agent tool (`subagent_type: post-drafter`) and give it, at
minimum:

- the exact path of the file you just created
- the front matter you already set (kind, title, category, tags)
- the user's raw material **verbatim** — never summarize it first; paraphrasing
  is where invented detail creeps in
- an instruction to edit that file in place and not create a new one

Sample handoff prompt:

> Fill in the body of the existing draft at `_drafts/lora-range-testing.md`.
> It already has correct front matter (`kind: log`, `categories: [electronics]`,
> `tags: [lora, sensors]`). Keep that front matter and edit this file in place —
> do not create a new file.
>
> If the material can't sustain `kind: log`, change the `kind` field in that
> same file and say so in your report rather than starting a new draft.
>
> Follow `docs/WRITING-GUIDE.md`. Patrick's raw notes, verbatim:
>
> [notes]

### After the handoff

Relay `post-drafter`'s report to the user — specifically every `TODO:` marker it
left and anything it flagged for verification. Those are the whole point: they
mark where the piece needs a real number, a real command, or a real error
message that neither of you can invent.

Do not remove `published: false`, and do not move the file to `_posts/`.

## Rules

- Read `docs/WRITING-GUIDE.md` if you're writing any actual prose.
- Don't write body prose inline in this skill. Delegate it via step 6, so the
  anti-fabrication rules in `post-drafter` actually apply to it.
- Never create the file in `_posts/` — new work starts in `_drafts/`.
- Never remove `published: false`; publishing is the user's call.
- If the category the user wants doesn't exist in `_data/taxonomy.yml`, add it
  there first (slug, label, description), then use it.
- If a file with that slug already exists in `_drafts/` or `_posts/`, stop and
  ask rather than overwriting.
