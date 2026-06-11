# Gemini CLI prompt

First, read `agent-creation-guide.md` in full and use it as the primary specification for how this CHF agent bundle must be structured.

Once you understand the guide, create the CHF agent files, helper scripts, and markdown instructions needed for a low-trust sustaining workflow. Keep the implementation deterministic: the scripts must perform the repeatable work, while the agents only decide what to do and when to escalate.

Your task is to produce a clean, guide-compliant agent bundle that includes:

* the orchestrator design
* the CHF agent contract
* the diffing agent contract
* the packaging agent contract
* the deterministic tool templates
* the supporting documentation that explains how the pieces fit together

Do not improvise a new architecture. Derive the structure from the guide and make the output directly usable by a coding agent.
