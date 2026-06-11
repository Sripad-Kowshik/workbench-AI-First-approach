# `tenant_resolver.py` template

## Purpose

Resolve a tenant scope to one or more active branch/layout pairs.

## CLI surface

- `--scope <tenant>`
- `--explicit-branch <branch>`
- optional registry path via environment

## Behavioral rules

- validate explicit branch names when a registry exists
- return all active targets when no explicit branch is supplied
- never guess silently when the tenant cannot be resolved
- emit a structured error that the orchestrator can escalate

## Output contract

The success output should contain a `targets` array of branch/layout pairs.
