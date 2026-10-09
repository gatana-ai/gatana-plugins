# Gatana plugins

The Gatana plugin for Claude, Claude Code, ChatGPT and Codex. It gives the agent two things:

- The skills of your organization in Gatana. The agent checks them at the start of a task and follows the skill that applies.
- The tools of your organization's Gatana gateway: the MCP servers that your organization connected to Gatana.

You need a Gatana account. When you connect the plugin, you choose your organization and sign in. You see only the skills and tools that you have access to. No account yet? [Sign up](https://hello.gatana.ai/signup).

## Install

### Claude Code

```
/plugin marketplace add gatana-ai/plugins
/plugin install gatana@gatana
```

Then run `/mcp`, select `plugin:gatana:gatana`, and sign in.

### Claude (claude.ai, the desktop app, Cowork)

1. Go to **Customize > Plugins** and select **Add > Add marketplace**.
2. Enter `gatana-ai/plugins`.
3. Install **Gatana**. Open the plugin, connect Gatana on the **Connectors** tab, and sign in.

### Codex

```bash
codex plugin marketplace add gatana-ai/plugins
codex plugin add gatana@gatana
```

Then sign in to the `gatana` MCP server when Codex asks.

## For organizations

An admin can also download a plugin made for one organization, on the **Install Gatana** page of the Gatana dashboard, and publish it to the Claude organization or the ChatGPT workspace. That plugin connects to the organization's own address, so members do not choose the organization.

## Contents

| Folder            | Format               | Read by                     |
| ----------------- | -------------------- | --------------------------- |
| `plugins/claude`  | Claude plugin        | Claude, Cowork, Claude Code |
| `plugins/chatgpt` | OpenAI Agent Plugins | ChatGPT, Codex              |

`.claude-plugin/marketplace.json` and `.agents/plugins/marketplace.json` are the marketplace files that Claude and Codex read.

Gatana generates the files in this repository from its app. Do not edit them here: the next release replaces them.

More information: [docs.gatana.ai/skills](https://docs.gatana.ai/skills/)
