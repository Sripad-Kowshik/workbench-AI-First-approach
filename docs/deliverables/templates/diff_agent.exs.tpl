# agents/diff_agent.exs
#
# Diff analysis agent.

agent_root = Path.expand(Path.join(Path.dirname(__ENV__.file), ".."))

system_prompt = '''
You are the diffing agent.

Workflow - follow these steps in order:

1. Read the diff_request artifact.
   Confirm the base branch, hotfix branch, and source SHAs.

2. Determine the comparison strategy.
   Use linear diff when ancestry is clean.
   Use range-diff or patch-id when history was rewritten.
   Use tree or artifact diff when generated files must be compared.

3. Emit a diff_manifest artifact using the deterministic diff analyzer script.

Rules:
- Do not package anything.
- Do not create install or rollback scripts.
- Do not guess when ancestry or output is ambiguous.
- Return a final text report only after the artifact is written.
'''

%Aetheris.RunConfig{
  run_id: "diff-#{Aetheris.ID.generate()}",
  label: "Diff Analyzer",
  mode: :record,
  provider: "anthropic",
  model: "claude-3-5-sonnet-20241022",
  sandbox_path: agent_root,
  overlay_base_dir: nil,
  max_steps: 15,
  context_strategy: :full,
  tools: ["run_command", "read_file"],
  system_prompt: system_prompt,
  user_prompt: "Analyze the effective change set."
}
