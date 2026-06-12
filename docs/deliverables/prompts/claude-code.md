# Claude Code prompt

Read these documents in order before doing anything else:

1. agent-creation-guide.md
2. harness-capabilities-appendix.md
3. canonical-artifact-schemas.md
4. CHF instruction pack documents
5. existing templates and agent files, if any

Treat the first three as the governing contract. If any later document conflicts with them, ignore the later document and follow the higher-priority source.

Then produce the CHF implementation:

- Elixir orchestrator
- CHF, diff, and pack agent files
- deterministic Python helper scripts
- supporting docs needed for the workflow

Use the rule that scripts do the deterministic work and agents decide the next action.
Do not invent file contents programmatically in the LLM.
Do not expand the tool surface beyond the harness contract.
Do not invent artifact schemas; use the canonical schemas as written.
If a required input is missing or ambiguous, escalate rather than guess.
