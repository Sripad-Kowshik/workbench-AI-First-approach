# Acceptance criteria

A coding agent implementation is acceptable when all of the following are true:

- the orchestrator reads as a clean Elixir RunConfig-based entry point
- the CHF agent has exactly one target branch per run
- the diff agent is analysis-only
- the pack agent is transformation-only
- each Python script has a small deterministic CLI
- every script emits JSON or writes a clearly defined artifact
- the tool surface stays narrow and explicit
- the workflow is auditable and replayable

## Quality gates

- no script depends on unconstrained shell behavior
- no LLM is asked to generate file content programmatically
- no step silently swallows ambiguity
- every ambiguity has a structured escalation path

## Final deliverable shape

The resulting repo should be easy for a junior engineer to understand and a sandboxed agent to execute deterministically.
