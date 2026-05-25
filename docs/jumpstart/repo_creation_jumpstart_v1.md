You are Codex working in a local Git repository.

Repository name:
HCF-agentic-testbed

Important operating rules:
- Work step by step.
- Before doing any work on an overall step, show your initial plan for that step.
- Break each overall step into sub-steps before editing anything.
- Before each sub-step, update the plan for that sub-step.
- Do not skip ahead.
- Complete only one sub-step at a time.
- After each sub-step:
  1. make only the changes for that sub-step,
  2. stage the changed files with git add,
  3. commit immediately,
  4. then summarize the Git commands you ran for that sub-step.
- Do not combine multiple sub-steps into one commit.
- Do not wait until the end of the overall step to commit.
- Do not use one umbrella “summary” commit for a whole step.
- Each commit should correspond to one coherent sub-step only.
- Keep commit messages specific and realistic, matching the actual change made.
- Use the normal Git sequence: create or edit files first, then git add, then git commit.
- Do not try to commit untracked files without staging them first.
- Do not waste time debugging filesystem permissions, lock files, or Git plumbing unless a real error occurs.
- Keep the history authentic; avoid giant synthetic commits.
- Update USER_STORY.md at every sub-step where repository history changes.
- At the end of each overall step, provide a short summary of the Git commands executed across all sub-steps.
- Preserve the fictional customer names exactly as written:
  AIRTEL, RELIANCE, TATA.
- Preserve the fictional company and product identity:
  Bitloka Networks, ddi-manager.
- The repository is a telecom sustaining-engineering and hotfix testbed, not a tutorial repo.

Authorship and commit attribution rules:
- Every commit must be attributed to the correct fictional engineer(s) based on the subsystem, customer, or operational area being modified.
- Do not attribute all commits to the same person.
- Use realistic author attribution patterns throughout the repository history.
- Before each commit, determine which fictional engineer would realistically own that work.
- Set commit authorship appropriately before committing.
- The resulting git log should look like a real multi-engineer sustaining repository.

Author ownership guidance:
- Ajay Kulkarni:
  - AIRTEL sustaining work
  - DHCP customer escalations
  - operational mitigations for older deployments

- Rajesh Menon:
  - RELIANCE sustaining and release coordination
  - release branch stabilization
  - propagation decisions
  - telemetry rollout caution

- Tanuja Iyer:
  - TATA-specific operational customization
  - customer overrides
  - deployment-specific tuning
  - alarm/reporting adjustments

- Vikram Deshpande:
  - DHCP internals
  - HA failover behavior
  - lease handling
  - memory-retention mitigation

- Priya Nair:
  - DNS recursion
  - resolver behavior
  - cache tuning
  - DNS operational guidance

- Sameer Rao:
  - release engineering
  - CHF coordination
  - release-note preparation
  - branch-cut decisions
  - propagation coordination

- Neha Bansal:
  - telemetry reconnect logic
  - observability
  - collector scaling
  - telemetry incident analysis

- Arvind Shetty:
  - sustaining-management notes
  - escalation coordination
  - rollout caution
  - operational risk guidance

Important authorship constraints:
- A DHCP hotfix should usually not be authored by Priya Nair.
- A DNS cache tuning document should usually not be authored by Ajay Kulkarni.
- A CHF coordination commit should usually involve Sameer Rao.
- A RELIANCE telemetry escalation should usually involve Rajesh Menon and/or Neha Bansal.

Commit granularity rules:
- Each sub-step should usually result in exactly one commit.
- Each commit should have:
  - a realistic author,
  - a realistic timestamp sequence,
  - a realistic commit message,
  - a focused scope.
- Prefer smaller, realistic commits over one large commit.

Commit message examples:
- "DHCP: reduce stale lease retention during HA failover"
- "DNS: document resolver retry tuning guidance"
- "Telemetry: add reconnect backpressure operational notes"
- "AIRTEL: add conservative failover mitigation guidance"
- "CHF: prepare sustaining rollout notes for Q1 bundle"

Avoid generic commit messages like:
- "misc fixes"
- "update docs"
- "changes"
- "work in progress"

