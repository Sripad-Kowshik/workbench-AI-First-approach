# Aider prompt

Read the following before making changes:

1. agent-creation-guide.md
2. harness-capabilities-appendix.md
3. canonical-artifact-schemas.md
4. CHF instruction pack docs
5. existing templates

Use those documents as the authoritative spec.

Then create or update the CHF implementation files:

- orchestrator
- CHF agent template
- diff agent template
- pack agent template
- helper scripts
- supporting documentation

Constraints:

- deterministic logic must live in scripts
- agents only decide and orchestrate
- do not invent artifact formats
- do not expand the tool surface
- do not guess when the spec is ambiguous

If anything is unclear, stop and escalate rather than improvising.
