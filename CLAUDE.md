# blog.devins.me

Personal blog. Jekyll, served by GitHub Pages from the `main` branch root.

**Before writing or editing any post, read `docs/WRITING-GUIDE.md`.** It is the
source of truth for voice, the four post kinds, and the front matter contract.
Do not infer house style from the existing posts — most of them are still
scaffolding.

---

## Repo map

```
_config.yml              site config, front matter defaults, exclude list
_data/taxonomy.yml       controlled vocabulary: kinds, categories, tags
_layouts/                default, home, post, page, archive
_includes/               head, site-header, site-footer, post-meta, post-card
assets/css/main.scss     the entire stylesheet (no theme inherited)
_posts/                  published + unpublished posts
_drafts/                 work in progress (not built unless --drafts)
docs/WRITING-GUIDE.md    house style — read this before writing
docs/PUBLISHING.md       draft → live URL: the two gates, promotion, redirects
docs/post-template.md    copy this into _drafts/ to start a piece
topics.html              category index, driven by _data/taxonomy.yml
writing.html             full archive, grouped by year
```

## Commands

```bash
bundle install
bundle exec jekyll serve --drafts --unpublished --livereload   # localhost:4000
bundle exec jekyll build                                        # sanity check
```

Local Ruby on this machine is 2.6 and the `github-pages` gem needs 2.7+, so
`bundle install` may fail until a newer Ruby is installed (e.g. via `rbenv`).
If you cannot build locally, say so rather than claiming a change is verified.

---

## Hard rules

1. **GitHub Pages only supports its allowlisted plugins.** This site uses
   `jekyll-feed`, `jekyll-seo-tag`, `jekyll-sitemap`. Adding any other gem
   plugin will build locally and then silently fail to apply on Pages. If a
   feature needs a plugin, do it in Liquid instead.
2. **`categories` is a one-item YAML list**, and the slug must exist in
   `_data/taxonomy.yml`. `categories: a, b, c` is a single category named
   `"a, b, c"` — this was a real bug here. Add new categories to the taxonomy
   file before using them.
3. **Root-level `.md` files become public pages.** GitHub Pages enables
   `jekyll-optional-front-matter`, so any new doc at the repo root must be added
   to `exclude:` in `_config.yml` or it will publish.
4. **Filename case collides.** macOS is case-insensitive: a root-level
   `WRITING.md` and `writing.md` are the same file. Don't create a doc whose
   name differs from a page only by case.
5. **Don't change a published post's slug or date.** Permalinks are
   `/:year/:month/:title/`. Renaming breaks the URL and the feed.
6. **No third-party requests, ever.** No webfonts, no analytics, no CDN scripts,
   no embeds that phone home. Type comes from system serif stacks. This is a
   privacy blog; the site should be able to pass its own standard.
7. **Sass is old.** GitHub Pages pins an old Ruby Sass. In `main.scss`, avoid
   `@use`, Sass maps, `/` division, and the CSS `min()`/`max()` functions (they
   collide with Sass built-ins). `clamp()` with literal values is safe. Nesting
   is safe.

---

## Design system

Editorial/typographic. Warm paper background, system serif display type, a
short brick-red accent rule under post titles, small-caps sans metadata, ~39rem
measure. Light and dark are both first-class via `prefers-color-scheme`; every
color is a custom property defined once in `:root` and overridden in the dark
media query — never hardcode a hex value outside those two blocks.

`kind` drives presentation: `essay` gets a drop cap, `note` renders as a
compact card with no excerpt.

---

## Working on posts

- New piece → use the `/new-post` skill, or copy `docs/post-template.md` into
  `_drafts/`. Keep the template itself in `docs/` — anything inside `_drafts/`
  shows up as a real post during `--drafts` preview.
  `/new-post` scaffolds only by default; hand it notes or say "and draft it" and
  it chains to `post-drafter` to fill the body in the same file.
- Capturing a raw idea, or working out what a topic could actually argue →
  `idea-wrangler` agent.
- Drafting from a rough idea → `post-drafter` agent.
- Tightening a draft's prose → `line-editor` agent.
- Checking front matter and build safety before publishing → `frontmatter-check`
  agent.

Never publish on the user's behalf. Leave `published: false` in place and say
the draft is ready; removing it and committing is their call.

Never invent facts, benchmarks, commands, or error messages for a post. If a
draft needs a number or an output that isn't available, leave an explicit
`TODO:` marker in the text and list every one of them in the summary.
