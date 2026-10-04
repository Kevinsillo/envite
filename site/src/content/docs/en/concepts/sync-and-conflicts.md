---
title: Sync and conflicts
description: How several members edit the same vault at once, how their changes merge, and when a conflict needs a choice.
sidebar:
  order: 15
---

Several members can have the same vault open at the same time. Each session works on its own copy in memory; saves are coordinated through the file itself, so no server is needed.

## Revisions and the save lock

Every save increments the **revision** stored in the header. A session remembers the revision it last opened or wrote, its **base**. When it saves:

1. It takes a short lock next to the vault file (`<vault>.lock`), released as soon as the save is done. The lock is only held while writing, never while the vault is open.
2. It reads the stored header. If the revision is still the base, nobody saved meanwhile, and the vault is written with the next revision.
3. Otherwise someone else saved: the session reads their version and **merges**.

A lock left behind by a crashed save becomes stale after 2 minutes and is taken over by the next save.

## Three-way merge

The merge compares three versions: the **base** (what both sides started from), **mine** (this session) and **theirs** (what is stored now). It works record by record and field by field:

- Changes to different records, or to different fields of the same record, combine on their own.
- A field changed on only one side takes that side's value.
- A field changed on both sides to different values is a **conflict**.
- Deleting a record on one side while editing it, or one of its children, on the other is a conflict.
- Two records with the same name, or two variables with the same key in one environment, created on both sides, is a conflict.
- Members are merged by id; the same username added on both sides for different members is a conflict.
- Histories are joined and pruned to the last 10 entries per entity.

A clean merge is written straight away, and the status bar tells you whose changes were merged in.

## Conflicts

When the merge finds a conflict, **nothing is written**. Your changes stay in your session, the other version is kept aside in memory, and the status bar reads `conflict · c resolve` in the warning style. Automatic saves stop until the conflicts are resolved; you can keep working meanwhile.

`c`, from any screen of the open vault, lists the conflicts, named without any value — for example `Variable shop/prod/API_KEY: value changed on both sides`. For each one you choose **Mine**, **Theirs** or, for a single text value, an **edited** value. Resolving recomputes the merge with your session as it is now and writes the result. See [Resolve conflicts](../../guides/resolve-conflicts/).

## Picking up changes from others

While your vault is open and has nothing unsaved, envite checks the stored vault every few seconds (10 by default, 5 to 300 in [Options](../../guides/options/)). The check reads only the header; when the revision changed, it reads the new version and adopts it, and a notice tells you who saved it. The screens refresh with the new content.

A vault with unsaved changes or pending conflicts is not checked: its next save merges what others saved. A locked vault is neither checked nor saved.

## Removed members

If another member removes you while your vault is open, the next check or save finds no slot for you: envite tells you and closes the vault. Changes you had not saved yet are lost.

## Limits

- Locks are cooperative: they coordinate envite instances, not other programs writing the file.
- Lock staleness depends on reasonably synchronized clocks between the members' machines.
- Replacing the file with an older valid copy is not detected; the next save merges with it like with any other version.
