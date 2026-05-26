You are an Agent working in a local Git repository.

Repository name:
HCF-agentic-testbed

Primary goal:
Create a realistic telecom sustaining-engineering Git repository for testing CHF (Consolidated Hot Fix) orchestration workflows.

This repository is not a tutorial repo.
It is a simulated enterprise repo used to test:
- release engineering,
- tenant/customer drift,
- hotfix propagation,
- CHF creation,
- cherry-picking,
- selective rollout,
- release packaging,
- installation scripting,
- sustaining workflows,
- and Git-history reasoning.

Core scenario:
The company maintains a telecom DNS/DHCP/IPAM appliance platform.

There are three major customers:
- Airtel
- Reliance
- TATA

Internally, the repo may refer to them as:
- tenant-A
- tenant-R
- tenant-T

The important part is:
- different tenants/customers may run different releases,
- fixes may propagate differently,
- some hotfixes remain customer-specific,
- some fixes propagate upstream,
- some fixes are delayed,
- some CHF bundles contain only approved subsets of fixes.

The repository history must reflect realistic operational chaos.

What matters most:
- believable Git history,
- realistic branch topology,
- realistic commit granularity,
- realistic fictional commit authors,
- realistic release/hotfix/CHF lifecycle,
- selective propagation,
- believable tenant drift,
- lightweight markdown artifacts.

The exact markdown content does NOT matter much.
The topology, commit history, tags, propagation flow, and operational realism DO matter.

Important constraints:
- Keep markdown artifacts short and token-efficient.
- Most markdown files should be around 5–15 lines.
- Avoid large essays and verbose documentation.
- README.md and USER_STORY.md may be longer than the other files.
- Prefer many small realistic artifacts over a few giant files.

Authorship requirements:
- Every commit must have a believable fictional Indian-sounding engineer as the author (e.g. Ajay, Rahul, Priya, Neha, Sameer, Vikram, Rajesh, Tanuja, Arvind, etc.).
- You may freely choose which engineer works on which area — there is no fixed assignment.
- Try to keep the same person associated with a logical “storyline” (e.g. the same person who made a fix usually appears on its hotfix/CHF propagation) when it feels natural, but you have full freedom to decide.
- Record relevant authors and decisions in `USER_STORY.md`.
- Use the `--author="Name <email>"` flag (or equivalent environment variables) on **every** commit so the Git history shows realistic multi-author activity.

### Strict Execution Rules (MUST be followed in every response)

You are an Agent executing real Git operations inside the `HCF-agentic-testbed` repository.

- Before each major Scenario (0–9):
  - Briefly show current repo state (e.g. `git branch -a`, `git tag`, `git log --oneline -10`).
  - Show a numbered plan of sub-steps.
- Before each sub-step:
  - State the sub-step plan in one sentence.
  - Identify the fictional author you chose for this sub-step.
- After each sub-step:
  1. Stage **only** the files changed in this sub-step.
  2. Commit immediately using the `--author` flag so every commit has a different fictional engineer.
  3. Show the exact Git commands used.
  4. Record the fictional author.

**Exact commit command style you must use:**

```bash
git commit -m "Realistic focused commit message" --author="Priya <priya@telecom-corp.local>"
```

(Alternatively: `GIT_AUTHOR_NAME="Priya" GIT_AUTHOR_EMAIL="priya@telecom-corp.local" git commit ...`)

- Keep every commit small, focused, and believable. Never accumulate uncommitted changes across sub-steps.
- Never use `git commit -a --amend`, `git rebase`, `git reset`, or any history-rewriting commands.
- When referencing previous commits (cherry-pick, etc.), use `git log --grep="Exact commit message"`, relative references (`HEAD~1`), tags, or branch names. You may run `git status`, `git log`, or `git diff` as needed to inspect state.

Do not turn the trace into long explanatory essays. Keep the output clean and command-focused, like a real terminal session log.

### Mandatory Workflow Patterns

The following sequences **must** be followed exactly in the relevant scenarios. You may choose the concrete details (exact fix content, file names, authors, commit messages) freely.

**Top-down Hotfix Flow (Scenario 6)**
1. Create hotfix branch from the target release branch.
2. Make the change → commit (correct author).
3. Tag the hotfix.
4. Create `artifacts/<tag>/` directory containing *only* the changed files relative to the base release:
   - `changed-files.txt`
   - `package.tar.gz` (archive with only the modified files)
   - `install-<tag>.sh` (dummy script that backs up, replaces files, and restarts services).
