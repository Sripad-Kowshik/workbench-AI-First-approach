# Gemini CLI prompt

Before any implementation work, read and internalize these files in this order:

1. agent-creation-guide.md
2. harness-capabilities-appendix.md
3. canonical-artifact-schemas.md
4. CHF instruction pack docs
5. existing agent templates

Use the first three as the source of truth for architecture, tool boundaries, and artifact structure.

Then generate the CHF workflow implementation:

- orchestrator
- CHF agent template
- diff agent template
- pack agent template
- deterministic helper scripts
- supporting markdown documentation

Hard rules:

- deterministic logic belongs in scripts
- the model only decides what to invoke next
- do not ask the model to fabricate file content
- do not invent schemas or handoff shapes
- do not exceed the documented tool surface
- escalation is preferred over guessing
