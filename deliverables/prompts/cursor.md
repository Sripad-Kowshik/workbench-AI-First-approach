# Cursor prompt

Read these documents first, in this exact order:

1. agent-creation-guide.md
2. harness-capabilities-appendix.md
3. canonical-artifact-schemas.md
4. CHF instruction pack
5. existing templates and source files

Treat the first three as binding design contracts.

Then implement the CHF system as a set of files:

- Elixir orchestrator
- CHF agent
- diff agent
- pack agent
- deterministic Python scripts
- any required support docs

Follow these principles:

- scripts perform deterministic work
- agents choose the next action
- never invent file contents in the prompt
- use the canonical schemas exactly
- keep the tool surface narrow
- escalate on ambiguity instead of guessing

Produce code and docs that are deterministic, auditable, and safe for sandboxed execution.
