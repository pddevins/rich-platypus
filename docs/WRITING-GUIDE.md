# Writing guide

The house style for blog.devins.me. This file is the source of truth for voice,
structure, and front matter. `CLAUDE.md` points here; the agents in
`.claude/agents/` are built to enforce it.

---

## 1. Voice

First person, past or present, never "we" unless someone else was actually
there. The reader is a competent peer who has not read the thing I read.

**Do:**

- Lead with the claim. The first paragraph says what I think and why it matters.
  No throat-clearing, no "in today's world," no defining terms the reader knows.
- Be concrete. Real numbers, real commands, real error messages, real hardware.
  "Latency dropped" is worthless; "p99 went from 340ms to 80ms" is a sentence.
- Admit the cost. Every recommendation has a downside — name it before the
  reader does.
- Show the failure. The version where it broke is more useful than the version
  where it worked.
- Use short sentences for the important parts. Save the long ones for texture.

**Don't:**

- Rhetorical questions as section openers. ("So what does this mean for
  privacy?")
- Hedging stacks: "it's arguably somewhat possible that."
- The tricolon reflex: "faster, cleaner, and more maintainable." Pick one, or
  earn all three.
- Em-dash-heavy asides everywhere. One per few paragraphs, tops.
- "Delve," "leverage," "robust," "seamless," "landscape," "in an era of,"
  "it's not just X, it's Y," "the harsh reality is."
- Ending on a summary of what was just said. End on the consequence instead.

**Length discipline:** if a paragraph can lose its first sentence and still
work, it should.

---

## 2. The four kinds

Every post declares a `kind`. It changes both how the piece is written and how
it renders.

### `post` — long-form (1500–3000 words)

Thesis in the opening. Subheads (`##`) that a reader can skim as an outline.
Ends with a takeaway section that gives the reader something to *do* or
*decide*, not a recap.

Shape: claim → why it's not obvious → evidence/walkthrough → objections →
what I'd do.

### `essay` — short-form argument (800–1500 words)

One argument, carried straight through. **No subheads.** No bullet lists. If it
needs an outline it's a `post`. Renders with a drop cap, so the first sentence
carries visual weight — make it a good one.

Shape: provocation → the reasoning → the strongest counterargument, taken
seriously → where that leaves me.

### `log` — build log (600–2000 words)

Chronological. What I set out to do, what I actually did, what broke, what I'd
do differently. Commands are copy-pasteable and include the flags. Error output
goes in fenced blocks verbatim, not paraphrased.

Required last section: **What I'd do differently.** A build log without it is
just a changelog.

### `note` — idea or TIL (100–500 words)

A thought captured fast. Allowed to be unfinished, allowed to be wrong, not
allowed to be vague. One idea per note. No preamble at all — start at the
insight.

Notes render compactly on the index with no excerpt, so the title has to carry
the whole thing. "TIL about systemd" is a bad title. "systemd-resolved silently
ignores /etc/hosts for wildcard entries" is a good one.

A note may later be promoted to a `post` or `essay`. When that happens, keep the
note and link forward to the longer piece.

---

## 3. Front matter contract

Every post in `_posts/` gets exactly this shape:

```yaml
---
layout: post              # always "post", even for essays/logs/notes
kind: essay               # post | essay | log | note
title: "Privacy Matters"  # quoted; sentence case or title case, be consistent
subtitle: "One line that earns the click without overselling."
date: 2026-01-22 12:00:00 -0400
categories: [privacy]     # EXACTLY ONE, from _data/taxonomy.yml
tags: [digital-rights, anonymity]
published: false          # omit or set true to publish
---
```

**Rules that are not negotiable:**

1. `categories` is a YAML **list with exactly one entry**, and that entry must
   already exist in `_data/taxonomy.yml`. Never write
   `categories: privacy, digital-rights` — Jekyll reads that as one category
   literally named `privacy, digital-rights`. This was the original bug on this
   blog.
2. Topic breadth lives in `tags`, not `categories`. Reuse an existing tag from
   `_data/taxonomy.yml` before inventing one; if you invent one, add it there.
3. Adding a new category means editing `_data/taxonomy.yml` **first** — layouts
   read labels and descriptions from that file, and an unlisted slug renders as
   a bare lowercase word.
4. `subtitle` is the standfirst. It shows on the index and under the title. Make
   it a claim, not a topic label.
5. Filename must be `YYYY-MM-DD-slug-matching-the-title.md`. Permalinks are
   `/:year/:month/:title/`, so **changing a published slug breaks its URL**.
   If you have to, add a `redirect_from:` to keep the old path alive — see
   "Renaming a published post" in `docs/PUBLISHING.md`.
6. `<!--more-->` marks the excerpt boundary. Put it after the first paragraph or
   two if there's no `subtitle`.

---

## 4. Markdown conventions

- `##` for sections, `###` for subsections. Never `#` — the layout renders the
  title as the only `h1`.
- `####` renders as a small-caps label, useful for tiny asides. Use sparingly.
- Fenced code blocks always carry a language: ```bash, ```yaml, ```rust.
- Links: descriptive text, never "click here" and never a bare URL in prose.
- Footnotes via kramdown (`[^1]`) for sources and tangents. They're styled.
- `<hr>` (`---`) renders as a centered asterism — a real section break, not a
  divider between every heading.
- Blockquotes may carry a `<cite>` element; it's styled as a small-caps
  attribution line.
- Images: wrap in `<figure>` with a `<figcaption>`. Add `class="wide"` to break
  the text measure for diagrams and screenshots.
- Tables are set in the sans stack and get small. If it needs more than four
  columns, it wants to be a list.

---

## 5. Titles

Titles are indexed, shared, and read out of context. They should state the
subject, not tease it.

- Good: "systemd-resolved ignores /etc/hosts for wildcards"
- Good: "Your threat model is not my threat model"
- Bad: "Some thoughts on DNS"
- Bad: "The Surprising Truth About Privacy"

No colons-as-subtitle in the title itself — that's what `subtitle` is for.

---

## 6. Before publishing

- [ ] `kind` set, and the piece actually obeys that kind's shape.
- [ ] `categories` is a one-item list with a slug from `_data/taxonomy.yml`.
- [ ] Filename date and `date:` agree; slug matches the title.
- [ ] `subtitle` makes a claim.
- [ ] Every code block runs as written, with a language tag.
- [ ] No word from the "Don't" list in §1 survived.
- [ ] `published: false` removed.
