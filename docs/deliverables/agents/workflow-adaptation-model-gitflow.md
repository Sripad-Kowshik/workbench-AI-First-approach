## Release Model

This repository follows a release-branch sustaining model.

* `main` contains future development.
* `release/*` branches are cut from `main` and represent deployable sustaining lines.
* `hotfix/*` branches are temporary corrective branches created from a release branch.
* `hotfix/<customer>/*` branches are temporary corrective branches created from a release branch for specific customers.
* `chf/<ticket>-<description>` branches are consolidated hotfix branches that assemble multiple cherry-picks for a single ticket.
* Customer hotfixes are merged into the active release branch.
* Generic fixes may later be cherry-picked into `main`.

---

## Branch & Tag Semantics

| Pattern                      | Meaning                                              |
| ---------------------------- | ---------------------------------------------------- |
| `release/*`                  | Sustained release branch                             |
| `hotfix/<customer>/*`        | Customer-specific corrective work                    |
| `chf/<ticket>-<description>` | Consolidated hotfix assembling multiple cherry-picks |

| Tag Pattern             | Meaning                          |
| ----------------------- | -------------------------------- |
| `v1.0.0-hf1`            | Generic hotfix release           |
| `v1.0.0-<customer>-hf1` | Customer-specific hotfix release |

---

## Typical operations involved in a hotfix release operation for this model

### Step 0: State Rehydration & Sane Defaults
Before any other operation, verify the working tree and initialize your state.

1. Read `CHF-STATE.md` at the repository root to understand your context. If it does not exist, initialize it.
2. Check for `STEER.md`. If it exists, read instructions, adjust, and delete it.
3. Verify clean repository state using `git status`. If the repository has uncommitted changes or is mid-operation, stop and escalate.
4. Run `git fetch --all`.

### Step 1: Start from a release branch

```bash
git checkout release/1.0.0
git pull origin release/1.0.0
```

### Step 2: Create a hotfix branch based on the issue

* For a consolidated hotfix assembling multiple cherry-picks:

```bash
git checkout -b chf/gh-142-dhcp-timeout-fix
```

### Step 3: Inspect and Consolidate Fixes
**If source commits have been identified (CHF mode):**
Inspect each source commit before cherry-picking.

```bash
git show --stat <sha>
git show <sha>
```

Validate that the commit matches the requested fix and does not contain unrelated work. Cherry-pick in dependency order, recording each resulting SHA in `CHF-STATE.md`.

```bash
git cherry-pick <sha>
```

On conflict, trigger the Conflict Halt Rule (Agent Rule 11) immediately.

### Step 4: Test Gate (Default-FAIL Contract)
Run the full test suite using the repository's configured test command (`$CHF_TEST_CMD` if set, otherwise the project default - e.g., `pytest -x -q`).

* If tests **pass**: You MUST write the raw exit code and the last 20 lines of the test execution output into `CHF-STATE.md` to prove execution to the harness. Proceed to step 5.
* If tests **fail**: Determine whether the failures are pre-existing or introduced by the hotfix. New failures introduced by the fix must be resolved. Enter a loop to fix the code, or escalate to the user with the full failure output.

### Step 4.5: Emit stabilized diff request

After cherry-picks are complete and the test gate passes, emit a structured `diff_request` envelope to the orchestrator.

The diffing agent must analyze the stabilized hotfix branch state relative to the base release branch and produce a validated `diff_manifest` for packaging.

### Step 5: Merge back into the release line
Merging the hotfix branch back to the release line can be done using different strategies. Unless specified otherwise by the user or `STEER.md`, you MUST default to the `--no-ff` merge. This ensures the hotfix history remains intact with an explicit merge commit.

### Step 6: Evaluator Handoff
Before tagging or pushing, verify the state of the release branch.

```bash
git log <base>..HEAD
git diff <base>..HEAD --stat
```

Pause execution. Log readiness in `CHF-STATE.md` and instruct the orchestrator to trigger the evaluator. Do not proceed to Step 7 until the evaluator returns a `PASS` signal.

### Step 7: Create a deployable tag

```bash
git tag -a v1.0.0-<customer>-hf1 -m "fix(<scope>): <description> [Fixes: <Issue-ID>]"
```

### Step 8: Push

```bash
git push origin release/1.0.0
git push origin <tag-name>
```

### Step 9: Propagate the fixes to `main`
Identify the exact commits that constitute the hotfix on the release branch.

* If a `--squash` merge was used, target the single squash commit.
* If a `--no-ff` merge was used, target the merge commit using the `-m 1` flag.
* If a `--ff-only` merge was used, target the sequence of individual commits.

```bash
git checkout main
git pull origin main
git cherry-pick <identified-hotfix-commit-ids>
```

Wait for the user or evaluator to handle any merge conflicts. Then verify and push:

```bash
git push origin main
```
