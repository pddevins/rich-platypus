---
layout: post
kind: post
title: "The payment package I keep wishing existed"
subtitle: "Every gateway ships a good SDK. Nobody ships the layer above it, so every shop rebuilds the same seven things badly."
date: 2022-04-28 11:00:00 -0400
categories: [engineering]
tags: [payments, laravel, php]
published: false
---

I have shipped production integrations against Stripe, PayPal, Authorize.Net, Braintree,
Square, and, back when it was a going concern, WePay. In 2016 I also wrote a gateway
from scratch in Java, talking to the processors through their own proprietary API rather
than anything standardized, which is the sort of thing you do once and never entirely
recover from. Across all of it, the difficulty was never the gateway. The difficulty is
the layer nobody ships: everything between "I can charge a card" and "my business is
correct."

<!--more-->

## The gap

Every gateway gives you a well-documented client for its own API. None of them gives you
an opinion about the shape of your application, because that isn't their job.

So every project rebuilds the same scaffolding. A payment methods table that
half-mirrors the gateway's objects. A webhook controller with signature verification
copy-pasted from the docs. A retry policy invented under deadline. A refund flow that
handles partials incorrectly for eight months. Idempotency keys, added after the first
double-charge rather than before. A reconciliation script nobody owns and everybody
distrusts.

None of that is hard. All of it is fiddly, all of it is the same every time, and all of
it is where the money bugs live. The bugs that cost real money are almost never in the
charge call. They're in the state machine around it.

## What writing one from scratch taught me

Building a gateway rather than consuming one changes which parts of the abstraction you
think are essential.

The thing you learn immediately is that the authorisation is a small, well-defined event
and everything expensive happens afterward. Auth and capture are separate for good
reasons and most application code conflates them. Settlement happens on somebody else's
schedule. Money that your database says you have is not money you have. A reversal is a
different animal from a refund, which is a different animal from a chargeback, and an
application that models all three as "negative transaction" will be wrong in a way that
takes a year to surface.

That's the knowledge I want to encode. Not "here's how to call Stripe", Stripe documents
that better than I would, but "here's the state machine you actually need, with the
gateway differences absorbed."

## What I want to build

Start narrow: payments only, with real support for the major gateways. One interface,
swappable driver, the way Laravel already does filesystems and queues. If you can move
from one gateway to another by changing a config value and a set of credentials, the
package has done its main job.

Then add on, incrementally and optionally:

- **Inventory**. tracking tied to the order lifecycle, so a reserved item and a
captured payment can't disagree.
- **Invoicing**. generation, delivery, and a payment status that reflects reality
rather than a boolean somebody forgot to update.
- **Accounting integrations**. QuickBooks first, since that's what actual small and
mid-size businesses run on.
- **Taxes**. the part everyone underestimates, and the reason so many carts are
quietly wrong.

The add-on structure matters more than the feature list. A shop selling digital
downloads should never think about inventory. A warehouse should be able to turn it on
without adopting an ERP.

## Why Laravel, and why opinionated

Being opinionated is the feature. A package supporting every possible schema and
workflow becomes configuration you have to learn instead of code you don't have to
write, and at that point the gateway SDK was the better choice.

What I want is the Cashier experience widened: sensible migrations, a small number of
well-named contracts, events at the points you'll hook, and the common path working
after publishing a config file and setting three environment variables. Reach for the
escape hatch when your business is genuinely unusual. Otherwise write nothing.

## What I'm not sure about

The honest list, because this is an idea and not an announcement.

**Where the abstraction breaks.** Gateways diverge most in the places that matter: 3DS
and SCA flows, dispute handling, payout timing, partial capture semantics. A
lowest-common-denominator interface would be safe and useless. Some gateway-specific
surface has to be exposed deliberately, and I don't know where that line goes.

**Whether stored payment methods can be abstracted at all**, given that the
tokenisation model differs per gateway and getting it wrong has compliance consequences
rather than merely bugs.

**Money representation.** Integer minor units, certainly. Multi-currency with
per-jurisdiction rounding rules, much less certainly.

**Whether this should be several packages.** Payments, inventory, and invoicing may
simply be different problems that happen to share a customer, and one repository might
be convenience for me rather than for anyone installing it.

So it's still a sketch, but not only a sketch. There's a private set of beta
repositories at this point, which is where the driver interface is getting its first
real test against more than one gateway. The open question is how fast the abstraction
starts leaking, and I'd rather find that out in a spike than in a README.

The hunch that the gap is real, I hold mostly because I've filled it by hand more times
than I can count, and once by writing the gateway itself.
