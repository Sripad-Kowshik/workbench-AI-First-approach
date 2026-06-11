# Deterministic tool surface

This adaptation depends on a narrow, auditable tool set.

## Orchestrator tools

The orchestrator may use:

- `run_command`
- `spawn_agent`
- `wait_for_all`

It should not need broad file-writing primitives.

## CHF agent tools

The CHF agent may use:

- `run_command`
- `read_file`

It should rely on `run_command` for all git and state-manager actions.

## Diff agent tools

The diff agent may use:

- `run_command`
- `read_file`

It may inspect the repository, compute effective change sets, and emit a diff manifest, but it must not package.

## Pack agent tools

The pack agent may use:

- `run_command`

It consumes only validated manifests and produces packaging artifacts.

## Deterministic scripts to implement

- `scripts/chf_git_ops.py`
- `scripts/diff_analyzer.py`
- `scripts/package_builder.py`
- `scripts/state_manager.py`
- `scripts/tenant_resolver.py`
- `scripts/test_runner.py`

These scripts are the deterministic boundary. The agents should only decide when and how to invoke them.
