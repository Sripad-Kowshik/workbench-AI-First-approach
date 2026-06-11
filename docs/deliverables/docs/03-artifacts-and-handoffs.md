# Artifacts and handoff envelopes

## Core principle

Agents must pass structured artifacts between phases. Prose alone is not enough for continuation.

## Required artifact families

- `diff_request`
- `diff_manifest`
- `packaging_request`
- `packaging_manifest`
- `rollback_manifest`
- `evaluator_report`
- `propagation_plan`

## Required envelope fields

At minimum, each envelope should carry:

- `schema_version`
- `artifact_type`
- `task_id`
- branch or release identifiers
- source SHAs when relevant
- blockers
- confidence

## Handoff order

1. Orchestrator resolves scope and base branches.
2. CHF agent creates the hotfix branch and cherry-picks commits.
3. CHF agent emits a diff request.
4. Diff agent emits a diff manifest.
5. Pack agent consumes the manifest and emits packaging artifacts.
6. CHF agent finalizes review and tagging steps.

## Escalation discipline

Any missing or contradictory field must halt the workflow and produce a structured escalation request with lettered options.
