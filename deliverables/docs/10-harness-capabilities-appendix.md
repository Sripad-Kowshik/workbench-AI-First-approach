# Harness capabilities appendix

## Execution model

An agent is a single LLM loop defined by one Elixir struct in a `.exs` file.

Key consequences:

- a plain text response ends the run
- every step is durably logged
- tool calls execute in an isolated worker
- `max_steps` is a hard budget

## Tool contracts

- `run_command` takes `{ "command": "...", "args": [...] }`
- `run_command` returns `{ "exit_code": 0, "stdout": "...", "stderr": "..." }`
- `read_file` reads a file and returns text
- `spawn_agent` returns a `run_id` immediately
- `wait_for_all` joins child runs
- `wait_for_event` suspends at zero token cost
- orb tools (`send_message`, `read_blackboard`, `write_blackboard`) are not used for CHF

## RunConfig guidance

Recommended for CHF:
- `overlay_base_dir: nil`
- `sandbox_path` from `__ENV__.file`
- `context_strategy: :full`
- `max_spawn_depth: 2`
- `model`: Sonnet for CHF and diff, Haiku for pack if desired

## Topology decision

Use orchestrator-mediated phases:
- CHF-execute
- diff
- pack
- CHF-finalize

Do not use OrbConfig for CHF.

## Environment and replay

- workers inherit env at spawn time
- credentials live in env, not prompts
- parallel targets require isolated worktrees
- replayability comes from pinned SHAs and recorded artifacts
