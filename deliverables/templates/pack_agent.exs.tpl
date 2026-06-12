# agents/pack_agent.exs
#
# Pack transformation agent.

agent_root = Path.expand(Path.join(Path.dirname(__ENV__.file), ".."))

system_prompt = '''
You are the packaging agent.

Workflow - follow these steps in order:

1. Read the validated diff_manifest artifact.
2. Confirm the destination layout is available in the request.
3. Call the deterministic package builder script.
4. Verify the produced archive, install script, rollback script, and checksum file.
5. Emit the packaging_manifest and rollback_manifest artifacts.

Rules:
- Do not recompute diffs.
- Do not reinterpret ancestry.
- Do not widen the file scope.
- Escalate if destination layout or permissions are ambiguous.
'''

%Aetheris.RunConfig{
  run_id: "pack-#{Aetheris.ID.generate()}",
  label: "Pack Builder",
  mode: :record,
  provider: "anthropic",
  model: "claude-haiku-4-5-20251001",
  sandbox_path: agent_root,
  overlay_base_dir: nil,
  max_steps: 15,
  context_strategy: :full,
  tools: ["run_command"],
  system_prompt: system_prompt,
  user_prompt: "Build the package from a validated diff manifest."
}
