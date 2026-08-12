---
layout: post
kind: brief
title: "Upgrading Laravel 11 to 13"
subtitle: "Two majors in one jump, and the PHP version requirement is the only thing likely to hold you up."
date: 2026-06-13 10:00:00 -0400
categories: [engineering]
tags: [laravel, php]
published: false
---

Laravel 13 arrived in March. If you're still on 11, you're skipping a major — which
sounds worse than it is, because 12 and 13 were both deliberately small releases. The
framework side of this is genuinely quick. The PHP requirement is the part that will
determine your timeline.

<!--more-->

## Check the one thing that actually blocks you

Laravel 13 requires **PHP 8.3 minimum**. Everything else in this post is easy; this is
the item that turns a morning into a quarter if you're on 8.1 or 8.2.

```bash
php -v
composer why-not php 8.3
```

Do the PHP upgrade as a separate, earlier piece of work. Bundling a language major with
a framework major means debugging two categories of failure at once with no way to
attribute them, which is the mistake I keep watching people make.

## The upgrade itself

```bash
composer require laravel/framework:^13.0 --with-all-dependencies
```

Then first-party packages, which version independently and are the usual source of a
failed resolve:

```bash
composer show laravel/* --direct
```

Bump each to its 13-compatible constraint. If Composer refuses, read the conflict — it's
almost always one package with a narrow constraint rather than a genuine
incompatibility.

Then:

```bash
php artisan config:clear && php artisan cache:clear
php artisan about
composer test
```

`php artisan about` is the fastest confirmation that the framework and its drivers came
up cleanly.

## Why this is easier than it sounds

Both releases emphasised backward compatibility, and Laravel 13 in particular shipped
essentially no breaking changes beyond the PHP floor. The official upgrade guide
estimates about ten minutes for many applications, and for once that's not marketing —
if your app is on 11 and reasonably conventional, it may genuinely be a version bump and
a test run.

For anything less conventional, [Laravel Shift](https://laravelshift.com) handles the
mechanical parts of a two-major jump and is worth the fee purely for the diff it
produces, which doubles as a checklist.

Read both upgrade guides rather than only the 13 one. Skipping a major means the 12
changes apply to you too, and they're not in the 13 notes.

## What you get

Worth knowing what the upgrade is buying, since it's all optional:

- **PHP attributes** for framework configuration, as an alternative to convention and
  method calls. Optional and fully backward compatible.
- **Passkeys** support out of the box — WebAuthn without assembling it from packages.
  The most immediately useful item here for anything with user accounts.
- **First-party JSON:API support**, with resource classes handling serialisation,
  relationship inclusion, sparse fieldsets, and compliant response headers. If you've
  hand-rolled JSON:API before, this is a large amount of code you get to delete.
- **`Queue::route()`**, which puts the queue and connection for each job class in one
  place in a service provider rather than scattered across job definitions.
- **`Cache::touch()`**, for extending a TTL without a read and rewrite.
- **A Reverb database driver**, and the Laravel AI SDK reaching stable.

## Timing, if you're deciding whether to wait

Laravel's policy is 18 months of bug fixes and two years of security fixes for every
release, with no LTS designation since Laravel 6. In practice that puts Laravel 12's bug
fixes ending **13 August 2026** and its security fixes **24 February 2027**; Laravel 13 runs
to roughly Q3 2027 for bug fixes and Q1 2028 for security.

So if you're on 11, you're already outside bug-fix support and running on security patches
alone. Not an emergency, and not something to leave much longer either — a
zero-breaking-change major is the cheapest upgrade you will ever get, and they get more
expensive the longer you leave them.

The order I'd actually run it: PHP to 8.3 first, ship that, live with it for a week, then the
framework jump as its own change.

## Having done it

I've run this on a couple of projects that needed it, and it was straightforward both times —
the official ten-minute estimate is optimistic as a total but honest about the framework
step itself. Bump, clear caches, run the suite, done.

Both projects were already on PHP 8.3, which is the reason it went that smoothly, and it's
why I keep separating the two upgrades in this post. Every hour I've ever lost to a Laravel
major has actually been a PHP major or a dependency wearing a Laravel costume. Get the
language sorted first and the framework jump really is an afternoon.
