# CHF Agent Adaptation Bundle v3

This bundle is the instruction pack for a coding agent such as Codex to generate the Elixir `.exs` agents and the deterministic Python scripts for the CHF workflow.

Use in this order:
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
11. `docs/10-harness-capabilities-appendix.md`
12. `docs/11-canonical-artifact-schemas.md`
13. `schemas/*.schema.json`
14. `prompts/codex.md`
15. `templates/*.exs`

Design decisions baked into this bundle:
- orchestrator-mediated phases, not CHF-owned spawning
- deterministic scripts own all filesystem and git side effects
- machine-readable artifacts at every handoff
- explicit escalation artifacts instead of free-form prose
- one target base branch per CHF execution context
- canonical JSON Schema files for every artifact family
