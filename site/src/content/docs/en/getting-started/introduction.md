---
title: Introduction
description: What envite is, the problem it solves and how its pieces fit together.
sidebar:
  order: 1
---

Envite is a terminal application that keeps the environment variables of your projects in encrypted vaults and deploys them as `.env` files. A vault is shared by a team: every member opens it with their own password, and it can live on your disk, in a synchronized folder or on a server reached over SSH.

## The problem

Environment variables tend to live in too many places: `.env` files copied between laptops, passwords pasted into chat, notes that nobody updates, servers whose `.env` was edited by hand and no longer matches anything. Nobody knows which value is current, who changed it, or what the file on the server really holds.

## What envite does

- **One source of truth.** The vault holds every project, environment, section and variable. Nothing is kept in the clear: the whole content is encrypted in a single `.envite` file.
- **Team access without shared passwords.** Each member has their own key pair and password. Adding a member never reveals anyone else's password; removing one rotates the vault key.
- **Concurrent editing.** Several members can have the same vault open at once. Changes are saved automatically and merged field by field; a real conflict is shown side by side so you can choose.
- **Controlled deploys.** Envite renders the `.env` file of an environment, compares it key by key with the file at the target and writes it only after you confirm, with a backup of the previous file and a warning when someone changed it by hand.
- **Secrets stay masked.** Secret values show as `********` everywhere — lists, history, diffs — until you explicitly reveal one.

## What envite is not

Envite is not a secret server: there is no daemon, no network service and no account. It is a single binary that reads and writes files, using the system `ssh` client for anything remote. It does not inject variables into running processes either; it writes `.env` files that your applications or tools already read.

## Platform

Envite runs on Linux, as a single static x86_64 binary. Other platforms are not supported yet.

## Next steps

1. [Install envite](../installation/).
2. [Create or open your first vault](../first-start/).
3. Take the [tour of the screens](../tour/).

The [concepts](../../concepts/vaults/) section explains how vaults, members and merging work in depth.
