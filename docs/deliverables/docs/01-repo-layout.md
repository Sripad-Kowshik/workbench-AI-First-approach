# Repository layout to implement

## Canonical placement

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
│   ├── hotfix-runbook.md
│   └── hotfix-history.md
├── output/
└── .gitignore
```

## Runtime state

Keep transient state in the workspace, not in the prompt:

- `CHF-STATE.md` is the run log
- `output/` is the artifact sink
- `STEER.md` is an optional human override file

## Branch model to support

- `main` is future development
- `release/*` is generic sustaining
- `tenant/*` is tenant-specific sustaining
- `chf/*` is temporary cumulative hotfix work

## Placement rule for generated files

The agents should never write outside the repo root except for explicitly sanctioned temp paths created by the deterministic scripts.
