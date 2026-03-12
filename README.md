# af

A CLI for AmpliFlow. Built for LLM agents. Works for humans too.

## Install

Download the binary for your platform from [Releases](https://github.com/AmpliFlow/af/releases/latest).

**Linux (amd64):**
```bash
curl -L https://github.com/AmpliFlow/af/releases/latest/download/af-linux-amd64 -o /usr/local/bin/af
chmod +x /usr/local/bin/af
```

**macOS (Apple Silicon):**
```bash
curl -L https://github.com/AmpliFlow/af/releases/latest/download/af-darwin-arm64 -o /usr/local/bin/af
chmod +x /usr/local/bin/af
```

**macOS (Intel):**
```bash
curl -L https://github.com/AmpliFlow/af/releases/latest/download/af-darwin-amd64 -o /usr/local/bin/af
chmod +x /usr/local/bin/af
```

## Quick Start

```bash
# Authenticate (run once per tenant)
af auth login

# See your projects
af project list

# Get workflow context (agents: run this first)
af prime
```

## What it does

`af` wraps the AmpliFlow REST API and makes every feature accessible from a terminal. The primary user is an LLM agent. The secondary user is a human who prefers terminals over web UIs.

AmpliFlow has distinct modules: Projects, Risks, Improvements, Goals, Legislation, Suppliers, Checklists, Stakeholders, Process Charts, Pages, Custom Lists. Each gets its own top-level command.

```bash
af project list
af risk list
af improvement list
af goal list
af search "GDPR data processing"
```

For humans browsing interactively:
```bash
af human
```

## For Agents

```bash
# Get workflow context
af prime

# Find ready tasks
af ready

# Claim and work a task
af project 3 task 12 assign --me
af project 3 task 12 comment "WIP: investigating the bug"
af project 3 task 12 complete
```

`af` ships with a skill file for Claude and OpenCode agents. After install:
```bash
af setup claude     # installs skill to ~/.claude/skills/af-cli/
af setup opencode   # installs skill to ~/.config/opencode/skills/af-cli/
```

## Design

- **Refs, not UUIDs.** Every entity maps to a short integer. `af project 3 task 12` instead of 36-character UUIDs.
- **AI-generated content marked by default.** Every write includes `> AI-generated on behalf of <email>` unless you pass `--human`. The EU AI Act requires transparency; the tool enforces it.
- **Tenant switching requires a human.** `af tenant switch` always prompts interactively. An agent cannot switch tenants.
- **Local SQLite for cache only.** AmpliFlow is the source of truth. Local state is a cache, never authoritative.

## License

Copyright (c) 2026 AmpliFlow AB. All rights reserved. See [LICENSE](LICENSE) for terms.
