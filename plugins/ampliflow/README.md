# AmpliFlow for ChatGPT: pilot

Bring your management system into ChatGPT. AmpliFlow connects processes, goals, risks, projects, and documents with the people responsible for them. This package adds a project-follow-up skill to the registered AmpliFlow connection.

The first skill reviews incomplete tasks, assignees, and due dates without changing records. It does not restrict the connected server's permissions: other tools may allow writes. Review tool approvals and use an account with suitable access.

## Install and test

This pilot package references a registered app. It contains no credentials or server executable, does not install the CLI, and leaves local agent configuration unchanged.

For a workspace admin:

1. Make the registered AmpliFlow app available to the intended workspace roles. Confirm that a pilot user can connect and read the expected tenant's projects.
2. Open **Admin > Plugins > Add > Import marketplace**.
3. Set Source to `https://github.com/AmpliFlow/af-cli`. Leave Path empty. Select a reviewed commit in **Branch, tag, or commit** for a fixed pilot revision, or `main` to receive updates.
4. Import, inspect the report, and configure the plugin's workspace installation policy and required app access. Repository policy values do not set workspace permissions.
5. Have the pilot user install the package, complete authentication if prompted, and start a new chat on a supported surface. Verify that the bundled `reviewing-project-tasks` skill is available.
6. Ask: "Show incomplete tasks in [project name], including assignees and due dates. Do not change anything." Compare the answer with AmpliFlow.

For local desktop testing, run `codex plugin marketplace add AmpliFlow/af-cli`, restart the ChatGPT desktop app, and select **AmpliFlow pilot** in the Plugins Directory. The required app still needs to be accessible to that account.

A successful direct MCP connection does not prove this package installs correctly. Verify installation and skill discovery separately. OpenAI says local and repo marketplace availability varies by surface; this package's browser installation has not yet been verified.

## External customer pilots

The `.app.json` file references the app registered for this pilot. Importing the catalog does not grant access to that app, connect an AmpliFlow account, or share the publisher's tenant data.

If a customer workspace cannot access the referenced app, its admin must register `https://mcp.ampliflow.cc/mcp` and verify OAuth first. Prepare a customer-specific copy of the package in a separate controlled marketplace with that connection's **App Id**. Use the `asdk_app_...` value, rather than its Version Id or a `plugin_`-prefixed ID. Keep the shared pilot mapping unchanged. Never put credentials in these files.

OpenAI currently marks GitHub-imported plugins with bundled MCP configuration desktop-only, including remote HTTPS servers. This package uses `.app.json` instead; that choice alone is not proof of browser compatibility.

Pilot access is by arrangement with AmpliFlow. This package does not change the repository's license or grant additional redistribution rights. Confirm package-use terms before broad customer distribution.

## Description for the registered connection

The package manifest does not edit the personal connection you already created. Use **Edit description** on that connection to set:

> AmpliFlow brings processes, goals, risks, projects, and documents into one management system, connecting ownership, ways of working, and follow-up. Connect ChatGPT to your AmpliFlow account to find records, review what needs attention, and work with your management system through the tools available to your account. An AmpliFlow account is required. Available actions depend on your permissions and the connection settings; some tools can change live records.

This connection description covers the MCP server independently of the bundled skill.

## Maintenance

The source package lives in `af-cli-dev/packaging/chatgpt/`. The public repository contains a distribution copy. Change the source, bump `plugins/ampliflow/plugin.json`'s version, validate, then copy only `.agents/plugins/marketplace.json` and `plugins/ampliflow/` to the public repository. Publish the manifest and skill files together. The CLI installer and binary releases stay separate.

Workspace marketplaces sync daily by default. Review changes before publishing; new entries can be imported automatically. A pinned catalog revision does not pin the hosted MCP implementation. Public directory submission is a separate later step through OpenAI's **With MCP** submission flow.

## Sources

- [AmpliFlow](https://www.ampliflow.com/): product positioning.
- [Package your plugin](https://developers.openai.com/plugins/build/plugins): manifests and local marketplaces.
- [Plugin management](https://learn.chatgpt.com/docs/enterprise/plugin-management): GitHub import, app references, permissions, and desktop limits.
- [Submit plugins](https://developers.openai.com/plugins/deploy/submission): public submission.