5. Commit the packaging artifacts.
6. *Only after packaging* → cherry-pick or merge the fix to main / tenant branches as appropriate.
7. Update `USER_STORY.md` on `main` with the decision (who gets it, who doesn’t).

**Bottom-up Hotfix Flow (Scenario 7)**
Same sequence as above, but start from a tenant branch. After packaging, decide (and document in `USER_STORY.md`) whether the fix stays tenant-only, propagates to the release branch, or goes further.

**CHF Creation (Scenario 8)**
1. Create `chf/<version>-<number>` branch from the target release branch.
2. Selectively cherry-pick *only* the approved hotfix commits (exclude anything risky or tenant-specific).
3. Add a consolidation manifest/note if needed → commit.
4. Tag the CHF.
5. Create `artifacts/<chf-tag>/` with changed-files.txt, package.tar.gz (only files that differ from the base release), and install script.
6. *Only after packaging* → selectively propagate the CHF.
7. Record in `USER_STORY.md` exactly which fixes were included/excluded and why.

Git realism requirements:
- Use realistic branch names.
- Use realistic tags.
- Use realistic commit messages.
- Use realistic merge/cherry-pick flows.
- Allow branch divergence and propagation delay.
- Simulate operational decision-making through USER_STORY.md.

**Recommended naming conventions** (use these for realism):

| Item                  | Recommended Style                                      |
|-----------------------|--------------------------------------------------------|
| Tenant branches       | `tenant/airtel`, `tenant/reliance`, `tenant/tata`     |
| Hotfix branches       | `hotfix/release/v1.0.0/<short-name>` or `hotfix/tenant/airtel/<short-name>` |
| CHF branches          | `chf/v1.0.0-002`                                       |
| Artifact directories  | `artifacts/<tag>/`, `ops/`, `releases/`, `tenant/*/overrides.md` |

Examples of realistic commit messages:
- "DHCP: reduce stale lease retention during HA failover"
- "Telemetry: add reconnect throttling guidance"
- "AIRTEL: add conservative DHCP failover override"
- "CHF: prepare rollout bundle for v1.0.0-chf-002"
- "DNS: document cache lock contention mitigation"

Avoid:
- "misc changes"
- "fixes"
- "update docs"
- "work in progress"

High-level topology model:

```text
                main
                  │
        ┌─────────┴─────────┐
        │                   │
   release/v1.0.0      release/v1.1.0
        │                   │
   ┌────┼────┐              │
   │    │    │              │
   A    R    T              │
   │         │              │
 hotfixes   CHFs      future releases
```

Important topology behavior:
- main continues evolving after releases are cut.
- release branches stabilize older lines.
- tenant branches diverge from release branches.
- hotfixes may start from:
  - a release branch,
  - a tenant branch,
  - or occasionally upstream.
- CHF branches selectively consolidate approved fixes.
- Some fixes propagate back to main.
- Some fixes remain tenant-only.
- Some fixes propagate only after validation delays.

Scenario-first execution model:
Do NOT rigidly follow a file-generation checklist.
Instead, follow the operational scenarios below and create only the small artifacts necessary to support those scenarios.

Scenario 0 — Bootstrap upstream
- Initialize main.
- Seed the repo with a believable but compact operational baseline.
- Add lightweight operational artifacts establishing:
  - the telecom platform,
  - sustaining workflows,
  - release engineering context,
  - and future tenant support.
- Add the first USER_STORY.md entries introducing the fictional engineers and the future release/tenant workflow.

Scenario 1 — Upstream evolves
- main evolves through several small realistic commits.
- Add lightweight operational notes involving:
  - DHCP failover,
  - DNS recursion/cache behavior,
  - IPAM synchronization,
  - telemetry reconnect behavior,
  - appliance recovery,
  - observability,
  - operational tuning.
- Add one or two compact incident notes.
- USER_STORY.md should reflect who worked on which area.

Scenario 2 — First release cut
- Cut release/v1.0.0 from main.
- Tag the release.
- Add a small release note and stabilization note.
- USER_STORY.md should explain:
  - who cut the release,
  - why the release happened at this point,
  - why stabilization matters.

Important:
- The release tag itself is important.
- Treat the tagged point as the official deployment baseline.

Scenario 3 — Upstream diverges further
- main continues evolving after v1.0.0.
- Add newer operational changes that do NOT exist in v1.0.0.
- Add another small incident note.
- USER_STORY.md should mention growing backport complexity.

