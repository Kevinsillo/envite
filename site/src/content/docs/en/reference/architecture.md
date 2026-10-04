---
title: Architecture
description: How envite is structured inside — hexagonal layers, the dependency rule, and the worker thread behind the interface.
sidebar:
  order: 36
---

Envite is a single Rust binary built with a strict hexagonal architecture: the rules of the application know nothing about files, SSH, SQLite or the terminal. This page gives an overview; it is not needed to use envite.

## Layers

```text
┌──────────────────────────────────────────────┐
│ Composition root   wires everything together │
├──────────────────────┬───────────────────────┤
│ TUI                  │ Infrastructure        │
│ screens, keys,       │ vault container,      │
│ worker thread        │ crypto, SQLite, SSH,  │
│                      │ files, config         │
├──────────────────────┴───────────────────────┤
│ Application   ports (interfaces), use cases  │
├──────────────────────────────────────────────┤
│ Domain        entities, rules, merge, .env   │
└──────────────────────────────────────────────┘
```

| Layer | Holds | Depends on |
|---|---|---|
| **Domain** | Projects, environments, sections, variables, members and history; validation rules; the three-way merge; rendering and parsing of `.env` files. Pure code, no I/O. | Nothing |
| **Application** | Ports — the interfaces to the outside world (vault codec, file store, remote shell, clock, configuration, releases…) — and the use cases: create, open, save, merge, lock, deploy, import, resolve conflicts, manage members, update. | Domain |
| **Infrastructure** | Adapters implementing the ports: the `.envite` container and its cryptography, the in-memory SQLite database, local and SSH file stores, the system `ssh` client, the JSON configuration, the release download with the system `curl` and the replacement of the binary. | Application, domain |
| **TUI** | Screens, key map, event loop and the worker thread. | Application, domain — never infrastructure |
| **Composition root** | Parses the command line, reads the environment, sets up logging, builds the real adapters and starts the interface or the update. | Everything |

Dependencies always point inward. The interface never touches an adapter directly, and no type of a storage or terminal library leaks out of its layer. Each layer has its own error type; errors cross layers already translated, and none of them carries a secret.

## Main thread and worker

The interface runs on the main thread and only draws screens and reads keys. A **worker thread** owns the configuration and the vault — open, locked or waiting for an SSH authentication. The interface sends it commands and queries; the worker answers each one and publishes a read-only snapshot after every change. Snapshots never hold a password, a key or a value.

Slow work — key derivation, SSH, saving — therefore never freezes the interface, and the background work of the open vault (automatic saves and checks for changes) runs on the worker's tick.

Secret values travel to the interface only when you ask to see one, as a secret-text type whose debug output prints `[REDACTED]`. Deploy and import plans are kept in the worker between the preview and the confirmation; the interface only receives their masked preview.

## Synchronous by design

Envite has no async runtime. Everything is synchronous; slow work runs on threads with channels. Remote operations go through the system `ssh` binary with a shared master connection per host.

## Testing

The domain and application layers are tested with in-memory fakes of every port, without disk or network. Property-based tests cover the vault format round trip, `.env` rendering and parsing, and the convergence of the three-way merge. The user flows are tested end to end with real keys on a test terminal, checking every frame to make sure no password ever shows and that a secret value shows only while it is revealed.
