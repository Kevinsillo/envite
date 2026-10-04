---
title: Remote vaults over SSH
description: How envite keeps a vault on a server with the system ssh client, and how it asks for credentials.
sidebar:
  order: 16
---

A vault can live on a server instead of your disk. Its location is then `ssh://user@host:port/path`, given in the forms as an **SSH host** (`user@host` or `user@host:port`) and a path. The same applies to the servers environments are deployed to.

## The system ssh client

Envite does not implement SSH itself. It runs your system `ssh`, so everything you already configured applies: `~/.ssh/config`, `known_hosts`, the SSH agent, `ProxyJump` and your keys.

Connections to a host are shared: envite opens one master connection per host (OpenSSH `ControlMaster`) and runs every operation through it — reading the vault, saving it, checking for changes, deploying. The connection sockets live in `$XDG_RUNTIME_DIR` (or the system temporary directory). Connections are closed when the vault is locked, closed or dropped, and when envite quits.

## What travels over the connection

Like a local vault, a remote vault is read whole when it is opened and written whole on every save, through a temporary file renamed over the vault. Checking for changes reads only the header, in two small reads. The lock file is created with `noclobber`, so two members never hold it at once. Files are written on the host with `umask 077`.

The timestamps of the lock come from the clock of your machine, never the host's.

## Authentication

Envite first tries to connect without asking anything (`BatchMode`), which works with keys in your agent or without a passphrase. When the host needs more — a password, a key passphrase, a second factor, or confirming an unknown host key — it depends on what you are doing:

- **In the foreground** (opening, creating or adding a vault, unlocking, reconnecting, previewing or running a deploy, importing from a deploy target, resolving conflicts, removing a member), envite hands the terminal over to `ssh`. It prints `Connecting to <host>; ssh may ask for credentials.`, lets `ssh` talk to you, then takes the terminal back and retries the operation once.
- **In the background** (an automatic save or a check for changes), envite never takes the terminal from you. The status bar shows `SSH authentication required — press Ctrl-R` and the background work waits. Press `Ctrl-R` to connect in the foreground as above.

A host whose key changed is never handed the terminal: the connection is refused with a message naming the host. Verify the server and fix `known_hosts` yourself.

## Limits

- Nothing is flushed explicitly on the host: a crash of the host right after a save may lose that save.
- If the connection drops right after a save was renamed into place, the save is reported as failed; the next save recognises the write as its own and carries on.