Fictional engineers and roles:
- Ajay Kulkarni — AIRTEL sustaining engineer
- Rajesh Menon — RELIANCE release engineer
- Tanuja Iyer — TATA integration engineer
- Vikram Deshpande — DHCP maintainer
- Priya Nair — DNS engineer
- Sameer Rao — release engineering lead
- Neha Bansal — telemetry architect
- Arvind Shetty — sustaining engineering manager

Repository purpose:
This repo simulates a realistic enterprise telecom appliance environment for DNS, DHCP, and IPAM maintenance.
It exists to test autonomous hotfix and consolidated-hotfix workflows, branch reasoning, propagation decisions, and USER_STORY.md provenance.

Core requirements:
- Build a believable short-lived repository history spanning roughly 1–2 months.
- Mainline must evolve before and between release cuts.
- Release branches must be cut after meaningful mainline development, not all at once.
- Customer branches must diverge from appropriate release lines.
- Hotfix branches must emerge from customer or release pressure.
- Consolidated hotfix (CHF) branches must bundle selected approved fixes.
- Include realistic incidents, rollback notes, partial propagation, failed backports, and patch-on-patch follow-ups.
- Keep the repo operationally realistic, not synthetic.
- All changes so far must be reflected in USER_STORY.md, with chronological attribution to the fictional people above.
- The repository history should look authentic and granular.

Document size and verbosity constraints:
- Keep generated documents intentionally concise.
- Most markdown files should be approximately 10–20 lines maximum.
- Incident reports, release notes, operational notes, and customer override docs should be short but realistic.
- Avoid generating large essays, long architectural explanations, or excessively detailed prose.
- Prefer many small realistic documents over a few massive ones.
- Keep USER_STORY.md concise but cumulative; each update should usually add only a short chronological entry.
- The repository exists for release-engineering and hotfix-agent testing, not documentation completeness.
- Optimize for believable Git history and branch topology rather than document depth.
- Minimize unnecessary token usage while preserving realism.

Strict file size limits:
- Most generated markdown files under docs/ should be between 5 and 15 lines total.
- Absolute maximum for normal operational docs: 20 lines.
- Incident reports should usually be 8–15 lines.
- Release notes should usually be 5–12 lines.
- Customer override notes should usually be 5–10 lines.
- Troubleshooting notes should usually be 5–15 lines.
- USER_STORY.md updates should usually add only 3–8 lines per sub-step.
- Do not generate long introductions, conclusions, or explanatory prose.
- Prefer terse operational language, bullet points, and compact sections.
- Avoid large markdown headers and verbose formatting.
- Avoid producing “complete documentation”; create lightweight realistic artifacts only.
- If a document starts becoming long, split it into multiple small focused files instead.
- Token efficiency is important.

How to work:
For each overall step:
1. inspect the current repo state,
2. show the plan for the overall step,
3. break the step into sub-steps,
4. before each sub-step, show the sub-step plan,
5. determine the correct fictional author for the sub-step,
6. perform only the requested work for that sub-step,
7. stage the files changed in that sub-step,
8. commit immediately after that sub-step,
9. update USER_STORY.md whenever repository history changes,
10. summarize the Git commands executed for that sub-step,
11. show which fictional engineer authored the commit,
12. move to the next sub-step only after finishing the current one.

Global sub-step guidance:
- Keep each generated file small and focused.
- Prefer terse operational notes over explanations.
- Keep files intentionally small.
- Avoid writing narrative paragraphs unless explicitly requested.
- Use compact bullets and short sections instead of prose.
- Avoid bloated markdown content.

STEP 0 — Initialize the repository
Goal:
Create the repository skeleton and first policy/docs files on main.

Must do:
- Initialize the repo on main if needed.
- Create the directory structure for docs, configs, scripts, and internal notes.
- Populate these files:
  - README.md
  - AGENTS.md
  - RELEASE_POLICY.md
  - HOTFIX_POLICY.md
  - CHF_POLICY.md
  - USER_STORY.md
- README.md should explain the product, the telecom appliance model, and why the repo exists.
- AGENTS.md should give operating guidance for autonomous hotfix agents:
  inspect before acting, deterministic cherry-picks, branch safety, audit logging, rollback awareness, propagation verification.
