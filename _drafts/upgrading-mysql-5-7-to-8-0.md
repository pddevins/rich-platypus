---
layout: post
kind: post
title: "Upgrading MySQL 5.7 to 8.0"
subtitle: "The authentication plugin gets the headlines. The collation change is what will actually break your joins."
date: 2023-10-17 11:00:00 -0400
categories: [engineering]
tags: [mysql, php, laravel]
published: false
---

MySQL 5.7 reached end of life this month, which converts this upgrade from a good idea
into a scheduling problem. I've run this migration on dozens of projects by now, all
self-hosted, and the ordering of surprises is consistently not what the release notes
imply: the authentication change is loud and easy, and the character set change is quiet
and expensive.

<!--more-->

## Run the upgrade checker first

Before anything else:

```bash
mysqlsh -- util check-for-server-upgrade \
  root@localhost:3306 --target-version=8.0.34
```

MySQL Shell's checker finds reserved-word collisions, prohibited characters in
comments, orphaned tablespaces, and deprecated syntax in stored programs. It is not
exhaustive, but everything it reports is real, and reading its output is a much
cheaper way to discover your problems than a failed migration.

## The change that will actually bite: collation

8.0 defaults to `utf8mb4` with `utf8mb4_0900_ai_ci`. 5.7 almost certainly gave you
`utf8mb4_unicode_ci` or `utf8mb4_general_ci`.

The trap is that this doesn't break on upgrade. Existing tables keep their old
collation, so everything works. Then someone creates a new table — a migration, a new
feature, a new environment built fresh — and it gets the 8.0 default. Now you have two
collations in one schema, and the first join between an old table and a new one fails:

```
Illegal mix of collations (utf8mb4_unicode_ci,IMPLICIT) and
(utf8mb4_0900_ai_ci,IMPLICIT) for operation '='
```

This surfaces weeks after the upgrade, in whichever feature happened to touch both
tables, and it looks like an application bug rather than an infrastructure decision.

Pick one collation and set it explicitly — server, database, and every migration. The
decision matters less than the consistency. If you have the appetite, converting
everything to `utf8mb4_0900_ai_ci` is the forward-looking choice; if you don't, pin
the server default back to what your tables already use and move on.

Sorting also changes with collation, so anything asserting a specific string order —
a test, a paginated list, a report — may legitimately change output. That's correct
behaviour and it will still be reported as a regression.

## Authentication

The default plugin is now `caching_sha2_password` rather than `mysql_native_password`.
Older clients and drivers don't all understand it, and the failure is at connection
time, which at least makes it obvious.

Also gone: the `PASSWORD()` function. Anything provisioning users in SQL needs
rewriting.

Two options. Either update your clients, which is the right answer, or keep the old
plugin during the transition:

```ini
[mysqld]
default_authentication_plugin = mysql_native_password
```

Choose the second only with a date attached, otherwise you've deferred the work
permanently.

## Reserved words

8.0 added reserved words, and several are words people genuinely name columns:
`rank`, `groups`, `system`, `cube`, `lead`. A column called `rank` in a query without
backticks stops parsing. Views and stored procedures fail validation at upgrade time
rather than at call time, which is better than the alternative.

The checker catches these. Fixing them means either quoting or renaming, and renaming
is the one that doesn't recur.

## Things that get better

Worth knowing what you're buying, since the above is all cost:

- **Window functions** — `ROW_NUMBER()`, `RANK()`, `LAG()`. A large class of query
  that previously needed a self-join or application-side work.
- **Common table expressions**, including recursive ones. Hierarchies stop being
  painful.
- **Atomic DDL.** A failed `ALTER` no longer leaves you half-migrated.
- **Real `JSON` improvements**, including `JSON_TABLE`.
- **`utf8mb3` is deprecated**, which is a nudge to finish a migration you probably
  started years ago.

## The order I'd do it in

1. Run the upgrade checker and fix everything it names.
2. Decide the collation question deliberately, and write it into your migration
   defaults and framework config before you upgrade rather than after.
3. Upgrade a staging copy from a production dump. Not a fresh schema — a dump, because
   the interesting failures live in data and legacy DDL.
4. Run the full test suite, then specifically exercise anything asserting string
   ordering.
5. Sort out client auth, with a deadline if you're deferring it.
6. Upgrade production, keeping the 5.7 binaries available for a rollback path.

That last step is written from a self-hosted position, which is where I've done all of
these. Self-hosting means the rollback is genuinely yours: keep the old binaries and a
pre-upgrade dump, and you can go backwards. On managed MySQL you're working with the
provider's snapshot-and-restore mechanics instead, which are usually reliable and are
not the same thing as being able to start the old server.
