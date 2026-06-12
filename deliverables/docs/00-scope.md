# Scope and non-goals

## Problem statement

Build a low-trust consolidated hotfix harness for a three-lane repository model:

- `main` or upstream development
- `release/*` stable release branches
- `tenant/*` production tenant branches

A tenant may have multiple active versions. A single user request may need a cumulative hotfix that is replayable, auditable, and packageable.

## Design intent

This adaptation must preserve the following rules:

- scripts do the deterministic work
- agents choose the next action
- no agent invents file contents
- every important step is logged
- every ambiguity escalates
- every artifact is machine-readable

## Non-goals

Do not:

- merge all roles into one prompt
- allow unconstrained shell use
- skip validation gates
- let the diffing agent package anything
- let the packaging agent recompute diffs
- let the CHF agent guess at branch ancestry or test commands

## Output targets

Produce these implementation targets:

- `agents/hotfix_orchestrator.exs`
- `scripts/chf_git_ops.py`
- `scripts/diff_analyzer.py`
- `scripts/package_builder.py`
- `scripts/state_manager.py`
- `scripts/tenant_resolver.py`
- `scripts/test_runner.py`
