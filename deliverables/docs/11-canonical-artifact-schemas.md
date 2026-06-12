# Canonical artifact schemas

## Normative rules

- JSON only
- one artifact per file
- `schema_version` is `major.minor`
- `state_manager.py` validates every artifact at the orchestrator boundary
- every artifact is machine-readable and auditable

## Common envelope

Every artifact includes:
- `schema_version`
- `artifact_type`
- `task_id`
- `issue_id`
- `created_at`
- `created_by`
- `workspace`
- `base_branch`
- `hotfix_branch`
- `base_sha`
- `hotfix_sha`
- `source_shas`
- `confidence`
- `blockers`
- `validation`

## Family-specific schemas

The full JSON Schema documents live in `schemas/*.schema.json`. Those files are normative and should be treated as the machine-readable source of truth.

This markdown file summarizes the families and the intent of each schema.

### 1. diff_request

Emitted by CHF-execute. Authorizes the diff phase.

Required fields in addition to the common envelope:
- `test_gate`
- `applied_commits`
- `exclude_globs`
- `notes`

Rules:
- `test_gate.exit_code` must be `0`
- `applied_commits` must record source SHA, applied SHA, method, and conflict status
- `exclude_globs` is optional but when present constrains packaging exclusions
- `notes` may be null

### 2. diff_manifest

Emitted by the diff agent. This is the sole input to the pack agent.

Required fields in addition to the common envelope:
- `strategy`
- `strategy_rationale`
- `evidence_commands`
- `files`
- `generated_files`
- `excluded_files`
- `source_shas_confirmed`

Rules:
- `strategy` must be one of `linear`, `range_diff`, `patch_id`, or `tree_diff`
- each file entry must have a change kind and blob hashes where applicable
- moved files require `from_path`
- `source_shas_confirmed` must be `true` for a passing artifact

### 3. packaging_request

Emitted by the orchestrator. Authorizes packaging from one validated diff manifest.

Required fields:
- `diff_manifest_ref`
- `diff_manifest_sha256`
- `target`
- `package_format`
- `destination_root`

Rules:
- the pack agent must refuse any request whose manifest checksum does not match
- the target object must identify tenant, version, and platform

### 4. packaging_manifest

Emitted by the pack agent.

Required fields:
- `packaging_request_ref`
- `bundle`
- `contents`
- `install_script`
- `rollback_script`
- `rollback_manifest_ref`
- `checksums_file`
- `verification`

Rules:
- `contents` must correspond 1:1 to the diff manifest files, excluding generated files
- every content entry must specify archive path, destination path, sha256, mode, and action
- `verification.result` must be `pass`

### 5. rollback_manifest

Emitted by the pack agent.

Required fields:
- `packaging_manifest_ref`
- `preserve`
- `backup_strategy`
- `notes`

Rules:
- each preserve entry must describe destination path, expected pre-image hash, and restore action
- if a file has drifted, rollback must fail closed and escalate

### 6. evaluator_report

Emitted by validator or evaluation tooling.

Required fields:
- `subject_ref`
- `checks`
- `overall`

Rules:
- `overall` is `pass` only if every check passes
- a failure should create or update blockers on the subject artifact

### 7. propagation_plan

Emitted by the orchestrator in the final phase.

Required fields:
- `completed_target`
- `remaining_targets`
- `ordering_rationale`

Rules:
- remaining targets are ordered
- each target entry carries status and optional note
- updated in place as follow-up tasks are spawned

### 8. escalation_request

Emitted by any agent through `state_manager.py escalate`.

Required fields:
- `phase`
- `trigger`
- `summary`
- `evidence`
- `options`
- `response`

Rules:
- 2 to 5 options
- exactly one recommended option
- no free-form do-it-anyway option
- response is filled by the human or resume path

## Validator summary

`state_manager.py validate` should:
- parse JSON
- reject malformed input
- validate envelope fields
- validate family-specific required fields
- enforce enum membership and SHA format
- confirm blocker rules
- stamp validation metadata in place
