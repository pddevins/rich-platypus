---
layout: post
kind: brief
title: "What PHP 8.0 changes for Laravel developers"
subtitle: "The headline is the JIT. The features you'll actually use every day are the boring ones."
date: 2020-11-26 16:00:00 -0500
categories: [engineering]
tags: [php, laravel, developer-experience]
---

PHP 8.0 shipped today. The release notes lead with the JIT, which is the item least
likely to change your week. The changes that will show up in every file you touch are
the small syntactic ones, and they're good enough that going back to 7.4 feels like
typing with mittens on.

<!--more-->

## The things you'll use immediately

**Constructor property promotion.** The single biggest reduction in boilerplate in
years. This:

```php
class OrderTotal
{
    private Money $subtotal;
    private Money $tax;

    public function __construct(Money $subtotal, Money $tax)
    {
        $this->subtotal = $subtotal;
        $this->tax = $tax;
    }
}
```

becomes this:

```php
class OrderTotal
{
    public function __construct(
        private Money $subtotal,
        private Money $tax,
    ) {}
}
```

Every value object, DTO, and injected service in a Laravel app gets shorter.

**Union types.** Type information that used to live in a docblock, where nothing
enforced it, now lives in the signature, where the engine does:

```php
public function find(int|string $id): Model|null
```

**Named arguments.** Order-independent and self-documenting, and they let you skip
optional parameters instead of passing four defaults to reach the fifth one.

```php
$client->charge(amount: 2500, currency: 'usd', capture: false);
```

**The match expression.** `switch` with sane semantics: strict comparison, no
fall-through, and it returns a value.

```php
$status = match ($response->code()) {
    200, 201 => 'ok',
    402      => 'payment_required',
    default  => 'error',
};
```

**The nullsafe operator.** `$order?->customer?->address?->postcode` replaces the
nested `if` ladder or the optional() helper, at least for reads.

**Three string functions that should have existed for a decade.**
`str_contains()`, `str_starts_with()`, `str_ends_with()`. No more `strpos() !== false`
and no more explaining to a junior why `0` is a valid position but a falsy value.

**Attributes.** Structured metadata in the language rather than parsed out of
comments. Mostly interesting for what the ecosystem will build on it over the next few
years rather than for what you'll write yourself this month.

## The JIT, honestly

Two engines shipped, Tracing JIT and Function JIT. The benchmark numbers are real:
roughly 3x on synthetic tests, and 1.5x to 2x on some long-running applications.

The phrase to hold onto is "long-running." A typical Laravel request is dominated by
database round-trips, and a JIT does nothing for I/O wait. If your app is slow because a
controller fires ninety queries, PHP 8.0 will make it slow at a slightly higher clock
rate. Measure before you claim a win.

## Upgrading

The good news is that most of the breaking changes were deprecated somewhere in
7.x, so a codebase that runs clean on 7.4 without deprecation notices is most of
the way there. The specific things that bite:

- **String-to-number comparison changed.** `0 == "foo"` is now `false`. This is
correct and it will still break something, because somewhere in every mature codebase is
a loose comparison quietly relying on the old behavior.
- **More errors are now `TypeError` / `ValueError`** instead of warnings. Internal
functions are consistent with userland ones. Code that limped along on warnings now
throws.
- **`@` no longer silences fatal errors.** If it was hiding one, you're about to
meet it.
- **Removed extensions and functions.** Anything still calling into a long-since
deprecated API will need replacing rather than adjusting.

The order I'd do it in: get to 7.4, turn deprecation notices into failures in CI, fix
everything, then bump. Upgrading straight from 7.2 to 8.0 works right up until you're
debugging three categories of failure simultaneously with no idea which version
introduced which.

## For Laravel specifically

Laravel announced PHP 8.0 support the same day PHP shipped it, and it reaches further
back than you might assume: Laravel 6, 7, and 8 all support PHP 8.0, provided you're on
the latest patch release of whichever you're running. That includes the 6.x LTS line, so
getting to PHP 8 doesn't require a framework major first.

Order of operations: latest patch of the framework, then the first-party packages
(Passport, Cashier, Dusk, Horizon), since each ships its own PHP 8 support separately.

Then the actual blocker, which is everything else in `composer.json`. The framework
being ready and your dependency tree being ready are different questions, and in a fresh
major the second is what holds you up for months. `composer why-not php 8.0` names the
package you're waiting on.

Which is where I actually got stuck. On the project I moved, the language changes were
the easy part. The 7.4 baseline was clean and the code needed very little. The
dependency tree was the whole job.

Some of the popular Spatie packages took a month or so to reach a stable PHP 8 release.
That's not a criticism; that's maintainers doing careful work on their own time, and
waiting is the correct response. What it means practically is that a chunk of your
timeline is not yours to compress, and no amount of effort shortens it.

The genuinely awkward one was an abandoned spreadsheet-generation package. Nobody was
coming to update it, so the options were fork it and do the upgrade by hand, or rip it
out and replace it. I forked it.

That's the real shape of a major PHP upgrade: a small amount of your own work, a stretch
of waiting on other people, and one dependency where the maintainer has moved on and the
decision lands on you.
