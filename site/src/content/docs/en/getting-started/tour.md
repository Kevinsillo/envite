---
title: Tour of the screens
description: The screens of envite, how they stack, and the parts every screen shares.
sidebar:
  order: 4
---

Envite is a stack of screens. The home screen is always at the bottom; every other screen opens over the one below it and `Esc` goes back. The header of each screen shows where you are, for example `Envite › Projects`.

## Home and vaults

| Screen | What it shows |
|---|---|
| **Home** | `Envite v<version>` with the local date and time, the **Menu** (**Vaults**, **Options**, **Check for updates**, **GitHub**, **Open issue**, **Exit**) and the **Known vaults (N)**, the one opened last marked `● last` and preselected. |
| **Vaults** | The known vaults with name and location. `n` creates, `o` opens an existing one, `r` renames it, `d` removes it from the list (the file is left alone). |
| **Create vault** / **Open existing** | Forms to create a vault or add an existing file to the list. See [First start](../first-start/). |
| **Login** | Member and password of the selected vault. |
| **Options** | Settings of this machine: auto-lock and default key derivation (**Security**), check interval (**Sync**), check for updates at startup (**Updates**). |

**Check for updates** looks for a newer release in the background, with `Checking for updates...` in the status bar; you can keep working meanwhile. When envite is up to date, the status bar says so. When a newer release exists, a dialog asks `Install envite <new>? (current <installed>)`, with **Cancel** selected: choose **Install** to download and install it, then restart envite to use it. While it installs, the status bar shows `Installing update...` and envite does not quit until it is done. See [Updating](../installation/#updating).

Once a day, when envite starts, it also checks by itself, silently. A newer release is offered in a dialog, `envite <new> is available (current <installed>)`, with **Update**, **Skip this version** and **Later** (selected). See [Check at startup](../installation/#check-at-startup).

## Inside a vault

Once logged in, the screens follow the [hierarchy](../../concepts/hierarchy/) of the vault:

| Screen | What it shows | Main keys |
|---|---|---|
| **Projects** | Projects with their number of environments and variables. | `Enter` environments, `n` new, `e` edit, `d` delete, `y` history, `o` vault options, `u` users |
| **Environments** | Environments of a project with their number of sections and variables. | `Enter` sections, `n` new, `e` edit, `r` rename, `d` delete, `p` deploy, `i` import |
| **Sections** | **All sections** first, then **General** and every other section, with their comment. | `Enter` variables, `n` new, `e` edit, `d` delete |
| **Variables** | Key, value (secrets as `********`) and comment of each variable. | `Enter` detail, `n` new, `v` reveal, `s` state, `d` delete |
| **Variable detail** | The form of a variable, with its audit and history below. | `Enter` save, `Ctrl-V` show or hide the value |

Around them:

- **History** (`y`) lists the changes of a project or of the whole vault. See [Browse the history](../../guides/history/).
- **Deploy** (`p`) and **Import** (`i`) work on an environment. See [Deploy a .env file](../../guides/deploy/) and [Import a .env file](../../guides/import/).
- **Conflicts** (`c`, from any screen of the open vault) lists what a save could not merge. See [Resolve conflicts](../../guides/resolve-conflicts/).
- **Vault options** (`o`) and **Users** (`u`) hold the settings and members shared by everyone. See [Share a vault with a team](../../guides/share-a-vault/).
- **Unlock** covers every screen as soon as the vault locks.

## What every screen shares

**Key hints.** The last row of every list and form lists its keys, for example `Enter save · Tab next · ^V show/hide · ^G help · Esc back`. `^G` means `Ctrl-G`.

**Help.** `Ctrl-G` shows every key of the current screen, also while typing in a field. The full list is in [Keyboard shortcuts](../../reference/keyboard-shortcuts/).

**Filtering.** `/` filters a list; `Esc` clears the filter before it goes back.

**Forms.** One row per field, labels in a dimmed column, the focused field marked with `>`. `Tab` and `Shift-Tab` move between fields, `←` `→` change a choice. A form with unsaved edits shows `● modified` at the right of its last row.

**Pickers.** A field that takes one item among many (the section of a variable) shows `Enter to change`; `Enter` opens a box where typing filters the items and `Enter` chooses.

**Status bar.** The bottom line shows the latest notice, or the open vault as `<name> · <member> · <save state>`:

| Save state | Meaning |
|---|---|
| `saved` | Every change is on disk. |
| `unsaved` | Changes wait for the automatic save, one second after the first one. |
| `saving…` | The vault is being written. |
| `save failed, retry in Ns` | The last save failed and will be retried by itself. |
| `save failed` | The last save failed and is not retried by itself. |
| `conflict · c resolve` | The last save found conflicts; nothing is saved until you resolve them with `c`. |

Notices have four severities: info (plain), success (green), warning (yellow) and error (red). With `NO_COLOR` set, everything but info is bold.
