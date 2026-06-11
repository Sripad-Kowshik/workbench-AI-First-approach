# `chf_git_ops.py` template

## Purpose

A constrained git wrapper for:

- branch creation
- commit inspection
- cherry-picking

## CLI surface

- `inspect --sha <sha>`
- `branch --base <branch> --name <new_branch>`
- `cherry-pick --sha <sha>`

## Behavioral rules

- log each step to `CHF-STATE.md`
- do not expose arbitrary git command execution
- abort and emit structured JSON on cherry-pick conflict
- do not perform file surgery
- do not push or tag

## Output contract

Each command should print JSON that includes a status and the relevant details for the orchestrator or CHF agent.
