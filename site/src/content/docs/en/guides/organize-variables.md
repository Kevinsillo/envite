---
title: Organize variables
description: Create projects, environments, sections and variables, add comments, and move variables between sections.
sidebar:
  order: 21
---

Variables live in sections, sections in environments and environments in projects. Each level has its own list screen with the same keys: `n` creates, `e` edits, `d` deletes after asking, `/` filters and `Enter` goes one level down.

## Create a project

On **Projects**, `n` opens **New project**. Only the **Name** is required. The other fields — **Author**, **Organization**, **License**, **URL**, **Date** (`YYYY-MM-DD`) and **Description** — are written in the header of the `.env` files of the project. **Unix group** sets the group of its deployed files.

In the description, `Enter` adds a line; on any other field it saves.

## Create an environment

Select a project, press `Enter`, then `n` on **Environments**. **New environment** asks for:

- **Name** — unique within the project, ignoring case.
- **Server** — blank to deploy on this machine, or an SSH destination: a host alias from `~/.ssh/config`, `user@host`, or `ssh://user@host:port`.
- **Target path** — the directory the file goes into. It must already exist on the server.
- **File name** — blank for `.env`.

`r` renames an environment; `e` edits all its fields.

## Use sections

Each environment starts with a **General** section. Add more with `n` on **Sections** to group related variables: a section becomes a titled block in the `.env` file.

Give a section a **Comment** to explain the whole block once, instead of commenting every key. The comment can span several lines and is written under the section title:

```bash
# ---------------------------------------------------------------------
#  database
#  Connection to the primary database
# ---------------------------------------------------------------------
DB_HOST=db.internal
```

**General** can get a comment but can be neither renamed nor deleted. Deleting another section deletes its variables; the confirmation says how many.

The first row of **Sections**, **All sections**, lists every variable of the environment, with a Section column.

## Add variables

On **Variables**, `n` opens **New variable**:

- **Key** — shown in uppercase as you type. It must be unique in the whole environment.
- **Section** — only when adding from **All sections**; otherwise the section of the list.
- **Value** — masked when **Secret** is checked; `Ctrl-V` shows it while typing.
- **Comment** — written as `# …` right above the variable in the `.env` file.
- **Secret** — masks the value on every screen.

`Enter` on any field saves.

## Edit a variable

`Enter` or `e` on a variable opens its detail. Under the form, read-only, you see **Created** and **Modified** (when and by whom) and the history of the variable. When editing, the form also has a **State** field: enabled, disabled or commented. On the list, `s` cycles the state of the selected variable without opening it.

## Move a variable to another section

In the detail of a variable, the **Section** field shows its section followed by `Enter to change`. Press `Enter` on it to open the section picker, type to filter, and press `Enter` to choose. Save the form with `Enter` from any other field. The variable moves to the end of the chosen section, and the history records `section General → database`.

## Delete

`d` deletes the selected project, environment, section or variable after asking; the dialog says how many environments, sections and variables go with it. Deleting is recorded in the history, but the history keeps only the last 10 entries per entity and never a value, so it is not a way to recover a deleted value.
