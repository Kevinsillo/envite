---
title: Browse the history
description: See who changed what in a project or in the whole vault, and filter by member, kind of entity and action.
sidebar:
  order: 25
---

The **History** screen lists the recent changes of a project or of the whole vault, newest first. What the history records, and why it keeps only the last 10 changes of each entity, is explained in [History](../../concepts/history/).

## Open it

On **Projects**, press `y`:

- with a project selected, it opens **History of project api**;
- with no project, it opens **History of the vault**.

The detail of a variable also shows the history of that variable under its form.

## Read a row

Each row is one change: the date and time in your time zone, the member (`unknown` when no longer in the vault), the action, the entity and, for an update or an import, the fields changed:

```text
2026-10-03 18:42  alice  updated   variable DB_HOST: value ********
2026-10-03 18:40  ana    updated   variable API_URL: section General → api
2026-10-02 09:12  alice  deployed  environment production
```

In the history of the vault each entity is preceded by its project, for example `api · variable DB_PASS`.

## Filter

Letters cycle through the options of each filter, shown as `User: … · Type: … · Action: …`:

| Key | Filter |
|---|---|
| `w` | Switch between the project and the whole vault (only when opened on a project). |
| `u` | Member: all, then each member of the vault. |
| `t` | Kind of entity: all, project, environment, section, variable. |
| `a` | Action: all, created, updated, deleted, deployed, imported. |

`/` searches the rows shown. `Esc` goes back to the projects.