- RELEASE_POLICY.md should describe realistic branching and release cadence.
- HOTFIX_POLICY.md should describe emergency-fix and sustaining workflows.
- CHF_POLICY.md should describe consolidated hotfix assembly and selection criteria.
- USER_STORY.md should begin the timeline and mention:
  repository initialization,
  early platform planning,
  Priya Nair,
  Vikram Deshpande,
  Sameer Rao,
  and the expectation of future customer branches and hotfix branches.

Sub-step guidance:
- Prefer small, realistic sub-steps rather than one giant setup commit.
- If practical, split this step into:
  a) scaffold directories and empty placeholder files,
  b) populate README/AGENTS/policy docs,
  c) initialize USER_STORY.md with the first narrative.
- After each sub-step, stage and commit immediately.

STEP 1 — Build mainline platform documentation
Current branch:
main

Must do:
Add initial internal documentation under:
- docs/dhcp/
- docs/dns/
- docs/ipam/
- docs/troubleshooting/

These docs should cover realistic telecom operational topics such as:
- DHCP HA failover
- lease scavenging
- DNS recursion behavior
- cache pressure
- IPAM replication
- stale lease cleanup
- split-brain handling
- VRRP failover
- telemetry reconnect edge cases

Update USER_STORY.md with entries showing:
- Vikram documenting DHCP HA concerns
- Priya documenting resolver stability observations
- Neha documenting telemetry reconnect edge cases
- Sameer preparing for the first release line

Sub-step guidance:
- Break this into separate sub-steps if needed, for example:
  a) DHCP docs,
  b) DNS docs,
  c) IPAM/troubleshooting docs,
  d) USER_STORY.md update.
- Commit after each sub-step.

STEP 2 — Add more mainline evolution before the first release cut
Current branch:
main

Must do:
Add additional platform and operational notes that make the later release branches believable.
Include documentation for:
- telemetry scaling
- appliance synchronization
- backup/restore guidance
- DNS cache tuning
- DHCP lease cleanup procedures
- subscriber provisioning notes

Add at least one incident document involving:
- telemetry reconnect storms
or
- excessive DHCP lease retention

Update USER_STORY.md to explain:
- Neha’s telemetry findings
- Vikram’s lease-retention investigation
- Priya’s conservative resolver tuning stance
- Sameer’s view that the platform is nearing release readiness

Sub-step guidance:
- Use multiple sub-steps if helpful, but keep commits granular and authentic.
- Commit after each sub-step.

STEP 3 — Cut release/1.0.x after main has meaningful history
Action:
Create a release branch from the current main state.

Current branch after cut:
release/1.0.x

Must do:
Treat this as the first conservative sustaining release line.
Add release-note drafts under docs/release-notes/.
Add stabilization and upgrade-caution documentation.
Add at least one incident note involving DHCP failover instability or lease retention.
Keep the change set conservative and operationally focused.

Update USER_STORY.md to explain:
- Sameer cut release/1.0.x
- Vikram added conservative DHCP stabilization notes
- Rajesh advised against risky backports
- Arvind requested caution for production deployments

Sub-step guidance:
- Split into sub-steps such as:
  a) branch cut,
  b) release notes,
  c) stabilization docs,
  d) incident note,
  e) USER_STORY.md update.
- Commit after each sub-step.

STEP 4 — Return to main and continue evolving it beyond release/1.0.x
Current branch:
main

Must do:
Add newer platform evolution that does not yet exist in release/1.0.x.
Include documentation for:
- telemetry architecture changes
- DNS cache optimization
- newer IPAM synchronization behavior
- observability improvements
- operational hardening notes

Add at least one incident involving:
- telemetry backpressure
or
- DNS cache lock contention

Update USER_STORY.md to show:
- Neha exploring improved telemetry handling
- Priya working on more advanced DNS behavior
- Sameer discussing a future 1.1 release line
- Rajesh warning that future backports are becoming harder

Sub-step guidance:
- Keep the mainline ahead of release/1.0.x in a believable way.
- Commit after each sub-step.

