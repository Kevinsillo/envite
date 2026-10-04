---
title: Vaults
description: What a vault is, how members open it with their own keys, and how it is saved, locked and unlocked.
sidebar:
  order: 10
---

A **vault** is a single encrypted file, with the `.envite` extension, that holds the whole content of a team: projects, environments, sections, variables and their history. It is the source of truth: the `.env` files on your servers are generated from it.

## One file

The file has two parts:

- a **public header** with the vault's id, its revision, the key-derivation settings, who saved it last, and one slot per member;
- an **encrypted payload**: a SQLite database, compressed with zstd and encrypted with XChaCha20-Poly1305.

The header is bound to the payload as associated data, so any change to the header makes the file fail to open. Everything inside the payload — names, keys, values, comments, history — is encrypted. The [vault file format](../../reference/vault-format/) describes the layout byte by byte.

Because it is one file, a vault can be kept anywhere a file can: your disk, a synchronized folder, a network share, or a server reached over SSH (see [Remote vaults](../remote-vaults/)). Each machine keeps its own list of **known vaults**, where the vault is identified by its id and listed under a local alias you can rename freely.

## Members and keys

Every **member** has a username and their own password; nobody shares a password. Behind the password:

1. The payload is encrypted with a random 256-bit **vault key**.
2. Each member owns an X25519 **key pair**. The public key is stored in their slot in the clear; the private key is stored encrypted with a key derived from their password.
3. The vault key is wrapped for each member's public key.

Opening the vault derives the key from your password, decrypts your private key and unwraps the vault key. Since wrapping only needs public keys, any member can add a member, or **rotate** the vault key after removing one, without knowing anyone else's password.

All members have the same rights: every member can read everything, add and remove members, and change any setting of the vault.

## Key derivation

Passwords are stretched with Argon2id. Each password records its own settings, chosen among presets:

| Preset | Memory | Iterations | Parallelism | Unlock time |
|---|---|---|---|---|
| **Standard** | 64 MiB | 3 | 4 | about 0.5 s |
| **High** | 256 MiB | 4 | 4 | about 2 s |

**High** is slower to unlock and harder to attack. The vault has a default preset proposed for new members (in **Vault options**), and each member can change the preset of their own password at any time. A vault can also carry **Custom** settings, which envite keeps as they are.

## Automatic saving

There is no save command. Every change is saved automatically, one second after the first change, grouping the changes made meanwhile into one write. The status bar shows the save state (`unsaved`, `saving…`, `saved`…). A failed save is retried by itself when it makes sense, for example when another member is saving at that very moment.

Saving never edits the file in place: a new file is written next to it and atomically renamed over the old one, so readers always see either the old or the new version. A small lock file next to the vault keeps two members from writing at the same instant.

## Locking

An open vault **locks** after a few idle minutes (5 by default; 1 to 120, or never, in [Options](../../guides/options/)), and `Ctrl-L` locks it at once. Only key presses count as activity.

Locking first saves the vault, then keeps its content sealed in memory, encrypted exactly as in a vault file, and forgets the vault key, your private key and every plaintext value. The **Unlock** screen covers every other screen, so nothing stays in sight; it asks for the password of the member who locked it.

Before locking, the screens drop every secret they show: revealed values are masked again, and the detail of a variable, the deploy and import previews and the conflicts are closed, discarding what they held. A draft in a variable detail is lost without asking.

If the content cannot be sealed in memory, the vault stays hidden behind a **Not locked** screen that offers to try again once, and then only to discard the vault.

## Closing and quitting

`Esc` on **Projects** saves and closes the vault. Quitting (`q` on the home screen, **Exit**, or `Ctrl-C` anywhere) also saves and closes it first; if it has unsaved changes envite asks before quitting, and a locked vault with unsaved changes offers to unlock it to save, or to discard the changes.

## Password recovery

There is none. A member who forgets their password can be removed by another member and added again with a new password. If every member forgets their password, the vault cannot be opened by anyone.
