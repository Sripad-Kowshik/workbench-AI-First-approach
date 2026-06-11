# CHF Agent Adaptation Bundle

This bundle breaks the consolidated hotfix workflow into separate instruction files so coding agents can implement the Elixir orchestrator and the deterministic Python tooling without mixing concerns.

## What this bundle is for

Use these documents to generate a clean harness for:

- a top-level hotfix orchestrator
- a CHF execution agent
- a diffing agent
- a packaging agent
- deterministic helper scripts for git, diffing, packaging, state tracking, tenant resolution, and test execution

## What this bundle is not

- It is not a copy of the legacy agent markdowns.
- It does not ask an LLM to fabricate file content dynamically.
- It does not collapse orchestration, diffing, and packaging into one prompt.

## Recommended reading order

1. `docs/00-scope.md`
2. `docs/01-repo-layout.md`
3. `docs/02-tool-surface.md`
4. `docs/03-artifacts-and-handoffs.md`
5. `docs/04-orchestrator-contract.md`
6. `docs/05-chf-agent-contract.md`
7. `docs/06-diff-agent-contract.md`
8. `docs/07-pack-agent-contract.md`
9. `docs/08-state-and-audit.md`
10. `docs/09-acceptance.md`
11. `prompts/codex.md`
12. `prompts/gemini-cli.md`
13. `prompts/claude-code.md`

Then generate the template targets in `templates/`. Sample prompts live in `prompts/` as starting points only.

## Target repo placement

The generated implementation should land under a repo structure like:

```text
<project-root>/
├── agents/
│   └── hotfix_orchestrator.exs
├── scripts/
│   ├── chf_git_ops.py
│   ├── diff_analyzer.py
│   ├── package_builder.py
│   ├── state_manager.py
│   ├── tenant_resolver.py
│   └── test_runner.py
├── docs/
│   └── ...
└── output/
```

## Enforcement idea

The agents should be allowed to decide, but only with a deterministic tool surface. All file creation, git operations, hashing, manifest emission, and packaging should be delegated to scripts.
