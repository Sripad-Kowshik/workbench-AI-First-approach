# Hotfix Agent System

This repository contains a 3-agent system + orchestrator for creating consolidated hotfixes.

### Directory Structure

How the agents files should be placed in a typical project.

```
<project-root>/
├── .git/
├── ... (your source files)
│
├── .hotfix-agents/                  # ← Agent tooling (committed)
│   ├── AGENTS_hcf.md
│   ├── AGENTS_diff.md
│   ├── AGENTS_pack.md
│   ├── HOTFIX-ORCHESTRATOR.md       # ← Master entry point
│   └── CHF-STATE.md                 # ← Transient runtime state (ignored)
│
├── HOTFIX-HISTORY.md                # ← Permanent audit log (committed)
└── .gitignore
```

**Add to `.gitignore`:**
```gitignore
.hotfix-agents/CHF-STATE.md
```

---

## 1. Using with a Harness (Claude Code, Gemini CLI, Aider, Cursor, etc.)

**Action:**
- Feed **only** `HOTFIX-ORCHESTRATOR.md` to the harness as the initial prompt.
- Make the three agent files (`AGENTS_hcf.md`, `AGENTS_diff.md`, `AGENTS_pack.md`) available in the same project.

`HOTFIX-ORCHESTRATOR.md` will explicitly tell the harness when to load each agent file. This minimizes context bloat.

**Example prompts for harness:**

```
Initialize a hotfix run for Tata. Ticket: TAT-101. Description: dns-resolution-fix. The source branch to consolidate is hotfix/dhcp-scope-exhaustion.
```

```
Start consolidated hotfix for Vodafone. Ticket: VOD-142. Description: memory-leak-fix. Source branch: hotfix/duplicate-ip.
```

---

## 2. Using with a Chat Agent (Grok, Claude, GPT-4o, etc.) – for simulation

**Action:**
1. Upload **all four files** from the `.hotfix-agents/` folder at the start of the conversation.
2. Send the following prompt:

**Chat Prompt (copy-paste exactly):**

```
You are the Hotfix Agent Orchestrator.

I have uploaded HOTFIX-ORCHESTRATOR.md, AGENTS_hcf.md, AGENTS_diff.md and AGENTS_pack.md.

The original project goal is:

I have a repo with 3 branch-lanes:
- upstream(main) - current code
- release - tagged releases
- tenant - ones actually running in tenants.

Each tenant can be running multiple versions and may need hotfixes and patches. We had the first release on May 1 (v1.0.0) and since then many changes have been done.

The goal is to generate a hotfix for a tenant using the consolidated hotfix workflow.

To simulate this, generate yourself the project structure, read and understand HOTFIX-ORCHESTRATOR.md first and then follow the instructions/request below.

Here is the request:

Initialize a hotfix run for Tata. 
Ticket: TAT-101. 
Description: dns-resolution-fix. 
The source branch to consolidate is hotfix/dhcp-scope-exhaustion.
```

**Example prompts for chat (use after the setup above):**

```
Hotfix for Tata - TAT-101 - dns-resolution-fix using source branch hotfix/dhcp-scope-exhaustion
```

```
Start consolidated hotfix for Vodafone. Ticket: VOD-142. Description: memory-leak-fix. Source branch: hotfix/duplicate-ip.
```

```
Create hotfix for Airtel. Ticket: AIR-089. Description: dhcp-timeout-improvement. Source branch: hotfix/airtel/dhcp-timeout-fix.
```
