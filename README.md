# af

`af` is the AmpliFlow CLI for terminals, scripts, and AI agents.

Use it to work with live AmpliFlow data from a shell, bind a repo checkout to a project, and run agent workflows with `af prime`, `af ready`, and `af loop`.

## Who it is for

- AmpliFlow operators who want a faster terminal workflow
- Coding-agent operators who want agents to work from the same tasks and records as the rest of the team
- Admin and security reviewers who need to understand the auth, write, and data-handling model before rollout

## What you can do

`af` covers day-to-day AmpliFlow work:

- Projects and tasks: list projects, bind a checkout to a project, browse tasks, assign work, post comments, append Agent Log entries, and work with project files and discussions
- Management-system records: browse and update risks, improvements, goals, pages, controls, legislation, customer requirements, training plans, environmental aspects, processes, custom lists, checklists, news, and history
- Business records: work suppliers, stakeholders, customers, and items
- Search and reporting: search across records, inspect priorities, read ready work, and add task-linked timesheet entries
- Agent setup and context: configure repo context, install shared agent guidance with `af setup`, and stamp AI git commits with `af git-identity -E`

> [!IMPORTANT]
> `af` uses your AmpliFlow permissions. Reads and writes are live. Start in a test tenant, use least privilege, and review AI-written content before you keep it.

## Install and update

Install the latest public CLI release:

```bash
curl -fsSL https://raw.githubusercontent.com/AmpliFlow/af-cli/main/scripts/install.sh | bash
```

The installer detects your platform, downloads the `af` binary from `AmpliFlow/af-cli` releases, verifies `checksums.txt`, and installs to `~/.local/bin/af` by default.

Install somewhere else:

```bash
AF_BIN_DIR=/usr/local/bin curl -fsSL https://raw.githubusercontent.com/AmpliFlow/af-cli/main/scripts/install.sh | bash
```

Install a specific version:

```bash
AF_VERSION=v1.23.50 curl -fsSL https://raw.githubusercontent.com/AmpliFlow/af-cli/main/scripts/install.sh | bash
```

You can also download release assets directly from [GitHub Releases](https://github.com/AmpliFlow/af-cli/releases).

Update later:

```bash
af update
```

The public release installs the `af` CLI only. It does not install `af-mcp`.

## Quick start for humans

Authenticate once per tenant, then bind the project you want to work in.

```bash
af auth login
af project list
af context project <project-ref>
af prime
af human
```

A simple read-first workflow looks like this:

```bash
af context
af ready
af priority
af project <project-ref> task list
af risk list
af search "supplier risk"
```

## Quick start for agents

Install the shared af guidance into the agent you use:

```bash
af setup claude
# or
af setup opencode
# or
af setup pi
```

Then start work from a repo checkout that is bound to an AmpliFlow project:

```bash
af prime
af ready
af project <project-ref> task <task-ref> assign --me
af project <project-ref> task <task-ref> update --log "Starting. Plan: reproduce, inspect, fix, test."
af project <project-ref> task <task-ref> complete
```

When the agent will commit code, set the AI git identity first:

```bash
eval "$(af git-identity -E)"
```

## Running task loops

`af loop` is an operator-supervised dispatcher for ready tasks. A human starts it from a project checkout. The loop claims work, starts the selected coding harness, checks that the task was actually completed, records retry context, and moves on.

```bash
af context project <project-ref>
af loop
```

Use a tag-gated queue when you want a bounded automation lane:

```bash
af project <project-ref> task <task-ref> tag add loop
af ready --tag loop
af loop --tag loop
```

Pick a harness or model for one run:

```bash
af loop --harness opencode
af loop --harness claude
af loop --harness pi
af loop --model openai/gpt-5.5
```

Follow the operator log:

```bash
af loop tail
af loop logs --lines 500
af loop logs --level warning
```

Use goal mode when one claimed task should stay in focus across repeated attempts until it is complete or blocked:

```bash
af loop --goal --tag loop
```

Agents inside a loop should not start nested loops.

More detail: [AF-LOOP.md](https://github.com/AmpliFlow/af-cli-dev/blob/main/docs/AF-LOOP.md)

## MCP and the ChatGPT connector

AmpliFlow also has an MCP server at `https://mcp.ampliflow.cc/mcp`.

What is true today:

- The hosted endpoint uses OAuth 2.1. Access stays within the signed-in AmpliFlow account's existing permissions.
- The live tool surface depends on the enabled toolsets. In readonly mode, read tools stay available and write tools are hidden.
- Shared fixed-token auth is not the public default. It is an explicit opt-in for pinned deployments.
- The current public ChatGPT launch is connector-only. There is no repo-managed custom widget bundle.
- The public installer in this repo does not install `af-mcp`.

If you need the hosted MCP connection details, use the [integration guide](https://github.com/AmpliFlow/af-cli-dev/blob/main/docs/mcp-integration-guide.md). If you need source-level MCP work or self-hosted server changes, use the [source repo](https://github.com/AmpliFlow/af-cli-dev).

## Design principles

A few choices shape the tool:

- Short refs instead of UUIDs, so humans and agents can work with `af project 3 task 12`
- AmpliFlow is the source of truth, while local SQLite stores cache, auth context, refs, and local task state
- AI-written content is marked by default so draft machine output stays visible
- Repo-local and machine-local defaults stay local, especially loop settings and ready-queue filters

## Responsible use

Use `af` like a live admin tool, not like a sandbox toy.

- Treat tenant content as live data. `af` can create, update, archive, and delete records on your behalf.
- Treat cloud-hosted models as external processors. If your agent runs on a third-party model, tenant content may be sent to that provider.
- Keep permissions narrow. Use a test tenant first, then grant only the access the workflow needs.
- Treat tenant content as untrusted input. Prompt injection can hide instructions inside tasks, comments, risks, or other records that an agent reads.
- Keep humans in the loop for high-impact actions such as bulk edits, formal compliance records, stakeholder-facing comments, or regulated workflows.

Agent-written AmpliFlow text is marked with an AI banner. Review it, rewrite it when needed, and remove the banner in the web UI only after a human owns the final text.

## Links

- [Releases](https://github.com/AmpliFlow/af-cli/releases)
- [Source repo and development docs](https://github.com/AmpliFlow/af-cli-dev)
- [AF loop guide](https://github.com/AmpliFlow/af-cli-dev/blob/main/docs/AF-LOOP.md)
- [MCP overview](https://github.com/AmpliFlow/af-cli-dev/blob/main/docs/MCP.md)
- [MCP integration guide](https://github.com/AmpliFlow/af-cli-dev/blob/main/docs/mcp-integration-guide.md)

## License

Copyright (c) 2026 Cognit Consulting AB, trading as AmpliFlow. All rights reserved. See [LICENSE](LICENSE) for terms.
