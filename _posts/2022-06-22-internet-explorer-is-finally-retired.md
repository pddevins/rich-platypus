---
layout: post
kind: note
title: "Internet Explorer is finally retired"
subtitle: "Twenty-seven years, and the last browser that made you write a second stylesheet is out of support."
date: 2022-06-22 12:00:00 -0400
categories: [engineering]
tags: [browsers, developer-experience]
---

Microsoft retired the Internet Explorer 11 desktop application on 15 June 2022. No more
security updates, no more bug fixes, and, the part I care about, no more defensible
reason for it to appear in a project's browser support matrix.

<!--more-->

For anyone who hasn't had to target it, the tax was not subtle. IE was the last
mainstream browser on neither WebKit nor Chromium, and its own engine had stopped moving
years before it stopped shipping. In practice that meant every layout decision came with
a question attached. Grid was effectively off the table, or on it only behind a flexbox
fallback and a vendor-prefixed implementation of an obsolete draft spec. Custom
properties were unavailable, which meant a theme was a build step rather than a `:root`
block. `fetch`, `Promise`, `Array.from`, `Object.assign`. All polyfill. Every one of
those is a small cost, and there were dozens.

The honest caveat is that the engine hasn't actually left the building. IE mode in Edge
is supported through at least 2029, and it requires the IE 11 engine, so the files
remain on the machine. If you build internal line-of-business applications for large
organizations, your obligation may have changed venue rather than ended.

But for public-facing work, the argument is over, and it's over in the good direction.
Grid without a fallback. Custom properties as the actual mechanism rather than a
progressive enhancement. `clamp()` for type. Modern JavaScript shipped as modern
JavaScript.

Twenty-seven years is a long run for software, and IE deserves genuine credit for the
parts of the web it made possible on the way up. It also spent the last decade as the
reason a stylesheet was twice as long as it needed to be. Both are true, and only one of
them affects my sanity.