Scenario 4 — Additional release lines
- Cut a newer release line such as v1.1.0.
- Tag it.
- Make it visibly newer than v1.0.0.
- Some tenants may eventually adopt this newer line while others stay older.

Scenario 5 — Tenant drift
- Create tenant/customer branches from different release points.
- Example:
  - Airtel may stay on v1.0.0,
  - TATA may adopt v1.1.0,
  - Reliance may remain on an older sustaining line temporarily.
- Add lightweight customer-specific operational notes or overrides.
- USER_STORY.md should explain why customers diverged.

Scenario 6 — Top-down hotfix flow
This simulates an upstream or release-level fix propagating downward.

Sequence:
1. Create a hotfix branch from the appropriate release line.
2. Make the fix.
3. Commit with the correct fictional author.
4. Tag the hotfix.
5. Compare the hotfix branch against the base release.
6. Create a compact archive containing ONLY the changed files relative to that release.
7. Create a dummy installation script that:
   - backs up affected files,
   - replaces only those files,
   - clearly looks like a simulation artifact.
8. Only AFTER packaging:
   - cherry-pick or merge the fix back into:
     - main,
     - release lines,
     - or tenant branches as appropriate.
9. Update USER_STORY.md to explain:
   - who requested the fix,
   - who implemented it,
   - who approved propagation,
   - which tenants received it,
   - which tenants did NOT receive it.

Important:
- Not every customer receives every fix.
- Some fixes may intentionally remain customer-specific.

Scenario 7 — Bottom-up hotfix flow
This simulates a tenant emergency fix propagating upward.

Sequence:
1. A tenant-specific issue appears.
2. Create a tenant hotfix branch from the tenant branch.
3. Apply a targeted fix.
4. Commit with the correct fictional author.
5. Tag the tenant hotfix.
6. Create the compact archive and install script.
7. Then evaluate whether the fix should:
   - remain tenant-only,
   - propagate to release,
   - or propagate all the way back to main.
8. Perform realistic cherry-picks or merges if propagation happens.
9. Record the decision in USER_STORY.md.

Important:
- This is one of the most important CHF workflows.
- Simulate realistic operational hesitation and validation delays.

Scenario 8 — CHF creation
CHF means Consolidated Hot Fix.

Sequence:
1. Create a CHF branch.
2. Selectively pull approved fixes from multiple hotfixes.
3. Exclude risky or tenant-only fixes when appropriate.
4. Commit realistic consolidation changes.
5. Tag the CHF release.
6. Compare the CHF branch against its base release.
7. Create a compact CHF archive containing only the changed files.
8. Generate a dummy CHF installation script.
9. Update USER_STORY.md explaining:
   - which fixes were included,
   - which fixes were excluded,
   - which customers requested them,
   - why some items were delayed or rejected.

Important:
- CHF packaging happens BEFORE propagation.
- The archive/install-script lifecycle is important.

Scenario 9 — Propagation and long-term drift
- Continue selectively propagating fixes.
- Simulate:
  - delayed cherry-picks,
  - release-only fixes,
  - customer-only fixes,
  - rejected backports,
  - patch-on-patch fixes,
  - partial rollouts.
- USER_STORY.md should capture the operational reasoning.

Artifact expectations:
You may create small files such as:
- release notes,
- incident notes,
- operational notes,
- customer overrides,
- hotfix notes,
- CHF notes,
- packaging manifests,
- installation scripts,
- change manifests.

But:
- keep them compact,
- keep them believable,
- avoid large verbose content.

Archive/install-script expectations:
- The archive should contain only files changed relative to the relevant base release.
- The installation script should:
  - back up old files,
  - replace changed files,
  - simulate deployment behavior,
  - remain lightweight and obviously non-production.

USER_STORY.md expectations:
- Keep it chronological and cumulative.
- Keep entries compact.
- Record:
  - fictional engineer,
  - tenant/customer,
  - release/hotfix/CHF action,
  - tag creation,
  - archive creation,
  - install-script creation,
  - propagation decisions,
  - validation delays,
  - rejected or delayed fixes.

Final behavior requirements:
- Keep commits realistic.
- Keep branch history believable.
- Keep docs small.
- Keep the repo lightweight.
- Focus on operational realism and topology realism over documentation depth.

### What to Avoid
- Using `git config user.name` / `user.email` repeatedly or globally.
- Giant summary commits or narrative-heavy explanations.
- Placeholders or “assume it applies cleanly” language — use real Git commands and inspection steps.
- History-rewriting commands.
