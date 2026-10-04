---
title: History
description: What the history records for each entity, how long it is kept and why it never shows a value.
sidebar:
  order: 14
---

Every change to a project, environment, section or variable adds an entry to the **history** of that entity. Entries are written in the same step as the change and never edited afterwards.

## What an entry holds

- **When** — the date and time, shown in your local time zone.
- **Who** — the member who made the change, or `unknown` when they are no longer in the vault.
- **What** — created, updated, deleted, deployed or imported.
- **The entity** — its kind and name, for example `variable DB_PASS`. A deleted entity keeps the name its history last recorded.
- **The fields changed**, for an update or an import, by name: `name shop → store`, `target path /srv → /opt`, `section General → api`.

A change of a value always reads `value ********`, whether the variable is secret or not: no value ever shows in the history. Positions and ordering are recorded by name only.

Deploys and imports are recorded as entries of the environment. A deploy entry also keeps a fingerprint of the exact file written, which the next deploy uses to detect changes made outside envite.

## Retention

Only the **last 10 entries of each entity** are kept. Older entries are dropped after every write and every merge. The history is therefore a partial view: enough to see who touched something recently, not a complete audit log. Deleting a project deletes its whole history.

## Where to see it

- The detail of a variable shows its own history under the form, newest first.
- `y` on **Projects** opens the history of the selected project, or of the whole vault, with filters by member, kind of entity and action. See [Browse the history](../../guides/history/).

## History and merging

When two members save concurrently, their histories are joined (entries are unique, so nothing conflicts) and pruned again to the last 10 per entity. Resolving a conflict in favour of the other side, or with an edited value, adds an entry by the member who resolved it.
