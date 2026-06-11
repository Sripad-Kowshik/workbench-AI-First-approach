# Sample prompt for Claude Code

Use the CHF adaptation bundle to implement the hotfix workflow harness.

Your output should reflect the three-lane repo model, the orchestrator -> CHF -> diff -> pack flow, and the strict script/agent separation.

Rules:
- Treat the markdown docs as the source of truth.
- Treat `templates/` as implementation scaffolding.
- Keep deterministic logic in Python scripts.
- Keep decision-making in the agent files.
