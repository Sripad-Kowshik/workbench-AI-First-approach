# `diff_analyzer.py` template

## Purpose

Compute the effective change set between a base branch and a hotfix branch.

## CLI surface

- `compare-artifacts --base <base> --target <target> --build-cmd <cmd> --artifact-dir <path>`

## Behavioral rules

- build base and target independently when artifact comparison is needed
- hash the produced artifact tree
- emit a diff manifest as JSON
- avoid packaging decisions
- avoid modifying the repository

## Output contract

The script should return a JSON object with:

- base branch
- target branch
- strategy used
- changed files
- summary of differences
- confidence / blockers
