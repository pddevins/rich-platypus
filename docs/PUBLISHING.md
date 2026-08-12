# Publishing

How a piece gets from an idea to a live URL on blog.devins.me.

Companion to `docs/WRITING-GUIDE.md`, which covers *what* to write. This covers
*how it ships*.

**Hosting:** GitHub builds this site itself (the classic Pages build, not an
Actions workflow) from the root of `main` in `pddevins/rich-platypus`, and serves
it at the domain in `CNAME`. There is no deploy workflow to maintain — pushing to
`main` is the deploy.

---

## The pipeline

| Stage | Tool | File lives in |
|---|---|---|
| 0. Capture / find the angle | `idea-wrangler` | `_drafts/` or just a pitch |
| 1. Scaffold | `/new-post` | `_drafts/<slug>.md` |
| 2. Draft | you, or `post-drafter` | same file |
| 3. Revise | `line-editor` | same file |
| 4. Preview | `jekyll serve` | same file |
| 5. Validate | `frontmatter-check` | same file |
| 6. Promote | `git mv` | `_posts/YYYY-MM-DD-<slug>.md` |
| 7. Publish | remove flag, push | same |

---

## 0–2. Idea to draft

```
"capture this: systemd-resolved ignores /etc/hosts wildcards"  → idea-wrangler
"what could I write about LoRa range testing?"                 → idea-wrangler (pitches)
/new-post                                                      → scaffold; asks kind/title/category/tags
/new-post build log about the LoRa gateway + <notes>           → scaffolds AND drafts
```

`/new-post` scaffolds only by default. Hand it notes, or say "and draft it", and
it chains to `post-drafter` to fill in the body of the same file.

Draft filenames carry **no date prefix**. Jekyll dates drafts at build time.

## 3–4. Revise and preview

```bash
bundle exec jekyll serve --drafts --unpublished --livereload   # localhost:4000
```

Both flags are needed at this stage. See **The two gates** below.

## 5. Validate

Run the `frontmatter-check` agent before promoting. It catches the things that
build wrong rather than loudly: comma-string categories, a category absent from
`_data/taxonomy.yml`, a missing `kind`, filename/`date:` disagreement, duplicate
slugs.

## 6. Promote

Posts **require** a `YYYY-MM-DD-` filename prefix, and it must agree with the
`date:` field.

```bash
git mv _drafts/lora-range-testing.md _posts/2026-08-11-lora-range-testing.md
```

Then set `date: 2026-08-11 09:00:00 -0400` to match.

Leave `published: false` in place and preview once more, now needing only one
flag:

```bash
bundle exec jekyll serve --unpublished
```

**Don't skip this.** While the file was in `_drafts/`, Jekyll invented a build-time
date, so its URL was fake. Now that it's in `_posts/` with the real filename, the
permalink is final — this is the moment to check the actual
`/2026/08/lora-range-testing/` URL, that it lands in the right bucket on
`/topics/`, and that the prev/next links point where you expect.

**Freeze the slug here.** See **Renaming a published post**.

## 7. Publish

Remove `published: false`, then:

```bash
git add -A
git commit -m "Add: LoRa range testing build log"
git push origin main
```

GitHub rebuilds and deploys automatically, usually in well under a minute. The
feed (`/feed.xml`) and sitemap regenerate on their own.

---

## The two gates

A piece is invisible in a normal build if **either** is true. They're
independent, which is deliberate — the redundancy is what stops a promoted post
from going live before you meant it to.

| Gate | Hidden because | Reveal with |
|---|---|---|
| Location | file is in `_drafts/` | `--drafts` |
| Front matter | `published: false` | `--unpublished` |

There's a third, easier to miss: **a post dated in the future is silently skipped**,
even in `_posts/` with no `published` flag. Use `--future` to see it, or fix the
date. Nothing warns you about this.

---

## Renaming a published post

Permalinks are `/:year/:month/:title/`, so the slug and the date are both part of
the URL. Changing either after publication breaks the old link and orphans it in
the feed and any external references.

If you must, keep the old URL working with `redirect_from:`:

```yaml
---
title: "The real cost of a dependency"
date: 2026-08-11 09:00:00 -0400
redirect_from:
  - /2026/08/the-old-slug/
---
```

That generates a page at the old path with a meta refresh and a canonical link to
the new one. `jekyll-redirect-from` is enabled in `_config.yml` and bundled with
the `github-pages` gem, so no Gemfile change is needed.

## Unpublishing

Re-add `published: false` and push. The page disappears on the next build and the
URL starts returning the 404 page.

Cheap mechanically, not cheap in practice — anything already linked or indexed
stays broken. Prefer correcting a post in place over withdrawing it.

---

## When a post doesn't show up

Work down this list; it's roughly ordered by how often each one is the cause.

1. `published: false` still set.
2. `date:` is in the future — Jekyll skips it without comment.
3. Filename is missing the `YYYY-MM-DD-` prefix, or the prefix disagrees with
   `date:`.
4. File is still in `_drafts/`.
5. `categories` isn't a one-item list, or names a slug missing from
   `_data/taxonomy.yml` — the post builds but is filed somewhere you didn't
   expect, and `/topics/` won't list it under any real label.
6. Front matter has a YAML error — an unquoted title containing a colon is the
   usual culprit.

Run `frontmatter-check` rather than working through these by hand.

## Local build notes

The build timezone is pinned to `America/New_York` in `_config.yml`. GitHub builds
in UTC, and without that pin an evening-dated post would land on a different day —
changing its permalink between your machine and production.

Only GitHub Pages' allowlisted plugins work here. Currently enabled:
`jekyll-feed`, `jekyll-seo-tag`, `jekyll-sitemap`, `jekyll-redirect-from`.
Anything else builds locally and then silently does nothing in production.
