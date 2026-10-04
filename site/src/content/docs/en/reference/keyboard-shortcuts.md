---
title: Keyboard shortcuts
description: Every key of envite, the context it works in, and the keys of each screen.
sidebar:
  order: 30
---

Keys are read in one of two contexts:

- **Navigating** — lists and screens without a focused text field. Letters may be shortcuts.
- **Typing** — a text field has the focus. Letters are text; only the keys marked **always** keep their meaning.

`Ctrl-G` shows the keys of the current screen at any time, also while typing. The last row of every screen lists its main keys, with `^G` for `Ctrl-G` and `^V` for `Ctrl-V`.

## Global keys

| Key | Context | Action |
|---|---|---|
| `Ctrl-G` | always | Show the keys of the current screen. |
| `Ctrl-L` | always | Lock the open vault. |
| `Ctrl-V` | always | Show or hide a secret value, also while typing it. |
| `Ctrl-R` | always | Reconnect to the SSH host, only when the status bar asks for it. |
| `Ctrl-C` | always | Quit from anywhere, safely: the open vault is saved and closed first. Waits while an update is installed. |
| `q` | navigating | Quit, only from the home screen (same as **Exit**). |
| `Esc` | always | Go back; clear the filter of a list first; close the help, a dialog or a picker. From **Projects**, save and close the vault. |

## Moving and editing

| Key | Context | Action |
|---|---|---|
| `↑` `↓` `←` `→` | always | Move. In a form, `↑` `↓` go to the previous or next field (in a field of several lines, between its lines first); `←` `→` change a choice. |
| `k` `j` `h` `l` | navigating | Move, like the arrows. |
| `Enter` | always | Select or confirm. In a field of several lines it adds a line; on a field with a picker it opens the picker. |
| `Tab` / `Shift-Tab` | always | Next / previous field. |
| `/` | navigating | Filter the list. |
| `Backspace` / `Del` | always | Delete the previous / next character. |
| `Home` / `End` | always | Go to the start / end of the field; in a picker, to the first / last item. |
| `PgUp` / `PgDn` | always | Move the selection of a picker by ten items. |

## Action keys

| Key | Context | Action |
|---|---|---|
| `n` | navigating | Create a vault (home, vaults), a project, an environment, a section or a variable; add a member (users). |
| `o` | navigating | Open an existing vault (home, vaults); open the options of the vault (projects). |
| `e` | navigating | Edit the selected project, environment, section or variable; choose for the selected conflict; change your password (users). |
| `r` | navigating | Rename the selected known vault (vaults) or environment; edit the selected section, like `e`. |
| `d` | navigating | Remove the selected vault from the list; delete the selected project, environment, section or variable, after asking; remove the selected member, after asking (twice for yourself). |
| `v` | navigating | Show or hide the secret value of the selected variable, of the variable edited, of the selected row of a preview, or of a conflict. |
| `s` | navigating | Cycle the state of the selected variable (variables); switch the selected key between skip and overwrite (import preview). |
| `p` | navigating | Preview the deploy of the selected environment. |
| `i` | navigating | Import pairs into the selected environment. |
| `c` | navigating | Open the conflicts left by the last save, from any screen of the open vault. |
| `y` | navigating | Show the history of the selected project, or of the vault. |
| `u` | navigating | Open the members of the vault (projects); cycle the member filter (history). |
| `w` `t` `a` | navigating | History only: switch project / vault, cycle the kind of entity, cycle the action. |

## Keys by screen

| Screen | Keys |
|---|---|
| Home | `Enter` open · `n` new vault · `o` open existing · `q` quit |
| Vaults | `Enter` open · `n` new · `o` open existing · `r` rename · `d` remove from the list · `/` find |
| Projects | `Enter` environments · `n` new · `e` edit · `d` delete · `y` history · `o` vault options · `u` users · `/` find · `Esc` close the vault |
| Environments | `Enter` sections · `n` new · `e` edit · `r` rename · `d` delete · `p` deploy · `i` import · `/` find |
| Sections | `Enter` variables · `n` new · `e` or `r` edit · `d` delete · `/` find |
| Variables | `Enter` or `e` detail · `n` new · `v` reveal · `s` state · `d` delete · `/` find |
| Variable detail | `Enter` save (or open the section picker on **Section**) · `Tab` next · `v` / `Ctrl-V` show or hide the value |
| Deploy | `v` reveal the row · `Enter` deploy · `Esc` cancel |
| Import preview | `s` skip / overwrite · `v` reveal the row · `Enter` import · `Esc` cancel |
| Conflicts | `Enter` or `e` choose · `Enter` resolve when every conflict has a choice · `/` find · `Esc` back, dropping the choices |
| Conflict | `←` `→` choice · `v` / `Ctrl-V` reveal · `Enter` keep the choice · `Esc` back without it |
| History | `w` project / vault · `u` member · `t` kind · `a` action · `/` search |
| Users | `n` add · `e` your password · `d` remove · `/` find |
| Vault options, Options | `Enter` save · `Tab` next · `←` `→` choose |
| Dialog | `←` `→` or `Tab` between the answers, wrapping around · `Enter` answer · `Esc` cancel (**Later** in the offer of a new version) |
| Picker | type to filter · `↑` `↓` · `PgUp` `PgDn` · `Home` `End` · `Enter` choose · `Esc` cancel |

## Why Ctrl-G and not F1

Many terminal emulators take `F1` for their own help, so envite uses `Ctrl-G`, as `nano` does. `?` and `g` are ordinary characters you may need to type.

## Keys while envite is busy

While envite waits for a request, or for the vault to lock or close, up to 32 keys wait in a queue and are replayed in order once it is done; later ones are dropped. A replayed key that changes the screen drops the keys after it. `Ctrl-C` and the answers to a question are never queued. The queue is never logged, since it may hold the characters of a password.
