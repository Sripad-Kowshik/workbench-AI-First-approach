# Codex prompt

First, read these files in this exact order and treat them as authoritative, in descending order of priority:

1. agent-creation-guide.md
2. harness-capabilities-appendix.md
3. canonical-artifact-schemas.md
4. the CHF instruction pack documents
5. the existing agent templates, if present

Do not start designing or writing any agent files until you have read the first three documents completely.

After reading them, design and create the required CHF implementation files:

- the Elixir orchestrator
- the CHF, diff, and pack agent templates
- the deterministic helper scripts
- any supporting markdown docs needed for the workflow

Follow these non-negotiable rules:

- scripts do the deterministic work; agents decide
- do not ask the LLM to invent file contents programmatically
- do not widen the tool surface beyond what the harness appendix allows
- do not invent new artifact shapes; use the canonical schemas exactly
- do not collapse orchestration, diffing, packaging, and validation into one agent
- treat ambiguity as a reason to escalate, not to guess

When there is any conflict between the instruction pack and the higher-order documents, the higher-order documents win.

Build the CHF-specific implementation so it is self-consistent, deterministic, auditable, and suitable for sandboxed execution.
Return the generated files only after the design is complete.
