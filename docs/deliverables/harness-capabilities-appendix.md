# Harness capabilities appendix

> Audience: engineers designing agents for the Aetheris harness **without access to
> the aetheris/ or aetheris-agents/ repositories**. This document is the contract
> between you and the harness. If a behaviour you depend on is not written here,
> ask — do not assume.
>
> Lines marked `⚠ VERIFY` are pending confirmation by the harness owners and will
> be resolved in a future revision. Do not build load-bearing logic on them.

---

## 1. Execution model

An **agent** is a single LLM loop defined by one Elixir struct in a `.exs` file.
The harness evaluates the file, takes the resulting struct, and runs the loop:

```
build prompt → call LLM → (tool call? execute via Rust worker → append result → loop)
                        → (text response? terminate run as :done)
```

Key consequences:

- **A plain text response ends the run.** The agent's final text answer is the
  termination signal. An agent that "thinks out loud" in text mid-task will
  terminate itself. Prompts must instruct the agent to act via tools until the
  final report.
- **Every step is durably logged** to an append-only trajectory (SQLite during the
  run, `priv/runs/{run_id}/trajectory.json` after). Events are immutable. The
  trajectory is the audit source of truth — `CHF-STATE.md` is the *human-readable*
  log; the trajectory is the *machine* log. You get the trajectory for free.
- **Tool calls never execute inside the orchestrating VM.** All side effects go
  through an isolated Rust worker process. The worker inherits its environment at
  spawn time (see §7).
- **`max_steps` is a hard budget.** One LLM round-trip = one step. When exhausted,
  the run terminates regardless of task state. Budget generously for git-heavy
  flows: every `run_command` is a step.

Two struct types exist:

| Struct | Use |
|---|---|
| `%Aetheris.RunConfig{}` | One agent (solo, or a sub-agent spawned by another) |
| `%Aetheris.OrbConfig{}` | A coupled multi-agent group sharing a blackboard and a `:one_for_all` supervisor — if one agent crashes, **all** are terminated |

For the CHF system, **do not use OrbConfig** (see §5 for the topology decision).

---

## 2. Tool catalog and I/O contracts

Tools are granted per-agent via the `tools:` list. Grant the minimum set; the
tool surface in `02-tool-surface.md` is normative for CHF.

### 2.1 `run_command`

Executes a command via the Rust exec server, in the agent's `sandbox_path`.

Call shape — **always two separate fields, never a shell string**:

```json
{ "command": "python3", "args": ["scripts/chf_git_ops.py", "checkout", "--branch", "release/2.4"] }
```

Result shape (returned to the LLM as the tool result):

```json
{ "exit_code": 0, "stdout": "…", "stderr": "…" }
```
`⚠ VERIFY` — exact field names of the result payload (`exit_code` vs `status`),
and whether stdout is truncated above a size threshold.

Hard rules, learned from prior use cases:

- The LLM will duplicate the command name into `args` (`python3 python3 x.py`)
  unless the prompt shows the exact two-field format. Always show it.
- Never have an agent pass an inline program via `python3 -c "…"`. Long argument
  strings exceed the call buffer/timeout. All logic lives in script files.
- Working directory is the sandbox root. All paths in prompts are
  sandbox-relative.
- There is **no command allowlist in the harness today**. "No unconstrained
  shell" (00-scope quality gate) is enforced by two layers you must build:
  (a) prompts that only ever name the six deterministic scripts, and
  (b) the scripts themselves refusing dangerous arguments. Treat any prompt that
  invokes raw `git` (outside `chf_git_ops.py`) as a defect. `⚠ VERIFY` — whether
  a worker-level allowlist is planned.

### 2.2 `read_file`

Reads a file inside the sandbox. Input: `{ "path": "output/diff_manifest.json" }`.
Returns file content as text. Use it for manifests and state files; do not use it
to re-derive what a script already emitted on stdout.

### 2.3 `write_file` — **not granted to any CHF-system agent**

Exists in the harness, but granting it violates "no agent invents file contents."
All file creation goes through scripts. If a design needs `write_file`, the
design is wrong.

### 2.4 `spawn_agent` (orchestrator only)

Spawns a sub-agent mid-run and **returns its `run_id` immediately** (fire-and-
forget; pair with `wait_for_all` to join).

Call shape:

