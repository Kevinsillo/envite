---
title: Vault file format
description: Version 1 of the .envite file — binary layout, header, cryptography, limits, schema versions and the lock protocol.
sidebar:
  order: 32
---

This page specifies version 1 of the envite vault file: its binary layout, its header, how it is encrypted, and how concurrent writers coordinate on disk.

## Binary layout

All integers are little-endian. `H` is the header length declared at offset 10.

| Offset | Length | Field | Description |
|---|---|---|---|
| 0 | 8 | magic | `89 45 4E 56 49 54 45 0A` (`\x89ENVITE\n`) |
| 8 | 2 | version | Format version, `u16`. This page describes version `1`. |
| 10 | 4 | header_len | Length `H` of the header, `u32`, at most 1 MiB. |
| 14 | `H` | header | Compact UTF-8 JSON. |
| 14 + `H` | 24 | nonce | XChaCha20-Poly1305 nonce of the payload, random per save. |
| 38 + `H` | rest | ciphertext | Encrypted zstd-compressed payload, followed by its 16-byte tag. |

The first 14 bytes are the **prefix**. The magic starts with a non-ASCII byte and ends with a newline, so transfers that strip the high bit or convert line endings corrupt it and are detected at once. Readers check the magic, the version, the declared header length and that enough bytes follow, in that order. The header can be read without reading the payload.

## Header

A JSON object; unknown fields are rejected at every level. Binary values are lowercase hexadecimal, identifiers are hyphenated UUIDs, timestamps are RFC 3339 in UTC.

| Field | Type | Description |
|---|---|---|
| `vault_id` | string | UUID of the vault. Never changes. |
| `revision` | integer | Revision of this file, `>= 1`, incremented by one on every save. |
| `cipher` | string | Cipher suite. Only `"xchacha20poly1305-zstd"` exists. |
| `default_kdf` | object | Key-derivation settings given to new members. |
| `last_saved` | object | `by`: username of the member who saved; `at`: timestamp. |
| `members` | array | Member slots, at least one; ids and usernames are unique. |

A KDF object has `preset` (`"standard"`, `"high"` or `"custom"`, a label only), `memory_kib`, `iterations` and `parallelism`. The parameters are authoritative.

A member slot has:

| Field | Description |
|---|---|
| `member_id` | UUID of the member. |
| `username` | Lowercase username. |
| `kdf` | KDF object of this member's password. |
| `salt` | Argon2id salt, 16 bytes. |
| `public_key` | X25519 public key, 32 bytes. |
| `private_key` | `nonce` (24 bytes) and `ciphertext` (32-byte private key plus 16-byte tag). |
| `vault_key` | `ephemeral_public` (32 bytes), `nonce` (24 bytes) and `ciphertext` (32-byte vault key plus 16-byte tag). |

```json
{
  "vault_id": "0190f3a2-7c41-7d2e-9b8a-3f5c2d1e0a9b",
  "revision": 42,
  "cipher": "xchacha20poly1305-zstd",
  "default_kdf": {"preset": "standard", "memory_kib": 65536, "iterations": 3, "parallelism": 4},
  "last_saved": {"by": "alice", "at": "2026-01-15T09:30:00Z"},
  "members": [
    {
      "member_id": "0190f3a2-7c41-7d2e-9b8a-000000000001",
      "username": "alice",
      "kdf": {"preset": "standard", "memory_kib": 65536, "iterations": 3, "parallelism": 4},
      "salt": "000102030405060708090a0b0c0d0e0f",
      "public_key": "8520f009…",
      "private_key": {"nonce": "1011…2627", "ciphertext": "a1b2c3…"},
      "vault_key": {"ephemeral_public": "de9edb7d…", "nonce": "3031…4647", "ciphertext": "d4e5f6…"}
    }
  ]
}
```

The values above are fake and shortened; the file stores the header as compact JSON.

## Cryptography

### Payload

- XChaCha20-Poly1305 with the 32-byte vault key and a fresh random 24-byte nonce on every save.
- Associated data: the prefix and the header (bytes `0 .. 14 + H`), so any change to the header makes the payload fail authentication.
- Opening a vault authenticates the whole file before decoding the header or decompressing the payload. A failed authentication is reported as tampering.

### Member keys

Every member owns an X25519 key pair. Below, `vault_id` and `member_id` are the 16 raw bytes of each UUID and `||` is concatenation.

