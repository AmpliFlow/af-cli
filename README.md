# af

`af` is the AmpliFlow CLI for terminals, scripts, and AI agents.

Use it to work with live AmpliFlow data from a shell, bind a repo checkout to an AmpliFlow project, run agent workflows with `af prime` and `af ready`, and install shared agent guidance with `af setup`.

If you are new to AmpliFlow, start with [ampliflow.com](https://www.ampliflow.com). AmpliFlow is a platform for business governance that brings processes, goals, risks, projects, and documents into one platform. If you want the product page for this CLI specifically, see the [af-cli Labs page](https://www.ampliflow.com/labs/af-cli/).

## Who it is for

- AmpliFlow operators who want a faster terminal workflow
- Coding-agent operators who want agents to work from the same tasks and records as the rest of the team
- Teams piloting AI-assisted work inside AmpliFlow and needing a controlled way to connect agents to live business records

## What is AmpliFlow?

AmpliFlow is the product behind this CLI. The platform is built to help growing companies keep ownership, ways of working, goals, risks, projects, documents, and follow-up in one place instead of spreading governance across separate tools.

`af` is not a generic task CLI. It works against live AmpliFlow data and workflows.

## What you can do

`af` covers day-to-day AmpliFlow work:

- Projects and tasks: list projects, bind a checkout to a project, browse tasks, assign work, post comments, append Agent Log entries, and work with project files and discussions
- Management-system records: browse and update risks, improvements, goals, pages, controls, legislation, customer requirements, training plans, environmental aspects, processes, custom lists, checklists, news, and history
- Business records: work with suppliers, stakeholders, customers, and items
- Search and reporting: search across records, inspect priorities, read ready work, and add task-linked timesheet entries
- Agent setup and context: configure repo context, install shared agent guidance with `af setup`, and attribute assisted commits with `af git-trailer`

> [!IMPORTANT]
> `af` uses your AmpliFlow permissions. Reads and writes are live. Start in a test tenant, use least privilege, and review AI-written content before you keep it.

## Install and update

Install the latest public CLI release:

```bash
curl -fsSL https://raw.githubusercontent.com/AmpliFlow/af-cli/main/scripts/install.sh | bash
af version
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
af update --force
```

`af update` verifies release checksums before replacing the binary. No-op update runs still refresh the embedded shared agent guidance files from the installed binary.

The public release installs the `af` CLI only. It does not install `af-mcp`.

## Quick start

Authenticate once per tenant, then bind the right identity and project in the repo where you work.

```bash
# Add an AmpliFlow tenant and authenticate
af auth login

# See available identities and projects
af auth list
af project list

# Bind identity and project for this repo+branch
af context auth <ref>
af context project <project-ref>

# Install shared af guidance before agent work
af setup local
af setup pi      # or: af setup claude / af setup opencode

# Show the current binding and load the workflow card
af context
af me
af prime
```

What each command does:

- `af auth login`: add a tenant identity to your local machine.
- `af auth list`: list stored identities and the ref numbers you use with `af context auth`.
- `af project list`: list projects visible to the active tenant identity.
- `af context auth <ref>`: choose which stored identity this repo+branch should use.
- `af context project <project-ref>`: bind this repo checkout to an AmpliFlow project. This is what makes `af prime` and `af ready` operate in the right place.
- `af setup local`: write the af guidance block into repo-local instruction files such as `AGENTS.md` or `CLAUDE.md`.
- `af setup pi`, `af setup claude`, or `af setup opencode`: install the shared af guidance into the agent you use. Skip this if you only use `af` by hand.
- `af context`: print the current repo+branch binding so you can check which identity and project are active.
- `af me`: show the current user record behind `--me` flows, including user UUID and tenant.
- `af prime`: print the short operator or agent workflow card for the bound project.

If a token expires, refresh it without re-entering tenant and email:

```bash
af auth reauth
#af auth reauth <ref>
```

- `af auth reauth`: refresh the active repo identity.
- `af auth reauth <ref>`: refresh a specific stored identity by ref.

If you need to switch the active tenant for this repo+branch:

```bash
af tenant switch <slug>
```

- `af tenant switch <slug>`: change the active tenant binding when you already know the tenant slug.

## Configuration

`af` has three main user configuration surfaces:

1. Repo+branch context
2. Machine-wide defaults
3. Repo-local defaults for the current checkout

For a full view of stored and known keys, run:

```bash
af config show
```

### Repo+branch context

Use `af context` to bind the current repo+branch to an identity and project.

```bash
af context
af context auth <ref>
af context project <project-ref>
af context demo-mode on
af context demo-mode off
```

What these do:

- `af context`: show the current repo+branch binding.
- `af context auth <ref>`: set which stored identity this checkout should use.
- `af context project <project-ref>`: bind this checkout to a project and write that binding into `.af/config`.
- `af context demo-mode on`: suppress the default `Generated by AI via af-cli...` footer for content created from this repo+branch. Use this only when you are working in a demo or sandbox tenant where that attribution would be misleading.
- `af context demo-mode off`: restore normal AI attribution behavior.

Use `af me` to verify the active user UUID and tenant behind `--me` flows.

### Machine-wide defaults

Use `af config global` for defaults that should apply on this machine across repos.

```bash
af config global ignore-tags "#deferred,#blocked,#manual"

af config global show
af config global unset ignore-tags
```

What these do:

- `af config global ignore-tags "..."`: define which task tags should be excluded by default from `af ready` and `af priority`.
- `af config global show`: print the current machine-wide defaults.
- `af config global unset ...`: remove one machine-wide default and fall back to lower-precedence config or built-in behavior.

### Repo-local defaults

Use `af config project` for defaults that should apply only in the current checkout.

```bash
af config project ignore-tags "#needs-human"

af config project show
af config project unset ignore-tags
```

What these do:

- `af config project ignore-tags ...`: override the default hidden tags only in this checkout.
- `af config project show`: print the repo-local defaults currently active in this checkout.
- `af config project unset ...`: remove one repo-local default and fall back to global or built-in behavior.

Project defaults live in `.af/config`. They are repo-local behavior and are not shared through Git.

### Advanced config

Use the low-level key-value commands only when you need direct control.

```bash
af config get <key>
af config set <key> <value>
af config delete <key>
```

What these do:

- `af config get <key>`: read one stored config value.
- `af config set <key> <value>`: write one raw config value directly.
- `af config delete <key>`: delete one raw config key.

The main advanced key users sometimes set manually is `agent.user-id`, usually to recover `--me` workflows when the tenant has more than one published user:

```bash
af who
af config set agent.user-id <uuid>
```

- `af who`: list users on the active tenant so you can find the right UUID.
- `af config set agent.user-id <uuid>`: tell `af` which tenant user record should count as `me`.

If exactly one published user exists on the active tenant, `af me`, `af ready --me`, and `assign --me` can recover that UUID automatically.

### Precedence and built-in defaults

Ready-work filters resolve in this order:

1. Explicit command flags
2. Repo-local project defaults in `.af/config`
3. Machine-wide global defaults
4. Built-in defaults

Built-in defaults:

- ready ignore-tags: `#deferred,#blocked`

The same ignore-tags setting is used by `af ready` and `af priority`.

### Non-interactive auth

Scripts use stored identities too. For an explicitly authorized unattended login, read the password from a regular, nonsymlink file with exact mode `0600`:

```bash
af auth login --tenant example.ampliflow.com --email operator@example.test --password-file /path/to/password
af auth list
af context auth <ref>
af context
```

Choose the identity ref from `af auth list`. `--password-stdin` is an alternative to `--password-file`; never pass a password as an argument. `AF_BASE_URL` and `AF_TOKEN` are not normal CLI authentication inputs.

## Common workflows

### Daily CLI workflow

```bash
# Show the current project and identity context
af context
af me

# See ready work
af ready
af priority

# See all open project tasks
af project <project-ref> task list

# Work a task
af project <project-ref> task <task-ref> assign --me
af project <project-ref> task <task-ref> update --log "Starting. Plan: reproduce, inspect, fix, test."
af project <project-ref> task <task-ref> complete
```

What these do:

- `af ready`: show incomplete tasks with no open blockers.
- `af priority`: show urgent and ready work in one view.
- `af project <project-ref> task list`: show the open task queue for one project.
- `assign --me`: claim the task for the current user.
- `update --log "..."`: append an Agent Log entry to the task description. This is the durable operational trail for agents.
- `complete`: mark the task complete in AmpliFlow.

### Agent setup

Use `af setup` to install the shared af workflow guidance into the agent you use:

```bash
af setup local
af setup claude
af setup opencode
af setup pi
```

What these do:

- `af setup local`: write the af guidance block into repo-local instruction files such as `AGENTS.md` or `CLAUDE.md`.
- `af setup claude`: install the shared af guidance and skills into `~/.claude/`.
- `af setup opencode`: install the shared af guidance and skills into `~/.config/opencode/`, plus the opencode plugin.
- `af setup pi`: install the shared af guidance and skills into `~/.pi/agent/`, plus the PI-native af context extension.

`af setup` output is idempotent and can be re-run safely.

Keep the configured human Git author and committer. Add the canonical af-cli co-author trailer when an agent helps with a commit:

```bash
git -c trailer.separators=: \
  -c trailer.af-cli.key=Co-authored-by \
  -c trailer.af-cli.ifexists=addIfDifferent \
  -c trailer.af-cli.ifmissing=add \
  -c 'trailer.af-cli.cmd=af git-trailer value' \
  commit --trailer af-cli -m "type(scope): description"
```

The command-scoped settings add exactly one canonical trailer without changing Git identity or persistent configuration.

### Search and help

```bash
af search "supplier risk"
af human
af --help
af config --help
af docs
af docs quirks
af docs --search pagination
af usage
```

What these do:

- `af search "..."`: search across tasks, risks, improvements, and goals.
- `af human`: print the short human-oriented reference card.
- `af --help`: print the full top-level command tree.
- `af config --help`: print help for one command family.
- `af docs`: list the embedded reference docs shipped inside the installed binary.
- `af docs quirks`: print one embedded doc.
- `af docs --search pagination`: search the embedded docs by keyword.
- `af usage`: show the most frequently used `af` command shapes from the local command log.

Use `af prime` when you want the short workflow card for the bound project. Use `af docs` when you want the embedded version-matched reference docs from the installed binary.

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
- Repo-local and machine-local defaults stay local, including ready-queue filters

## Responsible use

Use `af` like a live admin tool, not like a sandbox toy.

- Treat tenant content as live data. `af` can create, update, archive, and delete records on your behalf.
- Treat cloud-hosted models as external processors. If your agent runs on a third-party model, tenant content may be sent to that provider.
- Keep permissions narrow. Use a test tenant first, then grant only the access the workflow needs.
- Treat tenant content as untrusted input. Prompt injection can hide instructions inside tasks, comments, risks, or other records that an agent reads.
- Keep humans in the loop for high-impact actions such as bulk edits, formal compliance records, stakeholder-facing comments, or regulated workflows.

Agent-written AmpliFlow text is marked with an AI banner. Review it, rewrite it when needed, and remove the banner in the web UI only after a human owns the final text.

## Links

- [AmpliFlow homepage](https://www.ampliflow.com)
- [af-cli Labs page](https://www.ampliflow.com/labs/af-cli/)
- [Releases](https://github.com/AmpliFlow/af-cli/releases)
- [Source repo and development docs](https://github.com/AmpliFlow/af-cli-dev)
- [MCP overview](https://github.com/AmpliFlow/af-cli-dev/blob/main/docs/MCP.md)
- [MCP integration guide](https://github.com/AmpliFlow/af-cli-dev/blob/main/docs/mcp-integration-guide.md)

## License

Copyright (c) 2026 Cognit Consulting AB, trading as AmpliFlow. All rights reserved. See [LICENSE](LICENSE) for terms.
