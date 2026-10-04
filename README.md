<div align="center">

# Envite

***Encrypted vaults for your environment variables — shared by a team, local or over SSH, deployed as .env files.***

[Documentation](https://kevinsillo.github.io/envite/) · [Releases](https://github.com/Kevinsillo/envite/releases) · [Issues](https://github.com/Kevinsillo/envite/issues)

</div>

Envite is a terminal application that keeps the environment variables of your projects in a single encrypted `.envite` file. Every team member opens it with their own password, the file can live on your disk, in a synced folder or on a server over SSH, and concurrent edits merge on save. When an environment is ready, envite shows a key-by-key diff and writes its `.env` file to the target, locally or over SSH.

## Core concepts

| Term | Meaning |
|---|---|
| **Vault** | One encrypted file with all your projects and their members. |
| **Project** | An application, with its own details (author, license, description…). |
| **Environment** | A deployment of a project (`production`, `staging`…), with its own `.env` target. |
| **Section** | A titled group of variables inside an environment, with an optional comment. |
| **Variable** | A `KEY=value` pair with a comment, secret masking and an enabled / disabled / commented state. |
| **History** | Every change is recorded with who made it, when and which fields changed: browse it for the whole vault or a project, filtered by member, item type or action, or below each variable. Secret values are never shown. |
| **Deploy** | Render the `.env` file of an environment, preview the diff and write it atomically, with a backup. |

## Quick install

```bash
curl -fsSL https://raw.githubusercontent.com/Kevinsillo/envite/main/install.sh | bash
```

- A single static binary for Linux x86_64, no runtime dependencies, installed to `~/.local/bin` after checking its SHA-256; `envite --version` prints the installed version.
- The system `ssh` client is used for remote vaults and deploys.
- `envite update` installs the latest release after checking its SHA-256 (it needs `curl`). Once a day at startup envite also looks for a new version and offers it; turn that off in **Options**.
- The first release will be 1.0.0; until then there is nothing to download.

Version, install directory, manual download and updating → [Installation](https://kevinsillo.github.io/envite/en/getting-started/installation/)

## Quick start

1. Run `envite` and press `n` to create a vault: a name, a location and your first member with a password.
2. Press `n` on **Projects**, then go down with `Enter` to create an environment, its sections and variables.
3. On **Environments**, press `p` to preview the deploy of the `.env` file, then `Enter` and confirm to write it.
4. Add teammates from **Users** (`u`); they add the vault file with `o` on the home screen.

Walkthrough → [First start](https://kevinsillo.github.io/envite/en/getting-started/first-start/)

## Key shortcuts

| Key | Action |
|---|---|
| `Ctrl-G` | Show the keys of the current screen |
| `n` / `e` / `d` | New, edit, delete |
| `/` | Filter the list |
| `v` / `Ctrl-V` | Reveal or hide a secret value |
| `p` / `i` | Deploy / import a `.env` file (environments) |
| `c` | Resolve conflicts with changes saved elsewhere |
| `Ctrl-L` | Lock the vault |
| `Ctrl-C` | Save, close and quit |

Full list → [Keyboard shortcuts](https://kevinsillo.github.io/envite/en/reference/keyboard-shortcuts/)

## This repository

This repository hosts the [documentation site](https://kevinsillo.github.io/envite/) (Astro Starlight, deployed to GitHub Pages), the installer (`install.sh`) and the binary releases. The source code of envite is kept in a private repository.

```bash
pnpm install
pnpm dev
```

## License

Freeware: the envite binaries are free to download and use, for personal and commercial purposes; the source code is not public. The binaries and the texts of this repository are covered by the [envite license](LICENSE). Each release lists the licenses of the third-party components it includes in `THIRD-PARTY-LICENSES.md`.
