---
title: Projects, environments, sections and variables
description: The four levels a vault is organized in, and what each one holds.
sidebar:
  order: 11
  label: Hierarchy
---

The content of a vault is organized in four levels: **project → environment → section → variable**. Each environment produces one `.env` file.

```text
Vault
└── Project            api
    ├── Environment    production    → /srv/api/.env on web-1
    │   ├── Section    General
    │   │   ├── APP_ENV=production
    │   │   └── LOG_LEVEL=info
    │   └── Section    database
    │       ├── DB_HOST=db.internal
    │       └── DB_PASS=********
    └── Environment    staging       → /srv/api-staging/.env on web-2
```

## Project

A project is an application or a service. Only its name is required; the other fields describe it and are written as comments in the header of every `.env` file it generates:

| Field | Notes |
|---|---|
| **Name** | Required. |
| **Author**, **Organization**, **License**, **URL** | Free text. |
| **Date** | `YYYY-MM-DD`. |
| **Description** | Several lines. |
| **Unix group** | Group given to deployed files; never written in the file. |

Deleting a project deletes its environments, sections, variables and history.

## Environment

An environment is one deployment of a project: `production`, `staging`, `local`… Its name is unique within the project, ignoring case. It also says where its `.env` file goes:

| Field | Meaning |
|---|---|
| **Server** | Blank for this machine (a local deploy), or an SSH destination: a host alias from `~/.ssh/config`, `user@host`, or `ssh://user@host:port`. |
| **Target path** | Required. The directory the file is written into; it must exist. |
| **File name** | Blank for `.env`. |

Every environment is created with a default section, **General**.

## Section

A section groups related variables, for example everything about the database. In the `.env` file each section is a titled block, in the order of the environment, **General** first.

A section can have an optional comment of several lines, written under its title in the `.env` file, so you do not have to comment every key. **General** can be given a comment but can be neither renamed nor deleted. Deleting another section deletes its variables.

## Variable

A variable belongs to a section and has:

| Field | Meaning |
|---|---|
| **Key** | An environment variable name: a letter or `_`, then letters, digits or `_`. Stored and shown in uppercase. |
| **Value** | Any text, possibly several lines. |
| **Comment** | Optional, written as `# …` right before the variable in the `.env` file. |
| **Secret** | Masks the value everywhere until it is revealed. See [Secrets and masking](../secrets/). |
| **State** | Enabled, disabled or commented. See [Variable states](../variable-states/). |

The key is unique within the **environment**, not only within the section, because the `.env` file is flat. A variable can be moved to another section of its environment; it goes to the end of that section.

Every record also keeps its audit: who created it and when, and who modified it last and when, shown in the variable detail.
