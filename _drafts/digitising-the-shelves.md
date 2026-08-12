---
layout: post
kind: log
title: "Digitising the shelves"
subtitle: "A Samba share, an external DVD drive, and a turntable routed through a receiver into a laptop. Getting the physical media collection onto the homelab."
date: 2025-09-20 13:00:00 -0400
categories: [homelab]
tags: [self-hosting, media-server, proxmox, tinkering]
published: false
---

With Proxmox and Nextcloud settled, the next job was the physical media: shelves of
CDs, DVDs, and records that are only accessible if I'm standing in the room with the
right machine. Three different capture problems, one destination, and the interesting
difficulties were all in metadata rather than in getting bits off discs.

<!--more-->

## The share, via Cockpit

The file-sharing layer went first, because everything downstream needs somewhere to
write.

Cockpit with the file-sharing plugin is the reason this took an evening rather than a
weekend. Samba's configuration file is not complicated, but it is unforgiving and
badly served by half-remembered snippets, and a web UI that produces valid
`smb.conf` stanzas removes an entire category of mistake.

```bash
apt install cockpit samba
# then the file-sharing plugin, which adds share management to the Cockpit UI
```

The share points at a ZFS dataset, separate from the Nextcloud one:

```bash
zfs create tank/media
zfs create tank/media/music
zfs create tank/media/film
```

Separate datasets rather than directories, so each can carry its own snapshot policy.
Media that came off a disc I still own is re-rippable and doesn't need the same
snapshot retention as documents.

## CDs

An external USB DVD drive handles both CDs and DVDs, which is the entire hardware
budget for this project.

For audio CDs the job is well solved: rip to FLAC, look the disc up in an online
metadata database by its disc ID, and write tags. MusicBrainz has the best coverage,
and Picard is the tool to reach for when a rip comes back unidentified or wrong.

The part worth knowing is that a disc ID lookup can return several matches, because
the same album gets pressed in different regions with different track gaps. Choosing
wrong gives you a correct rip with subtly wrong metadata: wrong year, wrong label,
occasionally wrong track titles on a bonus track. That's more annoying than a failed
rip, because it looks like success.

## DVDs

Slower, and the constraint is CPU rather than the drive. A feature-length film
transcodes for a long time, which makes this a queue-overnight job rather than an
interactive one.

I use both tools rather than choosing between them, which turns out to be the answer.
MakeMKV does a first pass, pulling the tracks off the disc without transcoding anything,
and then HandBrake does the actual rip from those. Two steps instead of one, and the reason
is that they're good at different jobs: MakeMKV is good at getting data off optical media
with its copy protection and its odd track layouts, and HandBrake is good at deciding what
the output should look like.

Splitting it also means the slow, error-prone step happens while the disc is still in the
drive, and the CPU-bound step happens whenever.

I keep the subtitles, and this is where the honest trial and error lives. Selecting the
right subtitle track is not obvious. A disc will carry several, variously labelled, some
forced, some commentary, some for a different cut of the film entirely. Then having picked
one, the display timing needs checking against the video, because a mismatched track will
be plausibly close and steadily wrong. Neither problem has a shortcut. You pick, you spot
check a few minutes in the middle, and sometimes you go back.

Film metadata comes from a different set of databases than music, and matching is looser:
you're matching on title and year rather than on a fingerprint of the disc, so anything with
a common title or a remake needs checking by hand.

## Records

The most interesting of the three, and the only one that's a real signal chain rather
than a file copy.

The path: turntable into the JBL receiver, which handles the phono preamp and RIAA
equalisation, then line out from the receiver into a Linux laptop's input, then
Audacity recording the whole side as one file.

Two things about that chain matter. The receiver is doing the phono stage, which is
not optional. A turntable's output is far too quiet and equalised to a curve that has
to be reversed. And the recording is a whole side in one pass, because that's how
records work; there is no track boundary in the signal, only quieter bits.

Splitting is where Audacity earns its place. Label the silences, adjust the labels by
hand where a track fades rather than stops, then export multiple files from the labels
in one operation. The automatic pass gets most of it. Live albums and anything with
applause or a segue between tracks needs manual correction, and the manual correction
is most of the time spent.

Metadata for records is the hardest of the three, because a specific pressing is the
thing you want to identify and there's no fingerprint to look it up by. Discogs is the
best source for pressing-level detail. Expect to type more than you'd like.

The conversion runs through a USB audio interface rather than the laptop's own input, and
that's not audiophile fussiness. A built-in line input on a laptop shares a noisy power
environment with everything else in the machine, and you can hear it on quiet passages. A
separate interface is the single change that most affects the result.

I record at a high sample rate and bit depth and archive to FLAC. The reasoning is that
this is a one-time capture of a physical object. The record will not sound better later,
and the drive space is cheap relative to doing the whole thing again.

I do use click removal. There's a purist argument for leaving surface noise alone as part
of the artefact, and I understand it, but I'm making these to listen to rather than to
document. Applied gently it takes out the pops without the smearing that makes
over-processed vinyl rips sound underwater.

## What I'd do differently

**Rip to a staging directory, not straight into the share.** I sent early rips
directly to their final home and then had to reorganise once I understood how the media
server wanted things named. A staging area costs nothing and makes the naming decision
reversible.

**Settle the naming convention before ripping anything.** Media servers infer
structure from paths, and renaming a few hundred files afterwards is a job you do once
and resent.

**Check the metadata match at rip time, not in a batch afterwards.** Fixing tags in
bulk later means opening a file, listening to it, and working out what it actually is,
which is far more expensive than glancing at a lookup result while the disc is still in
the drive.

**Don't start with the records.** They're the most interesting and the slowest, and doing
them first meant the boring bulk of the CD collection sat undone while I fiddled with label
placement on one live album.

About 80% of the collection is digitised at this point, which I'm treating as done rather
than as 20% remaining. The last fifth is the awkward fifth: the discs that wouldn't
identify, the records with segues I'd have to split by hand, the box set with no metadata
anywhere. Each one is a small individual decision rather than a batch, and batches are what
made the first 80% possible.
