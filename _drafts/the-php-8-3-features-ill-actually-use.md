---
layout: post
kind: brief
title: "The PHP 8.3 features I'll actually use"
subtitle: "A quiet release, and two of the additions close holes I've been working around for years."
date: 2023-12-05 09:00:00 -0500
categories: [engineering]
tags: [php, laravel]
published: false
---

PHP 8.3 landed on 23 November. It's a small release compared to 8.0 or 8.1, and that's
fine — the interesting thing about a mature language is when the additions stop being
paradigm shifts and start being holes getting filled. Two of these close holes I've
personally been working around.

<!--more-->

## Typed class constants

Constants can now carry a type, including in interfaces, traits, and enums:

```php
interface Gateway
{
    const string DRIVER = 'stripe';
    const int MAX_RETRIES = 3;
}
```

The problem this solves is real but undramatic. A constant declared in an interface was
previously a suggestion about shape — an implementer could redeclare `DRIVER` as an
array and nothing would object until something downstream broke. Now the intent is
enforced where it's declared.

## json_validate()

```php
if (! json_validate($payload)) {
    return response()->json(['error' => 'malformed'], 422);
}
```

Previously the way to check whether a string was valid JSON was to decode it and see
whether you got an error, which means allocating the entire decoded structure purely to
throw it away. For a webhook endpoint receiving large payloads, that's real memory
spent on a question with a boolean answer.

This is the addition I'll use most, and it's a good example of a function that existed
in every codebase as a three-line helper wrapping `json_decode` and
`json_last_error`.

## Deep-cloning readonly properties

`readonly` has been excellent and had one sharp edge: a `readonly` property could not
be reassigned inside `__clone()`, which made deep cloning an immutable object
impossible without giving up `readonly`.

8.3 permits modifying readonly properties within `__clone()` specifically, which means
a value object holding another object can now be cloned properly:

```php
final class Order
{
    public function __construct(
        public readonly Money $total,
        public readonly Customer $customer,
    ) {}

    public function __clone(): void
    {
        $this->customer = clone $this->customer;
    }
}
```

Narrow, and exactly the kind of edge case that makes an otherwise good feature
unusable in one specific spot.

## The rest

`str_increment()` and `str_decrement()` for alphanumeric strings — useful for sequence
generation, though I'd think carefully before using it for anything that has to be
predictable across locales. Continued improvements to the `Random` extension from 8.2.
And the usual round of deprecations worth reading before they become removals.

## Whether to upgrade

Yes, and quickly, because the risk profile of a minor PHP release is low and the cost
of falling behind compounds. A codebase clean on 8.2 needs very little here.

The dependency question is the same as always and is the only thing that will actually
delay you. `composer why-not php 8.3` before you plan anything.

I've moved projects to 8.3 already and there is genuinely nothing to report, which is
the answer you want from a minor release. No breakage, no surprises, no forked
dependencies. Compared to the 8.0 transition — where I spent a month waiting on packages
and forking an abandoned one — this is the version bump you do on a Tuesday afternoon.