**Private key encryption.** `KEK = Argon2id(password, salt)` (version `0x13`, the slot's parameters, 32-byte output, a fresh 16-byte salt every time). The private key is encrypted with XChaCha20-Poly1305 under `KEK`, with associated data `"envite/v1/private-key" || vault_id || member_id || public_key`.

**Vault key wrap.** Wrapping needs only the member's public key:

1. Generate an ephemeral X25519 key `e`; `ephemeral_public = X25519(e, 9)`.
2. `shared = X25519(e, public_key)`; an all-zero result is rejected.
3. `wrap_key = HKDF-SHA256(ikm = shared, salt = ephemeral_public || public_key, info = "envite/v1/vault-key-wrap" || vault_id || member_id)`.
4. Encrypt the vault key with XChaCha20-Poly1305 under `wrap_key`, with associated data `vault_id || member_id || ephemeral_public || public_key`.

**Unlock.** Derive `KEK` from the password, decrypt the private key (a failure reads exactly like an unknown username), check that it derives `public_key`, then unwrap the vault key with `shared = X25519(private_key, ephemeral_public)`.

**Rotation.** To revoke a member, any member generates a new vault key, wraps it for the public key of every remaining member and saves. No other password is needed; the removed slot is dropped.

**Password change.** Only the private key is re-encrypted, with a fresh salt and nonce. The key pair and the vault key wrap stay unchanged.

The binding of both encryptions to the vault, the member and the public key prevents moving a slot, a private key or a wrap elsewhere.

### Presets and bounds

| Preset | Memory | Iterations | Parallelism |
|---|---|---|---|
| `standard` | 64 MiB | 3 | 4 |
| `high` | 256 MiB | 4 | 4 |
| `custom` | 19 MiB to 2 GiB | 2 to 16 | 1 to 16 |

Parameters outside the bounds are rejected when reading the header, which caps the work a crafted header can demand. All randomness comes from the operating system's secure random source.

## Compression and limits

- The payload is compressed with zstd level 3 into a single frame that records its content size.
- Header: at most 1 MiB, checked from the declared length before reading it.
- Payload: at most 256 MiB uncompressed, checked before compressing and, when reading, from the declared frame size before decompressing.
- Decompression happens only after authentication, so only data written by a key holder reaches the decompressor.

## Database schema

The decompressed payload is a serialized SQLite database with `application_id` `0x454E5654` (`"ENVT"`). Its `user_version` is the **schema version**, independent of the format version: a schema change keeps the file at format version 1.

| Schema | Content |
|---|---|
| 1 | Tables, indexes and constraints of the first release. |
| 2 | Display order of environments, sections and variables; variable state; deploy fingerprint. |
| 3 | Comment of a section. |

When a vault is opened, every pending schema step runs in memory, each in its own transaction; the file holds the new schema from its next save on. Upgrades are one-way: a build refuses a vault whose schema is newer than the last one it knows, without touching the file. Once a member saves a vault with a newer build, every member needs a build at least as new.

The format version at offset 8 changes only for a new layout, header schema or cryptography. Readers reject any format version they do not know instead of guessing, and the magic never changes.

## Lock file and atomic writes

A vault lives on the local file system or on a host reached over SSH (`ssh://user@host:port/path`). Both follow the same protocol.

**Lock file.** Writers coordinate through `<vault>.lock`, a small owner-only JSON file:

```json
{"username":"alice","pid":4242,"token":"0190f3a2-7c41-7d2e-9b8a-3f5c2d1e0a9b","created_at":"2026-01-15T09:30:00Z"}
```

- It is published with an exclusive creation that never overwrites: locally, a temporary file hard-linked to `<vault>.lock`; remotely, a shell with `umask 077` and `noclobber`.
- A lock older than **2 minutes** is stale and may be taken over; one dated in the future never is. To remove a lock, a process renames it aside with its own token, checks it is the lock it meant to remove, and deletes it.
- Before every write the store checks that the lock still carries the writer's token.
- The lock is taken for each save only and released as soon as that save is done, never held while a vault is open.

**Revisions.** A save carries the revision it was based on. The store refuses the write unless the writer still holds the lock, the revision on disk equals the expected one, and the new bytes carry exactly the next revision. A refused write leaves the file byte-identical.

**Atomic replacement.** Orphan temporary files are removed; the new content is written to `.<file_name>.<random>.tmp` in the same directory, owner-only; locally it is flushed to disk; it is renamed over the vault; locally the directory is flushed. Readers always see either the old or the new file. On a remote host nothing is flushed explicitly.

The merge that happens when the revision changed is described in [Sync and conflicts](../../concepts/sync-and-conflicts/).

## Files a deploy writes

Besides the `.env` file itself, a deploy leaves on its target:

- **Backups** in `.envite-backups/`, named `<file>.<YYYYMMDD-HHMMSS>.bak`, the 10 most recent per file kept.
- **Temporary files** `.<file>.envite-<id>.tmp`, renamed over the target; a failed deploy removes its own.

Modes are `0660` and `0770` with a unix group, `0600` and `0700` without. See [Deploy a .env file](../../guides/deploy/).
