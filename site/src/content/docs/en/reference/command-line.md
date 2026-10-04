---
title: Command line
description: The commands and options envite accepts, what each one prints, and its exit statuses.
sidebar:
  order: 34
---

Envite is used from its terminal interface: run it without arguments to open it. From the command line, a few options print information and exit right away, without opening the interface and without creating any file, and `envite update` updates the binary.

## Usage

```text
envite [OPTIONS]
envite update [--yes]
```

| Command or option | Effect |
|---|---|
| none | Opens the terminal interface. |
| `update` | Updates envite to the latest release. See [envite update](#envite-update). |
| `-V`, `--version` | Prints `envite <version>`, for example `envite 1.0.0`, and exits. |
| `-h`, `--help` | Prints a summary of the usage and exits. `--help` prints a longer description than `-h`. After `update`, it describes that command. |

Check which version is installed:

```bash
envite --version
```

An unknown command, option or argument prints an error and the usage to the standard error:

```text
error: unexpected argument 'foo' found

Usage: envite [COMMAND]

For more information, try '--help'.
```

## envite update

Checks the latest release published on [GitHub Releases](https://github.com/Kevinsillo/envite/releases) and, when it is newer than the running version, installs it in place of the binary you ran:

```bash
envite update
```

```text
Checking for updates...
envite 1.1.0 is available (installed: 1.0.0)
Install envite 1.1.0? [y/N] y
Downloading envite 1.1.0...
Updated envite 1.0.0 → 1.1.0. Run envite again to use it.
```

When the running version is the latest one, it prints `envite <version> is up to date` and changes nothing.

| Option | Effect |
|---|---|
| `-y`, `--yes` | Installs without asking for confirmation. |

Without `--yes`, the question is asked on the terminal and any answer other than `y` or `yes` cancels the update. When the standard input is not a terminal, for example in a script or a pipe, nothing is asked and nothing is installed: the command fails and suggests `--yes`.

```bash
envite update --yes
```

The update needs the system `curl` and write access to the directory of the binary. Before downloading anything, it checks that this machine has a release build (Linux on x86_64) and that the directory takes new files. It then downloads `envite-<version>-x86_64-linux-musl.tar.gz` and `SHA256SUMS.txt` over HTTPS only and checks the SHA-256 of the archive. From the archive it takes only the file `envite`, writes it next to the current binary with the same permissions, runs it with `--version` to check that it reports the new version within 10 seconds (it is stopped otherwise), and renames it over the current binary. If any step fails, the installed binary is left as it was and the error is printed:

```text
envite: curl is needed to update envite; install it and try again
envite: /usr/local/bin is not writable: run the update as a user who can write to it, or install again with the installer
envite: the checksum of envite-1.1.0-x86_64-linux-musl.tar.gz does not match: the download may be corrupted, try again
```

The running envite keeps working until it exits; run `envite` again to use the new version.

## Exit status

| Status | When |
|---|---|
| `0` | You quit the interface, `--version` or `--help` printed its answer, or `envite update` installed the new version, found envite up to date, or was cancelled. |
| `1` | Envite could not start or stopped on an error, or `envite update` failed or had no terminal to confirm on without `--yes`. The reason is printed as `envite: <reason>` to the standard error. See [Configuration file](../configuration/#exit-status) for the cases of the interface. |
| `2` | The command line has an unknown command, option or argument. Nothing was started and no file was created. |