STEP 5 — Cut release/1.1.x after more mainline development
Action:
Create a release branch from the newer main state.

Current branch after cut:
release/1.1.x

Must do:
Treat this as a newer release line with some divergence from 1.0.x.
Add realistic release notes and operational advisories.
Keep the branch more evolved than release/1.0.x.

Update USER_STORY.md to note:
- this branch was cut later than release/1.0.x
- the code/documentation base is already more advanced
- future backports will not always be trivial

Sub-step guidance:
- Make the branch cut a distinct sub-step.
- Then add content in separate sub-steps if useful.
- Commit after each sub-step.

STEP 6 — Continue mainline development again before the next customer work
Current branch:
main

Must do:
Add further evolution on main, such as:
- telemetry collector scaling guidance
- appliance recovery procedures
- DNS recursion troubleshooting notes
- operational notes for newer IPAM synchronization behavior

Add one incident involving:
- telemetry backpressure
or
- DNS retry storms

Update USER_STORY.md to reflect:
- increasing divergence from release/1.0.x
- increasing divergence from release/1.1.x
- the growing complexity of sustaining support

Sub-step guidance:
- Use separate commits for separate logical changes.
- Commit after each sub-step.

STEP 7 — Create customer branches from the correct release lines
Important:
Use the following customer identities exactly as written:
AIRTEL, RELIANCE, TATA.

Must do:
Create customer sustaining branches from appropriate release bases:
- AIRTEL from release/1.0.x
- RELIANCE from release/1.0.x
- TATA from release/1.1.x

The branch names should make the customer association obvious.

Sub-step guidance:
- Branch creation may be one sub-step, but do not combine it with customer content edits.
- Show the Git commands used to create the branches.

STEP 8 — Simulate AIRTEL customer pressure
Current branch:
customer/airtel/release-1.0

Context:
AIRTEL is running older but stable deployments and is sensitive to DHCP behavior.

Must do:
Add customer-specific override documentation.
Add a realistic incident involving:
- DHCP lease exhaustion during failover
or
- stale lease buildup after reconnect
or
- HA instability on legacy edge clusters

Update USER_STORY.md to explain:
- AIRTEL escalated the issue
- Ajay investigated customer logs
- Vikram recommended a conservative mitigation
- Arvind approved minimal-risk changes because production sensitivity was high

Sub-step guidance:
- Separate the customer override doc from the incident note if helpful.
- Commit after each sub-step.

STEP 9 — Simulate RELIANCE customer pressure
Current branch:
customer/reliance/release-1.0

Context:
RELIANCE has aggressive telemetry collection and strong observability expectations.

Must do:
Add customer-specific telemetry override documentation.
Add a realistic incident involving:
- telemetry reconnect storms
or
- collector overload
or
- WAN instability causing observability degradation

Update USER_STORY.md to explain:
- RELIANCE escalated reconnect instability
- Rajesh coordinated sustaining analysis
- Neha proposed reconnect throttling
- Sameer delayed broader propagation until validation completed

Sub-step guidance:
- Keep the work customer-specific.
- Commit after each sub-step.

STEP 10 — Simulate TATA customer drift on the newer release line
Current branch:
customer/tata/release-1.1

Context:
TATA has requested more custom operational behavior and will drift further from standard sustaining releases.

Must do:
Add TATA-specific override documentation.
Add realistic notes related to:
- DNS alarm thresholds
- resolver retry behavior
- operational reporting customization
- deployment-specific failover procedures

Add an incident involving:
- DNS cache pressure
or
- resolver retry storms

Update USER_STORY.md to explain:
- Tanuja introduced deployment-specific overrides
- Priya warned about future merge complexity
- Sameer documented increasing customer divergence

Sub-step guidance:
- Keep customer drift visible and realistic.
- Commit after each sub-step.

STEP 11 — Create the first real hotfix branch for AIRTEL
Action:
Create a hotfix branch from the most appropriate sustaining release line for the AIRTEL problem.

Current branch after creation:
hotfix/DHCP-1842-memory-leak

Context:
AIRTEL reported DHCP memory growth during repeated HA failover events.

Must do:
Add a realistic incident writeup describing:
- memory growth during HA failover
- stale lease retention
- operational impact

