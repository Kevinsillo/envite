---
title: Options
description: Set the auto-lock time, the default key derivation, how often envite checks for changes saved elsewhere and whether it looks for a new version at startup.
sidebar:
  order: 26
---

Envite has two sets of options: the **Options** of this machine, stored in your [configuration file](../../reference/configuration/), and the **Vault options** shared by every member of a vault.

## Options of this machine

Select **Options** on the home screen.

| Group | Option | Values | Default |
|---|---|---|---|
| **Security** | **Never lock**, or **Lock after (minutes)** | 1 to 120 idle minutes | 5 |
| **Security** | **Key derivation** — preset proposed for new passwords | **Standard** or **High** | Standard |
| **Sync** | **Check interval (seconds)** — how often an open vault checks for changes saved elsewhere | 5 to 300 | 10 |
| **Updates** | **Check for updates at startup** — at most once a day, envite asks GitHub for the latest release when it starts | On or off | On |

`Enter` (or **Save**) saves the changed options and goes back. A value out of range is reported and nothing is saved. With nothing changed, it says **Nothing changed**.

Turn **Check for updates at startup** off on a machine without network access, or where envite must not make outgoing requests. **Check for updates** in the **Menu** of the home screen keeps working either way. See [Installation](../../getting-started/installation/#check-at-startup) for what the check at startup does.

Only key presses keep a vault unlocked: checks for changes, saves from others and redraws do not count as activity.

## Vault options

Open a vault and press `o` on **Projects**.

| Group | Option | Effect |
|---|---|---|
| **Deploy** | **Default unix group** | Group of deployed files whose project sets none. Blank for none. |
| **Security** | **Key derivation** | Preset proposed for new members: **Standard** or **High**, or **Custom** when the vault already has custom settings. No existing password changes. |

`Enter` saves each changed option, says **Vault options saved** and goes back. These options are part of the vault, so they are saved and merged like any other change.

## Your password

Your own password and its key derivation are changed from **Users** (`u` on **Projects**, then `e`). See [Share a vault with a team](../share-a-vault/#change-your-password).
