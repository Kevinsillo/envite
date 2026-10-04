---
title: Variable states
description: Enabled, disabled and commented variables, and how each one is written to the .env file.
sidebar:
  order: 13
---

Every variable has a **state** that decides whether and how it is written to the `.env` file of its environment. A new variable is always enabled.

| State | In the list | In the `.env` file |
|---|---|---|
| **Enabled** | `DB_HOST` | `DB_HOST=db.local`, preceded by its comment if it has one. |
| **Disabled** | `DB_HOST (off)`, dimmed | Not written at all, nor its comment. The variable stays in the vault. |
| **Commented** | `# DB_HOST` | `# DB_HOST=db.local`, with `# ` before every line of a value of several lines. |

Disabling a variable is the way to keep a value around — an old endpoint, a credential for another provider — without deploying it. Commenting it leaves it visible in the file as a hint, ready to be uncommented by hand.

A section whose variables are all disabled is not written to the file.

## Changing the state

- On the **Variables** list, `s` moves the selected variable to its next state: enabled → disabled → commented → enabled.
- In the variable detail, the **State** field (shown when editing) sets it directly.

The state is a field like any other: it is recorded in the history and merged on its own when two members edit the same variable.

When a `.env` file is [imported](../../guides/import/), a `# KEY=value` line becomes a commented variable.
