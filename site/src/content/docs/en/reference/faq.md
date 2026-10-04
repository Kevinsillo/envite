---
title: FAQ and troubleshooting
description: Answers to common questions and fixes for common problems with terminals, SSH, permissions and vaults.
sidebar:
  order: 37
---

## Keys and terminal

### F1 does not open the help

The help is on `Ctrl-G`, not `F1`: many terminal emulators take `F1` for their own help. `Ctrl-G` works everywhere in envite, also while typing in a field.

### Typing `?` or `g` does not open anything

They are ordinary characters, so you can type them in fields and passwords. Use `Ctrl-G` for the help.

### The colors look wrong, or I want no colors

Envite uses only the 16 ANSI colors, so it follows the palette of your terminal, light or dark. Set `NO_COLOR` to any non-empty value to turn colors off: styles then use bold, reversed and underlined text, and what is selected or focused is also marked with `>`.

```bash
NO_COLOR=1 envite
```

### The key hints are cut off

The hints of every screen fit in 80 columns. Widen the terminal to at least 80 columns.

### envite exits right away with status 1

Standard output must be a terminal: envite cannot run with its output piped or redirected. If a message mentions `config.json`, see [A file that cannot be read](../configuration/#a-file-that-cannot-be-read).

## SSH

### The terminal suddenly shows an ssh prompt

That is expected. When a host needs a password, a key passphrase, a second factor or confirming its key while you wait for something, envite hands the terminal over to `ssh`, printing `Connecting to <host>; ssh may ask for credentials.` Answer `ssh`; envite takes the terminal back and retries.

### The status bar says "SSH authentication required — press Ctrl-R"

A background save or check needs to authenticate. Envite never takes the terminal from you on its own, so it waits: press `Ctrl-R` to connect in the foreground. Loading your key into `ssh-agent` avoids the question altogether.

### "The host key of … has changed; the connection was refused"

The server presents a different host key than the one in `known_hosts`. Envite never lets you accept it from the interface. Verify the server's identity, then fix `~/.ssh/known_hosts` yourself, for example with `ssh-keygen -R <host>`.

### Does envite use my ~/.ssh/config?

Yes. It runs the system `ssh`, so host aliases, `ProxyJump`, identity files and the agent all apply. A host alias can be used as the **Server** of an environment.

## Vaults

### I forgot my password

There is no recovery. Ask another member to remove you and add you again with a new password. If no member remembers their password, the vault cannot be opened.

### "Invalid credentials" although the password is right

Check the username: a wrong username and a wrong password give the same message on purpose. Usernames are lowercase.

### "The file at this location is a different vault than the one registered under this name"

Another vault file was put at the location of a known vault. Remove the entry from **Vaults** (`d`) and add the file again with **Open existing**.

### "This vault is already known at another location"

The same vault, for example a copy of the file, is already in your list under another path. Use the existing entry, or remove it first.

### The status bar says `conflict · c resolve`

Your save and another member's save changed the same thing. Press `c`; see [Resolve conflicts](../../guides/resolve-conflicts/).

### A warning says a file is readable by other users

Run the `chmod` command the warning shows. Envite creates its files owner-only and never changes permissions itself.

## Links and browser

### GitHub or Open issue does not open a browser

Envite opens links with `xdg-open`. When it cannot be started, a warning shows the address so you can open it yourself. Install `xdg-utils` or the equivalent package of your distribution.

## Updates

### Does envite connect to the internet by itself?

Only to check for a new version: at most once a day, when it starts, it asks GitHub which release is the latest. Without network the check fails silently. Turn it off with **Check for updates at startup** in [Options](../../guides/options/). See [Installation](../../getting-started/installation/#check-at-startup).

## Platforms

### Does envite run on macOS or Windows?

Not yet. Envite is published as a static Linux x86_64 binary only.