```json
{
  "task_prompt": "…self-contained instructions…",
  "tools": ["run_command", "read_file"],
  "max_steps": 30
}
```

Contract details that are easy to get wrong:

- `task_prompt` becomes the sub-agent's **system_prompt**; the harness injects
  `user_prompt: "Begin."` automatically (the Anthropic API requires ≥1 user
  message).
- The sub-agent **inherits `sandbox_path`** from the spawner. It does **not**
  inherit conversation context. The task_prompt must be fully self-contained:
  what to do, exact `run_command` formats, where artifacts live, what to report.
- `spawn_depth` is incremented by the harness automatically — never set it in an
  agent file. `max_spawn_depth` (default 3, set 2 for CHF) stops runaway
  recursion.
- Passing structured input: serialize the payload (e.g. the orchestrator→CHF
  JSON from `04-orchestrator-contract.md`) **into the task_prompt text**. There
  is no separate data channel to a sub-agent at spawn time. Keep payloads small;
  large data goes into a file the sub-agent reads.

### 2.5 `wait_for_all` (orchestrator only)

Fork-join. Input: the list of `run_id`s from prior `spawn_agent` calls plus
`timeout_ms`. Blocks the orchestrator's step (at **zero token cost** — the
suspended step does not consume LLM calls) until all children finish or the
timeout fires. Returns per-child status and final output.

`⚠ VERIFY` — exact result payload shape (per-child `{run_id, status, result}`),
and behaviour on timeout (partial results vs error).

The harness guards the already-done race: children that finish before the
orchestrator starts waiting are still collected. You do not need to handle this.

### 2.6 `wait_for_event` (suspend/resume — see §6)

Suspends the agent's loop until a condition fires, at zero token cost:

```json
{ "condition": "message_received", "timeout_ms": 300000 }
```

Resume state (messages, tool history, wait condition) is checkpointed in the
harness DB (`run_checkpoints`), so a suspended run survives and can be woken by
an external HTTP call to the harness resume endpoint — this is the production
path for human escalation responses (§6).

### 2.7 `send_message`, `read_blackboard`, `write_blackboard` (orb runs only)

Inter-agent messaging and shared key-value state for OrbConfig groups. **Not
used in the CHF system** — listed only so you know they exist and why we chose
not to use them (§5).

### 2.8 `list_dir`

Directory listing for exploration agents. The diff agent may use it if granted;
prefer having `diff_analyzer.py` emit file lists instead. `⚠ VERIFY` — whether
`list_dir` is granted to the diff agent or it relies on script output only.

---

## 3. RunConfig field reference

Every field the team will touch, with the CHF-system recommended value.

| Field | Meaning | CHF guidance |
|---|---|---|
| `run_id` | Unique ID; suffix with `Aetheris.ID.generate()` | `"chf-orch-#{Aetheris.ID.generate()}"` — never hardcode |
| `label` | Human-readable name shown in CLI/dashboard | e.g. `"CHF Orchestrator"` |
| `mode` | `:record` executes and logs; replay/fork modes re-run from a trajectory | always `:record` |
| `provider` / `model` | LLM backend | `anthropic`; Haiku for pack agent, **Sonnet for CHF and diff agents** — ancestry and conflict judgment is where a cheaper model guesses, and guessing is the spec's cardinal sin. Confirm with an A/B eval (§8) before locking in. |
| `sandbox_path` | Root for all tool I/O | **Always** `Path.expand(Path.join(Path.dirname(__ENV__.file), ".."))`. Never `File.cwd!()` — it resolves to wherever `mix aetheris run` was invoked. |
| `overlay_base_dir` | If set, writes go to a per-run OverlayFS layer | `nil` — packages in `output/` and `CHF-STATE.md` must persist on disk. Comment the line `# intentional — artifacts are the deliverable`. |
| `max_steps` | Hard step budget | orchestrator 20; CHF agent 30 (git flows are step-hungry); diff 15; pack 15 |
| `max_spawn_depth` | Spawn recursion cap | 2 on the orchestrator; sub-agents get no `spawn_agent` at all |
| `context_strategy` | `:full` \| `:rolling` \| `:summarise` | `:full` for every CHF-system agent. `:rolling` with small `max_context_steps` truncates old messages and can orphan `tool_use_id` references → HTTP 400. Only consider `:rolling` if the CHF agent provably exceeds the context window, and then with `max_context_steps ≥ 8`. |
| `max_wait_ms` | Cap on suspended waits | set explicitly on the orchestrator; an escalation that waits forever is an outage |
| `tools` | Granted tool list | per `02-tool-surface.md`, no additions |
| `system_prompt` / `user_prompt` | Built as named variables, then placed in the struct. Never inline `System.get_env` in the struct literal. | system_prompt carries the workflow; user_prompt carries the run-specific payload |
| `store_prompts` | `true` (default) stores full prompts in the trajectory file | set `false` if prompts ever carry credentials or tenant-sensitive data. For CHF, prompts should never carry credentials anyway (§7). |
| `spawn_depth` | **Harness-managed.** Never set it. | — |

