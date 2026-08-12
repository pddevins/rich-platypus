---
layout: post
kind: brief
title: "What PHP 8.4 changes about writing classes"
subtitle: "Property hooks and asymmetric visibility are the first additions in years that change how I'd design an object, not just how I'd type it."
date: 2024-12-07 09:00:00 -0500
categories: [engineering]
tags: [php, laravel]
published: false
---

PHP 8.4 shipped in November, and unlike 8.2 or 8.3 it contains changes that affect
design rather than syntax. Property hooks and asymmetric visibility both remove a reason
to write a class the way we've been writing them.

<!--more-->

## Property hooks

You can now attach behavior to a property directly instead of hiding it behind a method:

```php
class Order
{
    public string $reference {
        get => strtoupper($this->rawReference);
        set (string $value) => $this->rawReference = trim($value);
    }

    private string $rawReference = '';
}
```

The significance isn't the saved keystrokes. It's that the getter-and-setter pattern
existed largely because a property couldn't ever become computed later, so you wrapped
it in a method up front, purely to preserve the option. Property hooks remove that
pressure. A plain public property can gain a `get` hook without any caller changing,
which means the defensive accessor is no longer defensive, it's just noise.

Worth being careful with: hooks put arbitrary code behind something that reads like a
field access. A `get` hook doing a database query is legal and will surprise whoever
finds it.

## Asymmetric visibility

Different visibility for reading and writing, which is the shape most value objects
actually want:

```php
class Invoice
{
    public private(set) Status $status;

    public function markPaid(): void
    {
        $this->status = Status::Paid;
    }
}
```

Readable everywhere, writable only inside the class. Previously this required a private
property plus a public getter: three lines and a method call to express one idea. This
is the feature I expect to reach for most, because "anyone may look, only I may change"
describes a large share of domain objects.

## The array functions we've all hand-rolled

```php
$first = array_find($orders, fn ($o) => $o->isOverdue());
$key   = array_find_key($orders, fn ($o) => $o->isOverdue());
$any   = array_any($orders, fn ($o) => $o->isOverdue());
$all   = array_all($orders, fn ($o) => $o->isPaid());
```

Every codebase had these as helpers, or reached for Laravel's collections to get them.
Now they're native. Laravel users will mostly keep using collections, and that's fine.
The win is for library code that shouldn't depend on a framework.

## Instantiation without the extra parentheses

```php
// before
$name = (new ReflectionClass($obj))->getShortName();

// 8.4
$name = new ReflectionClass($obj)->getShortName();
```

Small, and removes a wart that made a common idiom look worse than it was.

## Upgrading

The usual advice holds and the usual thing will delay you: the language will be ready
and your dependency tree won't. `composer why-not php 8.4`.

For Laravel specifically: both 11 and 12 support PHP 8.4 while still requiring only PHP
8.2 as a minimum, so there's no framework upgrade gated behind this one. You can move the
language without touching the framework.

One additional note for 8.4. Property hooks and asymmetric visibility are new syntax, so
anything parsing PHP source (static analysis, IDE tooling) needs to understand them
before you can use them without noise. Check PHPStan and Psalm versions before writing
hooks throughout a codebase.

## Having used them a little

I haven't rewritten anything to use property hooks, and I don't intend to. What I've
done instead is reach for them per-property, where a specific property had a specific
reason to need behavior, which I think is the correct dose.

That's worth saying because the framing around a feature like this pushes toward
adoption as a style. Hooks are not a better way to write properties. They're a way to
avoid an accessor when an accessor would have existed solely to preserve the option of
computing something later. Used surgically, they remove noise. Used everywhere, they put
arbitrary code behind field access throughout a codebase, and someone will eventually
find a query in there.

Asymmetric visibility is the one I'd use broadly without hesitation. It expresses an
intent I have constantly, and it has no hidden behavior at all.