Add sustaining notes explaining:
- mitigation strategy
- why the fix is intentionally conservative
- why a risky refactor is not appropriate here

Add a release-note draft entry.

Update USER_STORY.md to explain:
- AIRTEL escalated the issue
- Ajay isolated the failover-related memory growth
- Vikram avoided risky allocator refactors
- Arvind approved emergency sustaining work

Sub-step guidance:
- This should usually be multiple sub-steps:
  a) create hotfix branch,
  b) write incident note,
  c) write sustaining notes / release note,
  d) update USER_STORY.md.
- Commit after each sub-step.

STEP 12 — Merge the AIRTEL hotfix back into the relevant release line
Must do:
Merge the hotfix into the appropriate sustaining release branch.
Keep the merge realistic, with a normal merge commit if appropriate.
Then propagate to the AIRTEL customer branch if it is needed there.

Update USER_STORY.md to record:
- the merge decision
- whether propagation happened immediately
- whether any validation or caution was required

Sub-step guidance:
- Separate merge, cherry-pick, and narrative updates if needed.
- Commit after each sub-step.

STEP 13 — Record delayed propagation when appropriate
Must do:
If a propagation is intentionally delayed for RELIANCE or any other line, do not force it.
Instead, document the delay in USER_STORY.md and/or an incident or release note.
The repo should show a believable sustaining decision, not universal propagation.

Important:
This is where the repo should show realistic operational hesitation and validation constraints.

Sub-step guidance:
- Commit after each sub-step.

STEP 14 — Create a CHF branch
Action:
Create a consolidated hotfix branch for the release line most appropriate for bundling approved fixes.

Current branch after creation:
chf/2025-Q1

Context:
This branch represents a consolidated hotfix release.

Must do:
Selectively bring in approved fixes only.
Bundle multiple sustaining fixes that are safe to roll out together.
Intentionally exclude some risky or customer-specific patches.
Add docs/release-notes/ content describing:
- included fixes
- excluded fixes
- rollout cautions
- validation requirements

Update USER_STORY.md to explain:
- Sameer coordinated CHF assembly
- Rajesh pushed for conservative inclusion criteria
- Neha requested additional telemetry validation
- Arvind prioritized stability over broad parity

Sub-step guidance:
- Use multiple sub-steps if helpful:
  a) create CHF branch,
  b) bring in selected fixes,
  c) write CHF notes,
  d) update USER_STORY.md.
- Commit after each sub-step.

STEP 15 — Add a patch-on-patch follow-up if needed
Must do:
If a hotfix introduced a follow-up issue, create a second hotfix branch and document the regression.
This should be a realistic patch-on-patch scenario, not a contrived one.
Update USER_STORY.md to make the sequence clear.

Sub-step guidance:
- Commit after each sub-step.

STEP 16 — Finalization
Must do:
- Ensure USER_STORY.md is complete, chronological, and consistent.
- Ensure branch history reflects mainline evolution, release cuts, customer drift, hotfixes, and CHF assembly.
- Ensure docs/release-notes/, docs/incidents/, docs/customer-overrides/, and docs/troubleshooting/ contain plausible content.
- Ensure branch names, tags, and commit messages look realistic.
- Ensure the repo feels like a short-lived but active sustaining repository.

Final output rules:
- After each sub-step, report the exact Git commands you ran in that sub-step.
- After each overall step, provide a short step summary as well.
- Show which fictional engineer authored each commit.
- Do not end a step with uncommitted work unless that step explicitly requires staging only.
- Prefer authentic granularity over compression.
- Prefer smaller, realistic commits over one large commit.
- If a step naturally splits into multiple logical changes, make multiple commits, one per sub-step.
- Do not generate excessively large files.
- Keep the repository lightweight and token-efficient.
- Realism is more important than document length.
- Before writing a document, estimate its target line count.
- If the content exceeds the expected limit, shorten it aggressively.
- Small believable artifacts are preferred over comprehensive documents.

Important final note:
The history should look authentic.
Each sub-step should end with:
- git add
- git commit
- a short command summary
- author attribution
- then wait for the next instruction.
