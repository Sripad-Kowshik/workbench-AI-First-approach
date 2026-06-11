# Orchestrator contract

## Role

The orchestrator is the top-level coordinator. It does not do git surgery itself. It translates a user request into one or more branch-targeted executions.

## Responsibilities

- parse tenant or release scope
- resolve base branch candidates
- decide whether one or multiple tenant targets exist
- spawn the CHF agent with a strict payload
- keep one target isolated from the next
- preserve loop ordering when multiple active tenant versions exist

## Input payload to CHF

```json
{
  "task_id": "string",
  "customer_scope": "string | null",
  "issue_id": "string",
  "base_branch": "string | null",
  "source_shas": ["string"]
}
```

## Orchestrator workflow

1. Determine the branch lane.
2. If a specific base branch is known, pass it directly.
3. If the branch is ambiguous, pass `null` only when the CHF agent is allowed to resolve it semantically.
4. If multiple active tenant branches exist, spawn one CHF run per branch.
5. Never combine multiple branch targets into one CHF context.

## Output expectations

The orchestrator should report:

- the selected target branches
- the payload handed to the CHF agent
- the names of the spawned sub-agents
- a final summary of generated packages

## Implementation note

The orchestrator should remain prompt-only for decision-making and use the deterministic scripts for all side effects.
