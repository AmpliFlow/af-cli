# af

`af` is the AmpliFlow CLI for terminals, scripts, and AI agents.

Use it to work with live AmpliFlow data from a shell, bind a repo checkout to an AmpliFlow project, run agent workflows with `af prime`, `af ready`, and `af loop`, and install shared agent guidance with `af setup`.

If you are new to AmpliFlow, start with [ampliflow.com](https://www.ampliflow.com). AmpliFlow is a platform for business governance that brings processes, goals, risks, projects, and documents into one platform. If you want the product page for this CLI specifically, see the [af-cli Labs page](https://www.ampliflow.com/labs/af-cli/).

## Who it is for

- AmpliFlow operators who want a faster terminal workflow
- Coding-agent operators who want agents to work from the same tasks and records as the rest of the team
- Teams piloting AI-assisted work inside AmpliFlow and needing a controlled way to connect agents to live business records

## What is AmpliFlow?

AmpliFlow is the product behind this CLI. The platform is built to help growing companies keep ownership, ways of working, goals, risks, projects, documents, and follow-up in one place instead of spreading governance across separate tools.

That matters because `af` is not a generic task CLI. It is a command surface on top of live AmpliFlow data and workflows.

## What you can do

`af` covers day-to-day AmpliFlow work:

- Projects and tasks: list projects, bind a checkout to a project, browse tasks, assign work, post comments, append Agent Log entries, and work with project files and discussions
- Management-system records: browse and update risks, improvements, goals, pages, controls, legislation, customer requirements, training plans, environmental aspects, processes, custom lists, checklists, news, and history
- Business records: work with suppliers, stakeholders, customers, and items
- Search and reporting: search across records, inspect priorities, read ready work, and add task-linked timesheet entries
- Agent setup and context: configure repo context, install shared agent guidance with `af setup`, and stamp AI git commits with `af git-identity -E`

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
- `af context project <project-ref>`: bind this repo checkout to an AmpliFlow project. This is what makes `af prime`, `af ready`, and `af loop` operate in the right place.
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
af config global harness <opencode|claude|pi>
af config global model <provider/model>
af config global timelog <true|false>
af config global ignore-tags "#deferred,#blocked,#manual"

af config global show
af config global unset harness
af config global unset model
af config global unset timelog
af config global unset ignore-tags
```

What these do:

- `af config global harness <opencode|claude|pi>`: pick the default coding harness for `af loop` on this machine.
- `af config global model <provider/model>`: pick the default loop model on this machine. Models must stay provider-qualified.
- `af config global timelog <true|false>`: decide whether `af loop` should append task-linked timesheet entries by default.
- `af config global ignore-tags "..."`: define which task tags should be excluded by default from `af ready`, `af priority`, and `af loop`.
- `af config global show`: print the current machine-wide defaults.
- `af config global unset ...`: remove one machine-wide default and fall back to lower-precedence config or built-in behavior.

### Repo-local defaults

Use `af config project` for defaults that should apply only in the current checkout.

```bash
af config project harness <opencode|claude|pi>
af config project model <provider/model>
af config project timelog <true|false>
af config project ignore-tags "#needs-human"

af config project show
af config project unset harness
af config project unset model
af config project unset timelog
af config project unset ignore-tags
```

What these do:

- `af config project harness ...`: override the loop harness only in this checkout.
- `af config project model ...`: override the loop model only in this checkout.
- `af config project timelog ...`: turn loop timelogging on or off only in this checkout.
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

Loop and ready behavior resolve in this order:

1. Explicit command flags
2. Repo-local project defaults in `.af/config`
3. Machine-wide global defaults
4. Built-in defaults

Built-in defaults:

- loop harness: `opencode`
- loop model: harness-specific
- loop timelog: `false`
- ready ignore-tags: `#deferred,#blocked`

The same ignore-tags setting is used by `af ready`, `af priority`, and `af loop`.

Explicit and configured loop models must be provider-qualified, for example `openai/gpt-5.5` or `openai-codex/gpt-5.4`.

### Non-interactive auth

`af` also supports env-backed auth for scripts and non-interactive use with `AF_BASE_URL` and `AF_TOKEN`.

In that mode, commands like `af auth status`, `af tenant active`, and `af config show` use the env-provided tenant context.

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

### Loop automation

`af loop` is an operator-supervised dispatcher for ready tasks. It requires a bound project, claims the first ready task, launches the selected coding harness, and keeps that claimed task active across retries until it is completed or blocked.

```bash
af context project <project-ref>
af loop

# Append task-linked timesheet entries for completed loop runs
af loop --timelog

# Restrict the queue to tasks with a specific tag
af project <project-ref> task <task-ref> tag add loop
af ready --tag loop
af loop --tag loop

# Override the configured harness or model for one run
af loop --harness opencode
af loop --harness claude
af loop --harness pi
af loop --model openai/gpt-5.5

# Run one queue pass, then exit
af loop --once

# Add local operator guidance for the next run
af loop steer "rerun the focused loop tests"

# Follow the operator log
af loop tail
af loop logs --lines 500
af loop logs --level warning
```

What these do:

- `af loop`: start the persistent task loop for the bound project.
- `af loop --timelog`: measure agent runtime per task and record it to task-linked timesheet entries when the run reaches a terminal state.
- `task ... tag add loop`: put one task into a tag-gated automation lane.
- `af ready --tag loop`: preview the exact tagged ready queue before starting automation.
- `af loop --tag loop`: run the loop only against tasks carrying that tag.
- `af loop --harness ...`: choose which coding harness should run tasks in this process.
- `af loop --model ...`: choose the provider-qualified model for this process.
- `af loop --once`: drain the current ready queue once, then exit.
- `af loop steer "..."`: write a local operator note that will be injected into the next matching loop prompt.
- `af loop tail`: follow the stable loop session log.
- `af loop logs --lines 500`: start the tail with a larger visible backlog.
- `af loop logs --level warning`: hide normal info chatter and show warnings and errors only.

If you are integrating a custom loop-driven agent flow, the spawned agent is expected to finish with one final outcome marker line such as:

- `AF_LOOP_OUTCOME: COMPLETE <reason>`
- `AF_LOOP_OUTCOME: CONTINUE <reason>`
- `AF_LOOP_OUTCOME: BLOCKED <reason>`
- `AF_LOOP_OUTCOME: REPLAN <reason>`

Agents inside a loop should not start nested loops.

More detail: [AF loop guide](https://github.com/AmpliFlow/af-cli-dev/blob/main/docs/AF-LOOP.md)

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

When the agent will commit code, set the AI git identity first:

```bash
eval "$(af git-identity -E)"
```

- `af git-identity -E`: print shell exports that make AI-authored commits easy to distinguish in git history.

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

- [AmpliFlow homepage](https://www.ampliflow.com)
- [af-cli Labs page](https://www.ampliflow.com/labs/af-cli/)
- [Releases](https://github.com/AmpliFlow/af-cli/releases)
- [Source repo and development docs](https://github.com/AmpliFlow/af-cli-dev)
- [AF loop guide](https://github.com/AmpliFlow/af-cli-dev/blob/main/docs/AF-LOOP.md)
- [MCP overview](https://github.com/AmpliFlow/af-cli-dev/blob/main/docs/MCP.md)
- [MCP integration guide](https://github.com/AmpliFlow/af-cli-dev/blob/main/docs/mcp-integration-guide.md)

## License

Copyright (c) 2026 Cognit Consulting AB, trading as AmpliFlow. All rights reserved. See [LICENSE](LICENSE) for terms.
