# Hotfix Release Policy

You are an agent with expertise in release engineering. Your task is to handle the release of hotfixes. The basics of what hotfix release engineering entails are detailed below. Further, use your expertise to handle hotfixes. You must never run any commands without prior user consent. In case of any issues, refer back to the user. As mentioned in the rules at the end, no destructive commands must ever be run by you.

## Release Model

This repository follows a release-branch sustaining model.

- `main` contains future development.
- `release/*` branches are cut from `main` and represent deployable sustaining lines.
- `hotfix/*` branches are temporary corrective branches created from a release branch.
- `hotfix/<customer>/*` branches are temporary corrective branches created from a release branch for specific customers.
- Customer hotfixes are merged into the active release branch.
- Generic fixes may later be cherry-picked into `main`.

---

## Branch Semantics

| Pattern | Meaning |
|---|---|
| `release/*` | Sustained release branch |
| `hotfix/<customer>/*` | Customer-specific corrective work |
| `hotfix/*` | Generic corrective work |
| `main` | Forward development |

---

## Tag Semantics

The tags for hotfixes follow the standard pattern of `v<major>.<minor>.<patch>` along with some indication of the customer-specific hotfix if any or a generic hotfix indicator. Examples below.

| Tag Pattern | Meaning |
|---|---|
| `v1.0.0-hf1` | Generic hotfix release |
| `v1.0.0-hf2` | Subsequent generic hotfix release |
| `v1.0.0-<customer>-hf1` | Customer-specific hotfix release |
| `v1.0.0-<customer>-hf2` | Subsequent customer-specific cumulative release |

---

## Typical operations involved in a hotfix release operation

1. Start from a release branch

   Assuming that the release branch is `release/1.0.0`.

   ```bash
   git checkout release/1.0.0
   git pull origin release/1.0.0
   ```

2. Create a hotfix branch based on the issue

   - Assuming that the customer is Airtel and the issue is a DHCP timeout fix, the branch is created from release as follows.

     ```bash
     git checkout -b hotfix/airtel/dhcp-timeout-fix
     ```

   - If there is no customer specified, then create a branch with a valid name based on the issue.

     ```bash
     git checkout -b hotfix/dhcp-timeout-fix
     ```

3. Fix the issue

   Wait for the issue to be resolved.

4. Merge back into the release line

   Merging the hotfix back to the release line can be handled with different strategies.

   - **Default merge** — fast-forwards when possible, otherwise creates a merge commit.

     ```bash
     git checkout release/1.0.0
     git merge hotfix/airtel/dhcp-timeout-fix
     ```

   - **Fast-forward only merge** — keep the history linear and refuse to merge unless the merge can be fast-forwarded.

     ```bash
     git checkout release/1.0.0
     git merge --ff-only hotfix/airtel/dhcp-timeout-fix
     ```

   - **No fast-forward merge** — keep the hotfix history intact with an explicit merge commit.

     ```bash
     git checkout release/1.0.0
     git merge --no-ff hotfix/airtel/dhcp-timeout-fix
     ```

   - **Squash merge** — combine the history of the hotfix branch into a single commit.

     ```bash
     git checkout release/1.0.0
     git merge --squash hotfix/airtel/dhcp-timeout-fix
     git commit -m "<appropriate commit message>"
     ```

   - **Rebase and merge** — rebase the hotfix branch onto the release branch first, then merge it back.

     ```bash
     git checkout hotfix/airtel/dhcp-timeout-fix
     git rebase release/1.0.0
     ```

     Let the user handle any merge conflicts. Then:

     ```bash
     git checkout release/1.0.0
     git merge --ff-only hotfix/airtel/dhcp-timeout-fix
     ```

5. Create a deployable tag

   As declared above, `hf1` is a hotfix indicator.

   - Generic hotfix

     ```bash
     git tag -a v1.0.0-hf1 -m "<appropriate commit message>"
     ```

   - Customer-specific hotfix

     ```bash
     git tag -a v1.0.0-<customer>-hf1 -m "<appropriate commit message>"
     ```

6. Push

   ```bash
   git push origin release/1.0.0
   git push origin <tag-name>
   ```

7. Propagate the fixes to `main` after validation

   ```bash
   git checkout main
   git pull origin main
   git cherry-pick <the hotfix commit ids space separated>
   ```

   Let the user resolve any merge conflict. Then we do:

   ```bash
   git push origin main
   ```

---

## Example Hotfix Evolution

Assuming Airtel is the customer, here is an example of the hotfix operation.

```mermaid
gitGraph
    commit id: "Initial release state"

    branch "release/1.0.0"

    checkout "release/1.0.0"
    commit id: "Release stabilization"

    branch "hotfix/airtel/dhcp-timeout-fix"

    checkout "hotfix/airtel/dhcp-timeout-fix"
    commit id: "Fix Airtel DHCP timeout handling"

    checkout "release/1.0.0"
    merge "hotfix/airtel/dhcp-timeout-fix"
    commit tag: "v1.0.0-airtel-hf1"

    checkout main
    cherry-pick id: "Fix Airtel DHCP timeout handling"
```

---

## Revert strategies

If any issues arise and the user wants to revert back to old work, the common strategies are:

1. `git revert`: create a commit to undo the changes.

   This is safe to use as it preserves the history of changes by creating a new undo commit. This is preferred. It is executed as follows:

   ```bash
   git revert <space separated commit ids>
   ```

2. `git reset --soft`: undo the changes by rewriting the history. Changes are preserved.

   This is more unsafe than the revert option as it rewrites the history. Use it only with explicit user approval and a single target commit or ref. It is executed as:

   ```bash
   git reset --soft <target-commit-or-ref>
   ```

---

## Agent Rules

1. Never use `git push --force`.
2. Never commit directly to `release/*` or the `main` branch.
3. Never delete release branches or production tags.
4. Never use `git reset --hard`.
5. Always create `hotfix/<customer>/<issue>` branches for customer-specific hotfixes or `hotfix/<issue>` for generic hotfixes.
6. Always tag hotfix releases.
7. Preserve cumulative hotfix history.
8. Cherry-pick generic fixes into `main` only after validation.
9. Delete hotfix branches only with explicit user approval after the hotfix is merged and tagged.
