---
title: Secrets and masking
description: How secret values are masked on every screen and revealed only on request.
sidebar:
  order: 12
---

Every value in a vault is encrypted on disk. On top of that, a variable marked **secret** has its value masked on screen: it shows as `********`, always eight characters whatever its length, until you ask to see it.

## Where values are masked

| Place | What you see |
|---|---|
| Variables list | `********` for a secret value; the list never even receives it. |
| Variable detail | `********` while editing a secret value. |
| History | `value ********` for every change of a value, secret or not. |
| Deploy preview | Every value of both files as `********`. |
| Import preview | Every value read as `********`. |
| Conflicts | The value of a variable that is secret on either side as `********`. |

Only the value is masked. The key, the comment, the section and the state of a secret variable show in clear.

## Revealing a value

- `v` on a secret row of the **Variables** list shows its value; `v` again masks it.
- In the variable detail, `v` (or `Ctrl-V` while typing) shows or hides the value being edited. Once shown, the value can be edited like any other field.
- In the deploy and import previews and in a conflict, `v` (or `Ctrl-V`) reveals the value of the selected row only.

A revealed value is held by that screen only. It is masked again when the list is read again, when you leave the screen, when you move to another row in a preview, and when the vault locks.

## What never shows a value

- The history never records a readable value: a change of the value always reads `value ********`.
- Logs, error messages and the debug output of envite never contain a value, a password or a key.
- Merge conflicts are named without values; the values travel only in the detail of one conflict.

## Commented variables

A commented variable is written to the `.env` file as `# KEY=value`, with its real value, even when it is secret. Use the **disabled** state to keep a value out of the file entirely. See [Variable states](../variable-states/).
