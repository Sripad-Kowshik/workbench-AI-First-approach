# Codex prompt

First, read `agent-creation-guide.md` carefully and treat it as the authoritative source for repository structure, agent conventions, tool design, and orchestration patterns.

After reading it, design and create the required agent files, deterministic helper scripts, and supporting markdown docs for the CHF workflow. Follow the guide’s core rule: scripts do the deterministic work, agents decide. Do not ask the model to programmatically invent file contents that should instead be produced by scripts. Use the guide to determine:

* the directory layout
* the orchestrator/sub-agent split
* the minimal tool surface for each agent
* the required handoff and artifact structure
* the test and audit expectations

Build the CHF-specific implementation so it is self-consistent, deterministic, and suitable for sandboxed execution. The resulting files should be ready for a coding agent to implement directly.
