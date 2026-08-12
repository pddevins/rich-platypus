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
- Em-dash-heavy asides everywhere. See the per-era budget in §1b; the ceiling is
  low and it is easy to blow past without noticing.
- "Delve," "leverage," "robust," "seamless," "landscape," "in an era of,"
  "it's not just X, it's Y," "the harsh reality is."
- Ending on a summary of what was just said. End on the consequence instead.

**Length discipline:** if a paragraph can lose its first sentence and still
work, it should.

### Punctuation tells

These are the marks that make prose read as machine-generated, in rough order of
how much damage they do:

- **The em dash.** The single strongest tell, because a model reaches for it
  wherever a comma, colon, period, or parenthesis would do. Per-era budgets are in
  §1b.
  Before writing one, check whether the sentence wants a period instead.
- **Paired em dashes around a list.** `— a, b, c —` is the worst case. Use
  parentheses; the commas inside need the dash not to be there.
- **Semicolons in narrative prose.** Fine in a list of clauses, suspicious as a
  substitute for a full stop.
- **Colon-as-drumroll**, more than once or twice in a piece.
- **Uniform paragraph length.** Three-to-four-sentence paragraphs all the way
  down is a rhythm no human sustains.

### American English

Patrick is American and writes American English. Use `-ize` and `-or` endings,
American vocabulary, and American date phrasing.

behavior, color, recognize, optimize, standardize, organization, emphasize,
license, program, gray, judgment, toward, two weeks. Not behaviour, colour,
recognise, optimise, licence, programme, grey, judgement, towards, fortnight.

This catches models out constantly, because the British forms are common in
training data. Grep before publishing:

```bash
grep -rniE '\b(behaviour|colour|favour|honour|fortnight|whilst|amongst|learnt|licence|programme|defence|centre|judgement|towards|grey)\b|\b(recognis|optimis|organis|emphasis|realis|apologis|sanitis|standardis|categoris|prioritis|summaris|specialis|utilis|practis)(e|es|ed|ing|ation|ations)\b' _drafts/ _posts/
```

Note the second half matches only the verb endings. A bare `optimis` or `realis`
prefix also matches "optimistic" and "realistic", which are correct.

A fixed word list will always miss some, because the British forms take prefixes
(`reorganise`) and appear as nouns (`tokenisation`, `equalisation`). The reliable
method is to enumerate every candidate and subtract the ones American English
keeps:

```bash
grep -rhoE '\b[A-Za-z]+is(e|es|ed|ing|ation|ations)\b' _drafts/*.md \
  | tr 'A-Z' 'a-z' | sort -u
```

Everything that comes back is British unless it is on this list, which is close to
exhaustive for American English: advertise, advise, arise, chastise, comprise,
compromise, concise, despise, devise, disguise, excise, exercise, franchise,
improvise, merchandise, noise, otherwise, paradise, poise, praise, precise,
premise, promise, raise, revise, rise, supervise, surprise, unwise, wise,
enterprise, expertise.

"Fortnight" in particular is a word he has never used.

### Never name where he lives

Patrick has lived in the American South since 2015. **Do not name the state or the
city, ever**, in a post or in front matter.

- Refer to the region as "the American South", or write around it: "southern
  summer", "it gets hot here", "a Southerner".
- Never write a state name even for somewhere he used to live. Earlier locations
  are still locating information when combined with a date.
- The exception is genuine contextual necessity, which is rarer than it sounds. If
  the post works without the place name, drop it.

This is a privacy blog whose author writes about minimizing his own locator data.
Publishing a state plus a school district plus a date is exactly the Tier 3
material the OSINT posts tell readers to protect.

```bash
grep -rniE '\b(alabama|arkansas|carolina|florida|georgia|kentucky|louisiana|mississippi|tennessee|texas|virginia)\b' _drafts/ _posts/
```

### Phrases to ration, not ban

Each of these is fine once in a piece and a tell by the third use. Grep before
publishing.

`actually` · `genuinely` · `precisely` / `exactly` · `worth noting` /
`worth saying` · `the whole point` / `the entire point` · `which is the ...` ·
`load-bearing` · `does the work` · `the honest version` / `the honest answer` ·
`in practice` · `I want to be careful/clear/honest about` · `unglamorous`

Two structural habits in the same category:

- **`Not X. It's Y.`** as an emphasis device. Once per piece.
- **The callback** — repeating your own keyword one or two sentences later to
  close a loop. Reads tidy, and nobody speaks that way.

---

## 1b. The style gradient

The blog runs from 2020 to now, and the writing is supposed to get better across
that span. Not *good then bad*, and not a different writer — the same voice
gaining confidence. Earlier posts are plainer and explain themselves. Later ones
compress, trust the reader, and use punctuation deliberately rather than
avoiding it.

**When you add or edit a post, its style must sit between the post before it and
the post after it in date order.** Not the newest post, and not your default
register. Its neighbours.

To find them:

```bash
grep -h '^date:' _posts/*.md _drafts/*.md | sort
```

Read the nearest post on each side before writing. The targets:

| Era       | Avg sentence | Em dash / 1k words | Register |
|-----------|--------------|--------------------|----------|
| 2020–2021 | 13–18        | 0–1                | Plain and declarative. Short sentences. Defines its terms. Few fragments for emphasis. Sincere rather than dry. |
| 2022–2023 | 15–20        | ≤2                 | More rhythm variation. Starts taking the counterargument seriously in its own section. |
| 2024–2025 | 16–21        | ≤4                 | Confident compression. Concede-then-pivot structure. Dry humour. Leaves some inferences to the reader. |
| 2026+     | 17–23        | ≤5                 | Assured. Opens mid-thought. Implication over statement. Em dashes used on purpose, sparingly. |

Measure rather than guess:

```bash
ruby docs/style-gradient.rb          # per-post and per-year figures
```

Two rules that matter more than the numbers:

1. **Never edit an old post up to the current register.** If a 2020 post reads
   plainly, that is correct. Fix errors, not sophistication.
2. **A backdated post must match its date, not today.** Writing a 2021 entry now
   means writing it the way it would have been written then: shorter sentences,
   no em dashes, less irony.

The table is guidance for a piece as a whole. A single long sentence in a 2020
post is fine; a 2020 post whose average is 21 is not.

## 2. The five kinds

Every post declares a `kind`. It changes both how the piece is written and how it
renders. Word ranges are defined in `_data/taxonomy.yml`; the numbers below track
it.

### `post` — long-form (650–3000 words)

Thesis in the opening. Subheads (`##`) that a reader can skim as an outline.
Ends with a takeaway section that gives the reader something to *do* or
*decide*, not a recap.

Shape: claim → why it's not obvious → evidence/walkthrough → objections →
what I'd do.

### `essay` — short-form argument (600–1500 words)

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

### `brief` — short technical piece (400–900 words)

One job: release notes, an upgrade path, a single comparison. Subheads allowed,
unlike a note. No thesis required, because it is reference rather than argument.

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
layout: post              # always "post", whatever the kind
kind: essay               # post | brief | essay | log | note
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