Runtime parameters enter via environment variables read at eval time:

```elixir
issue_id = System.get_env("CHF_ISSUE_ID") || raise "CHF_ISSUE_ID not set"
```

---

## 4. Prompt construction rules (normative)

These are distilled from production failures in earlier use cases. Treat them
as requirements, not style.

1. **Show exact tool-call shapes.** Every `run_command` in a prompt is written
   as the two-field form with literal `command:` and `args:` lines.
2. **Numbered workflow steps**, one action per step, ending with a "Report"
   step that defines exactly what the final text answer contains.
3. **A Rules section** that always includes: *"If run_command returns a
   non-zero exit_code, report the error and stop. Do not investigate or retry
   manually."* Without this line, agents go off-script after failures and start
   exploring the repo.
4. **Failure = escalation artifact, then stop.** For CHF agents the stop rule
   is sharpened: on any escalation trigger (05-chf-agent-contract), call
   `state_manager.py escalate …` to write the structured escalation artifact,
   then end the run with a text report naming the artifact path. Never
   improvise a fix.
5. **Sub-agent prompts are self-contained.** No reference to "the manifest from
   before" — give the literal path.

---

## 5. CHF topology — the resolved design decision

`02-tool-surface.md` gives the CHF agent only `run_command` + `read_file`, yet
`03`/`05` say it "emits a diff request and waits for downstream artifacts."
Three implementations are possible in this harness; we choose **(a)** and the
docs are to be read accordingly.

**(a) Orchestrator-mediated phases — CHOSEN.**

```
orchestrator (spawn_agent + wait_for_all)
 ├─ phase 1: spawn CHF-execute      → branch, cherry-pick, tests, writes output/diff_request.json, finishes
 ├─ phase 2: spawn diff agent        → reads diff_request.json, writes output/diff_manifest.json, finishes
 ├─ phase 3: spawn pack agent        → reads diff_manifest.json, writes package + packaging_manifest.json, finishes
 └─ phase 4: spawn CHF-finalize      → reads packaging_manifest.json, review/tag steps, finishes
```

The orchestrator runs `wait_for_all` after each phase, **validates the phase's
artifact via `state_manager.py validate <artifact>` before spawning the next
phase**, and halts on any blocker. "The CHF agent waits for downstream
artifacts" is realized as: the CHF run *ends* at the handoff, and a fresh
CHF-finalize run is spawned after downstream phases pass validation. State
continuity between CHF-execute and CHF-finalize comes from `CHF-STATE.md` and
the artifacts on disk — rehydrating state from the workspace is already a
required CHF behaviour (05 §responsibilities, "rehydrate state").

Why (a): it keeps the specced tool surfaces exactly as written; each agent has
one job and a small context; validation gates live in deterministic code at the
orchestrator boundary, not in agent judgment; a failed phase leaves a clean,
resumable workspace.

**(b) CHF spawns diff/pack itself** (`spawn_agent`+`wait_for_all` added to CHF)
— rejected: widens the CHF tool surface, buries validation gates inside an LLM
context, and makes the CHF prompt do three jobs.

**(c) OrbConfig with blackboard/messaging** — rejected: `:one_for_all`
supervision means a crashed pack agent kills the CHF agent mid-git-operation,
potentially leaving a dirty worktree; the agents here are sequential, not
concurrent, so the orb machinery buys nothing.

One-target isolation (04) maps to: **one CHF phase-set per base branch**, run
sequentially by default. If run in parallel, each target must use its own git
worktree/clone — see §7.

---

## 6. Escalation, suspend/resume, and human steering

Three mechanisms, in increasing order of production-readiness:

