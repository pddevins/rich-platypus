---
layout: post
kind: post
title: "What encrypted email actually buys you"
subtitle: "Tuta and Proton both solve a narrower problem than their marketing implies, and the narrow problem is still worth solving."
date: 2026-02-21 10:00:00 -0500
categories: [privacy]
tags: [email, encryption, threat-modeling]
published: false
---

Email is a protocol from 1982 with encryption bolted on in several incompatible ways,
and no provider can change that unilaterally. What Tuta and Proton actually sell is not
encrypted email. It's a mailbox whose operator cannot read it, which is a different and
much more limited claim, and one that's still worth paying for, once you know which
threat it addresses.

<!--more-->

## The thing that can't be fixed

When you send mail to someone on Gmail, that message arrives on Google's servers and
Google can read it. This is true regardless of your provider. It holds whether you use
Tuta, Proton, your own server, or a machine in a vault.

SMTP has no transport-agnostic end-to-end encryption. TLS between servers protects the
hop rather than the contents at rest on the other end, so the moment your correspondent
is on a mainstream provider, which is nearly always, the confidentiality of that
conversation is set by their provider, not yours.

Both companies are honest about this if you read carefully, and both market in a way
that lets people not notice. The end-to-end encryption they offer works fully only
between users of the same service, or via a password-protected message that the
recipient opens in a browser, which most recipients treat as an obstacle rather than a
feature.

## So what are you buying

Four things, and it's worth naming them separately because they have different value
depending on who you're worried about.

**The operator can't read your mailbox.** Contents are encrypted at rest with keys derived
from your password, which defeats a specific and real adversary: the provider itself,
scanning your mail for advertising or model training. Against Google that is sufficient
reason on its own.

**A server-side breach yields less.** Encrypted-at-rest mail stolen from a provider is
considerably less useful than plaintext. Given how routinely providers are breached,
this is underrated.

**A subpoena to the provider produces less.** Not nothing — metadata still exists, and
who you emailed and when is often more revealing than the contents. But the body of the
message isn't available to hand over.

**No advertising surveillance.** You're the customer rather than the inventory, which
changes the business incentive underneath every other decision they make.

Notice what's absent from that list: protection from your correspondent's provider,
protection from someone with your password, and metadata privacy. Those are the gaps.

## Tuta and Proton differ more than they appear

They're grouped together and they've made genuinely different trade-offs.

**Proton** optimizes for interoperability. It implements OpenPGP, so you can exchange
properly encrypted mail with anyone using PGP outside Proton, and it offers IMAP and
SMTP through a local bridge so you can keep using a normal mail client. That makes it
usable inside an existing workflow, and it means the encryption is a standard rather
than a proprietary scheme. It's also a wider suite (calendar, drive, VPN) which is
convenient and is also more of your life in one basket.

**Tuta** optimizes for encrypting more. It encrypts the subject line and the address book,
which PGP conventionally does not, and it uses its own protocol rather than OpenPGP. The
cost of that choice is real: no IMAP, so you use their clients, and no PGP
interoperability.

They've also gone furthest on post-quantum. TutaCrypt is a hybrid — CRYSTALS-Kyber for
post-quantum key encapsulation alongside X25519 for the classical elliptic-curve
exchange — and it's on by default for new accounts. The threat it addresses is "harvest
now, decrypt later": an adversary storing your ciphertext today against the possibility
of breaking it in fifteen years. Whether that's your problem depends entirely on whether
anything you write still matters in fifteen years, which for most mail is no and for
some is emphatically yes. The hybrid construction is the sensible engineering call
regardless, since it can only be as weak as the stronger of two independent mechanisms.

The trade is legible once stated. Proton gives you compatibility with the existing
encrypted-mail world. Tuta gives you a smaller unencrypted surface inside your own
mailbox, and asks you to live in their ecosystem to get it.

**Metadata:** neither can fix it. Sender, recipient, and timestamps have to be readable
by the machines routing the mail.

## Who this is for

Reasonable, in descending order of how much I'd insist:

**Almost everyone**, on the grounds that your mailbox is the most sensitive account you
own (it's the recovery path for everything else), and having it read for advertising is
a bad default. This is a low-effort, permanent improvement.

**Anyone whose work involves other people's sensitive information.** Not because
encrypted mail is compliance, but because reducing what a breach exposes is
straightforwardly good.

**Anyone consolidating identities.** Switching providers is the natural moment to split
mail by function, which is a bigger security win than the encryption is.

**Not** anyone whose threat model includes a targeted, resourced adversary. If that's
you, email is the wrong channel entirely and the provider is not the question.

## The practical advice

Migrating email is unpleasant, so do it once and properly.

Own a domain and use it. This is the single most important decision, and it's
independent of provider. Mail at your own domain means switching provider later is a DNS
change instead of telling four hundred contacts a new address. Both services support
custom domains on paid plans. Being locked into `@proton.me` recreates the problem you
left Gmail to escape.

Then separate addresses by function (financial, personal, shopping, public) on that
domain. That does more for your actual security posture than the encryption does,
because it limits what one compromise reaches.

And keep the old mailbox alive for a year rather than closing it. Account recovery
addresses surface for a surprisingly long time.

## What I do

I run both, and not out of indecision. They're split by who I'm talking to.

**Proton for people I know.** Personal correspondence with real contacts, where the
relationship is established and I want mail that behaves like mail: IMAP through the
bridge, a normal client, PGP available if the other end has it. Since this is the
mailbox that has to interoperate, I use the one built to interoperate. The bridge is a
paid-plan feature and runs as a local application on your own machine, so IMAP works by
proxying through software you're running rather than by the provider exposing it.

**Tuta for everyone else.** Signups, online services, people I've dealt with once,
anything where a mailbox is a requirement rather than a conversation. This is the
higher-risk correspondence (more likely to be breached, more likely to be sold, more
likely to be a stranger) and it's where Tuta's larger encrypted footprint and closed
ecosystem are advantages rather than costs. No IMAP is fine here. I don't want this mail
in a general client anyway.

The split falls out of what each is good at, and it also happens to be a segmentation
strategy. A breach on the online-services side reaches an address that isn't the
recovery path for anything that matters.
