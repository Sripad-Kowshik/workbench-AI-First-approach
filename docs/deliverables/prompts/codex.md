# Sample prompt for Codex

Use the CHF adaptation bundle in this directory to generate the hotfix orchestration harness.

Read the docs in order, then produce the Elixir orchestrator and the deterministic Python scripts described in `templates/`.

Requirements:
- Keep orchestration logic in the Elixir agent.
- Keep all file creation, git operations, diffing, packaging, state logging, tenant validation, and test execution in scripts.
- Preserve the branch-lane model, structured handoffs, escalation gates, and audit trail.
- Output the adapted files into the target repository structure described in `docs/01-repo-layout.md`.
