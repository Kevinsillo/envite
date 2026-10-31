---
title: Synchronize environments
description: Keep the sections, keys, flags and order of several environments of a project in step, without ever copying a value between them.
sidebar:
  order: 22
---

Environments of the same project often hold the same set of keys with different values: `dev`, `staging` and `prod` share the shape of the configuration but not its contents. Envite can keep that shape in step for you.

This is a different thing from the synchronization of a vault between members, which merges the changes several people made to the same file. Here, one vault holds several environments and envite mirrors the metadata between them. See [Sync and conflicts](../../concepts/sync-and-conflicts/).

## Turn it on

Select an environment and press `m`. Envite shows a preview of what it is about to do, and applies it when you confirm.

Turning it on never deletes anything. The preview lists what each other environment of the project lacks, and those items are created there. If an environment holds a key or a section that the one you are enabling does not have, the preview also lists it, and that item is created in the environment you are enabling.

When the comments of the same key or section differ between environments, the preview asks you for the final comment before anything is written. Nothing else needs a decision: the environment you are enabling is the reference.

`m` on an environment that already takes part turns it off. Nothing is deleted and no change is mirrored from then on; the metadata that was already mirrored stays.

## What is mirrored

Once an environment takes part, every change made in it is applied to the other environments of its project that take part too:

| Change | What the other environments get |
|---|---|
| A section is created | A section with the same name, comment and position |
| A section is edited | Its new name, comment and variable order |
| A section is deleted | The section of the same name, with its variables |
| A variable is created | A variable with the same key, comment, secret flag, state and position, **with no value** |
| A variable is edited | Its new comment, secret flag, state, section and position |
| A variable is renamed | The new key, after you confirm it, with the comment (when you edited it), secret flag, state, section and position of the renamed variable |
| A variable is deleted | The variable with the same key |
| A variable is moved to another section | The same move, in the section of the same name |
| The order of the sections or variables changes | The same positions and the same order mode |
| A file is imported | The new keys, empty, and the new state of the overwritten ones |

**Values never travel.** A variable created in `dev` appears in `prod` with an empty value, and the value of a variable is never read nor copied when mirroring. Each environment keeps its own values.

The comment of a variable is copied only when you edit it explicitly. A comment that drifts because of a merge does not travel to the other environments.

## Deletions ask first

Deleting a section or a variable that takes part in the synchronization asks before doing anything, and the question says what disappears in each environment and how many values are lost there:

```text
DB_HOST will be deleted.
prod: DB_HOST (1 with a value)
```

The confirmation is about the whole group. If the environments changed after the question was asked, envite refuses the deletion and asks you again, so you never delete in one environment what you had not seen in the others.

## Environments that do not take part

A new environment does not join on its own. Until you press `m` on it, it is left alone: changes in the environments that take part do not reach it.

The same goes for the environments of other projects, and for the ones whose synchronization was turned off.

## When the environments drift apart

Every change is mirrored in the transaction that causes it, so the environments of a group stay equal. If they ever drift apart — because a change was made in an environment that did not take part, or because a merge brought in a change from somewhere else — the fix is to turn the synchronization off and on again: the reconciliation fills the gaps without deleting anything.

If a change refers to a key or a section that one of the other environments does not hold, envite refuses it instead of applying it to only a part of the group. Turning the synchronization off and on again repairs the group, and the change can then be made again.