1. **Halt-and-report (sandbox default).** The agent writes an
   `escalation_request` artifact (schema in doc 11) via `state_manager.py` and
   terminates. A human reads it, fixes or answers, and re-runs the phase. This
   is the only mechanism the team needs for the v1 sandbox build.
2. **`STEER.md` (live override).** Before each major phase, agents check for
   `STEER.md` in the workspace; if present, incorporate it, log the
   incorporation in `CHF-STATE.md`, and delete the file (08-state-and-audit).
   Have a *script* (`state_manager.py steer-check`) read/consume it so the act
   is logged deterministically.
3. **Suspended run + webhook resume (production path).** An agent calls
   `wait_for_event` and blocks at zero token cost; an external system answers
   the escalation by POSTing to the harness resume endpoint, which wakes the
   run with the answer. The harness checkpoints suspended-run state durably, so
   this survives long waits. Design v1 escalation payloads so they can later be
   delivered over this channel unchanged — that is why escalations are a
   schema'd artifact, not prose.

Escalations always offer **lettered options (A/B/C…)** with exactly one
recommended option, per `03-artifacts-and-handoffs.md`.

---

## 7. Environment, sandbox, and git realities

- **Workers inherit env at spawn time.** Export all env vars (tokens, paths)
  *before* `mix aetheris run`. If a var changes mid-session, stale workers keep
  the old value — kill them (`pkill -f aetheris_worker`) and re-run.
- **Credentials never appear in prompts or artifacts.** Git auth is the
  worker-environment's problem (SSH agent or token in env consumed by
  `chf_git_ops.py`). Scripts must redact tokens from any logged command line.
  `⚠ VERIFY` — whether the worker sandbox permits outbound network for
  `git fetch`, and the sanctioned credential mechanism.
- **Concurrent targets need isolated worktrees.** The repo-layout doc implies a
  single workspace; two simultaneous CHF runs against one checkout will corrupt
  each other. `chf_git_ops.py` must create a `git worktree` (or clone) per
  `chf/*` branch under a sanctioned temp path, and the orchestrator passes that
  path to every downstream phase. Sequential-by-default until this exists.
- **Idempotency on re-run.** A crash between cherry-pick and tests must not
  re-apply commits on retry. `chf_git_ops.py` checks before acting: branch
  already exists → reuse; commit already applied (`git cherry` / patch-id) →
  skip and log. `CHF-STATE.md` records phase checkpoints so re-runs rehydrate
  instead of redoing.
- **Replayability scope.** `git fetch` against a live remote is
  non-deterministic. "Replayable" (08) means *replayable against the pinned
  SHAs recorded in the manifests*, which is why every artifact carries
  `source_shas` and resolved branch SHAs.

---

## 8. Validation machinery you get for free

The harness ships an eval framework the CHF system should plug into rather
than reinvent:

| Capability | What it does | CHF use |
|---|---|---|
| Eval tasks & suites | Declarative task: agent file + inputs + outcome spec | one task per repo-factory scenario (clean pick, conflict, rewritten history, generated files, missing dep, dirty tree) |
| Scorers: `exit_code`, `fs_hash`, `regex` | Deterministic pass/fail on run results and produced files | `fs_hash` the package contents; `regex` the `CHF-STATE.md` for required checkpoints; `exit_code` on validator scripts |
| Scorer: `llm_judge` | Optional LLM-graded rubric (skipped without API key) | judge escalation quality (did it offer correct lettered options?) |
| Baselines | Lock a known-good run; compare future runs structurally | regression-gate every prompt change |
| A/B runs | Same task, two configs | Haiku vs Sonnet per agent role; prompt variants |
| `aetheris diff` / `aetheris tree` | Structural trajectory diff; spawn-tree inspection | debugging divergent phase behaviour |

The team without harness access designs to this by treating **every scenario's
expected outcome as data**: `repo_factory.py` emits an `expected.json` next to
each fixture, and the harness owners wire it into eval tasks.

---

## 9. What the harness does NOT provide

So nobody designs against phantom features: no command allowlist on
`run_command` (§2.1); no secret store (env only); no scheduler-driven retries
of failed runs (re-run is a human or wrapper-script action); no cross-run
memory other than files on disk and the skills store; no automatic artifact
schema validation (that is `state_manager.py`'s job — doc 11); no parallel-safe
shared git workspace (§7).
