# Orchestrator template

Use this as the blueprint for `agents/hotfix_orchestrator.exs`.

## Required shape

- derive `agent_root` from `__ENV__.file`
- define `system_prompt` as a named variable
- set `overlay_base_dir: nil`
- use `tools: ["run_command", "spawn_agent", "wait_for_all"]`
- use `context_strategy: :rolling` only if needed
- keep the prompt focused on branch resolution and agent orchestration

## Required workflow outline

1. resolve scope and branch candidates
2. construct the CHF payload
3. spawn one CHF agent per target branch
4. wait for each branch’s downstream chain to complete
5. summarize package locations

## Prompting rule

Do not inline command strings as prose. Use explicit `command:` and `args:` fields.

## Example run config fields

```elixir
%Aetheris.RunConfig{
  run_id: "hotfix-orch-#{Aetheris.ID.generate()}",
  label: "Hotfix Master Orchestrator",
  mode: :record,
  provider: "anthropic",
  model: "claude-3-5-sonnet-20241022",
  sandbox_path: agent_root,
  overlay_base_dir: nil,
  max_steps: 25,
  max_spawn_depth: 2,
  context_strategy: :rolling,
  max_context_steps: 6,
  tools: ["run_command", "spawn_agent", "wait_for_all"],
  system_prompt: system_prompt,
  user_prompt: "Start a consolidated hotfix for Airtel. Ticket ART-001, description fix-branding-typo. The fix is in commit a1b2c3d."
}
```
