---
title: Security model
description: What envite protects, how it hardens the process, and the limits it does not try to cover.
sidebar:
  order: 35
---

Envite protects the content of a vault against anyone who can read the file but is not a member: whoever stores it, syncs it or backs it up. This page summarizes the encryption, the hardening of the process and the known limits.

## Encryption

- The whole content is encrypted with XChaCha20-Poly1305 under a random 256-bit vault key, with a fresh nonce on every save.
- The header is authenticated as associated data: any change to it is detected when the vault is opened.
- Each member's password is stretched with Argon2id (64 MiB or 256 MiB presets) and protects only that member's X25519 private key; the vault key is wrapped for each member's public key.
- Removing a member rotates the vault key, so the removed member cannot read revisions saved afterwards.

The details are in the [vault file format](../vault-format/#cryptography).

## Secrets in the interface

- Secret values show as `********` on every screen until revealed with `v`, and are masked again when you leave the screen or the vault locks.
- The history, the deploy and import previews and the conflict list never show a value unless you reveal it.
- Passwords are edited in a dedicated field that is wiped from memory.
- Logs, error messages and debug output never contain a value, a password or a key.
- The vault locks after a few idle minutes; locking keeps only encrypted content in memory and forgets every key and plaintext value.

## Process hardening

On start, before anything else, envite:

- **disables core dumps** (`RLIMIT_CORE` set to 0, soft and hard limits), so the memory of an open vault never ends up in a core file;
- **sets the file mode creation mask to `077`**, so every file or directory it creates without an explicit mode is owner-only.

If a step cannot be applied it is logged as a warning and envite carries on.

Envite also **warns about loose permissions**: if `config.json`, the logs directory or a local vault file grants any permission to its group or to other users, the status bar shows the `chmod` command that fixes it. It never changes permissions itself. Remote vaults are written with `umask 077`.

## Known limitation: memory of the open vault

While a vault is open, its decrypted content lives in an in-memory SQLite database. SQLite does not guarantee that freed or moved pages are wiped, so plaintext may linger in the process memory until it is reused. Keys and passwords themselves are kept in memory that is wiped on drop (best effort).

Disabling core dumps keeps that memory out of crash dumps. Systems that pipe core dumps to a handler (`systemd-coredump`, `apport`) generally respect the limit, but this is not guaranteed. The memory may also reach swap unless swap is encrypted.

## Not protected, by design

- **Metadata is visible** to anyone with the file: the vault id, revision, member ids, usernames, public keys, key-derivation settings, who saved last and when, and the approximate size of the content.
- **No protection against a member.** Every member can decrypt everything, add or remove members and rewrite the history.
- **Removal is not retroactive.** A removed member keeps any copy of the file they already had, which still opens with their old password, and any value they saw. Rotate the affected secrets after removing a member.
- **No rollback protection.** Replacing the file with an older valid copy is not detected.
- **Locks are cooperative** and rely on reasonably synchronized clocks between members' machines.
- **No durability guarantee on a remote host**: nothing is flushed there explicitly.
- **The member key stays in memory** while a vault is open, so that a vault key rotated by another member can be recovered without the password. It is wiped when the vault is locked or closed.
- **A compromised machine** of a member — malware, a keylogger, a memory dump — is out of scope.

## Deployed files

A `.env` file on a server is plaintext by nature. Envite writes it with `0600` (owner only) or `0660` with a unix group, through an atomic rename, and keeps up to 10 backups next to it in `.envite-backups/` with the same permissions. Protect the target directory accordingly.

## Updates

`envite update` and **Check for updates** download a release over HTTPS only, redirects included, with the system `curl`, and install nothing unless the SHA-256 of the archive matches the one in the `SHA256SUMS.txt` of the same release. Only the `envite` file is taken from the archive, and only when it is a regular file; the new binary must run and report the expected version within 10 seconds before it replaces the current one in a single rename. Both files come from the same GitHub release, so the checksum detects a corrupted or truncated download, not a release replaced by someone who controls the repository.

At most once a day, when it starts, envite makes one outgoing HTTPS request to GitHub, with the system `curl`, to read which release is the latest; it sends nothing about you or your vaults, and installs nothing unless you choose **Update**. Turn it off with **Check for updates at startup** in [Options](../../guides/options/); envite then contacts GitHub only when you check for updates yourself.
