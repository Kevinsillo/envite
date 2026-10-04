---
title: Configuration file
description: Where envite keeps its configuration, logs and vaults, the fields of config.json and the environment variables it reads.
sidebar:
  order: 33
---

Envite keeps its local state in the **configuration root**, `$XDG_CONFIG_HOME/envite`, or `~/.config/envite` when `XDG_CONFIG_HOME` is not set:

```text
~/.config/envite/
├── config.json      settings of this machine and the known vaults
├── logs/            envite.<date>.log, one per day, the last 7 kept
└── vaults/          default location of new local vaults
```

Everything is created owner-only: `0600` for files, `0700` for directories. Logs never contain a value, a password or a key.

## config.json

Written atomically, readable by its owner only. It is created with the defaults on the first start and changed from the **Options** and **Vaults** screens; you do not need to edit it.

```json
{
  "version": 3,
  "autolock": 5,
  "default_kdf": "standard",
  "poll_interval_seconds": 10,
  "known_vaults": [
    {
      "id": "0192f0c1-7a6e-7c3b-9d2e-5f1a2b3c4d5e",
      "name": "Home",
      "location": "/home/alice/home.envite",
      "last_user": "alice"
    },
    {
      "id": "0192f0c2-1b2c-7d3e-8f4a-5b6c7d8e9f0a",
      "name": "Team",
      "location": "ssh://alice@host:22/srv/team.envite"
    }
  ],
  "last_vault": "0192f0c1-7a6e-7c3b-9d2e-5f1a2b3c4d5e",
  "last_update_check": "2026-10-04",
  "skipped_version": "1.2.0"
}
```

| Field | Meaning |
|---|---|
| `version` | Format version, always `3`. Checked before anything else. |
| `autolock` | `"never"` or a number of idle minutes, 1 to 120. Default `5`. |
| `default_kdf` | Key-derivation preset proposed for new passwords: `"standard"` or `"high"`. |
| `poll_interval_seconds` | How often an open vault checks for changes saved elsewhere, 5 to 300. Default `10`. |
| `known_vaults` | Known vaults in registration order: `id`, `name`, `location` (an absolute path or `ssh://user@host:port/path`) and optionally `last_user`, the member who opened it last. |
| `last_vault` | Optional `id` of the vault opened last, preselected on the home screen. |
| `update_check` | Optional. `false` when **Check for updates at startup** is off; written only then. Missing means on. |
| `last_update_check` | Optional local date, `YYYY-MM-DD`, of the last automatic check for a new version that completed. The check runs again on a later day. |
| `skipped_version` | Optional version chosen with **Skip this version**, such as `1.2.0`. Only a newer version is announced. |

The last three fields keep format version `3`: a file without them still loads, with the check on and never run.

A known vault is identified by its `id`, the UUID stored in the header of the vault file. `name` is only the local alias it is listed under: unique ignoring case, and renaming it never touches the file. Two known vaults never share an `id`, a `name` or a `location`.

## A file that cannot be read

When `config.json` exists but is not valid JSON, breaks a rule, was written by a newer version, or cannot be opened, envite does not start. It prints the reason with the path of the file and exits with status 1:

```text
envite: /home/alice/.config/envite/config.json: configuration file is malformed
envite: /home/alice/.config/envite/config.json: unsupported configuration version 4
```

The file is never modified or replaced. Fix it by hand, or move it away to start again from the defaults and add your vault files again with **Open existing**.

## Permission warnings

If `config.json` or the `logs/` directory grants any permission to its group or to other users, envite warns in the status bar at startup with the command that fixes it, for example:

```text
config.json is readable by other users — Run: chmod 600 /home/alice/.config/envite/config.json
```

The same check runs on a local vault file when it is opened. Envite never changes permissions itself.

## Environment variables

| Variable | Effect |
|---|---|
| `NO_COLOR` | When set and not empty, nothing is colored: styles use bold, reversed and underlined text only. |
| `HOME` | The home directory `~` stands for in the path of a file to import. |
| `TZ` | Time zone dates are shown in; the system default otherwise. |
| `XDG_CONFIG_HOME` | Parent of the configuration root. |
| `XDG_RUNTIME_DIR` | Where the sockets of shared SSH connections are kept; the system temporary directory otherwise. |

## Exit status

| Status | When |
|---|---|
| `0` | You quit. The open vault was saved and closed, and every SSH connection closed. |
| `1` | The configuration could not be read or created, a directory could not be created, the terminal could not be used (for example, standard output is not a terminal), or an internal error stopped envite. |
| `2` | The command line has an unknown command, option or argument; nothing was started. See [Command line](../command-line/), which also lists the statuses of `envite update`. |
