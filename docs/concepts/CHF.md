Suppose we receive a ticket marked severe - `ART-001: Fix the typo in Airtel's branding from "airlet" to "Airtel"`. These are the steps to follow for the CHF process:

1. **Identify the Airtel's exact running state**

  - Locate all active Airtel tenant branches - Airtel maybe running a single version or multiple versions. If single version, the branch could be `tenant/airtel` or in case of multiple versions, it could be something like `tenant/airtel-v1.0.0`, `tenant/airtel-v1.1.0`.
  - Out of these, confirm the exact versions or commits that are live.

2. **Create a dedicated CHF branch per active version**

  - `git checkout -b chf/airtel-branding-fix tenant/airtel` or `git checkout -b chf/airtel-branding-fix tenant/airtel-v1.0.0` (or from the exact deployed tag).
  - This branch should not be off of `main` or `release` as this is Airtel specific issue.
  - Use a clear, descriptive name tied to tenant + fix.

3. **Locate the root of the problem and resolve it**

  - Locate all the locations that is causing the bug and resolve it.
    - In this case, locate all the places that have the misspelling and correct them.
  - Try to keep this change as small and targeted as possible. A focused commit with commit message such as `fix(airtel): correct brand spelling airlet → Airtel`.

4. **Add any other cumulative fixes (if required)**

  - Cherry-pick any other approved, pending patches for Airtel that should ship together into this branch.
  - This is the cumulative part of the Cumulative HotFix.
  - Skip any other newer features or unrelated changes.

5. **Test**

  - Run any unit/integration tests and any Airtel specific tests.
  - Deploy to a staging environment that matches the Airtel setup from the CHF branch.
  - Confirm the issue(s) are resolved (without breaking anything else).

6. **Merge, and tag**

  - Merge the verified CHF branch back into the `tenant/airtel` or `tenant/airtel-v1.0.0`.
  - Create a clear tag (e.g. `v1.0.0-airtel-chf1`).
  - This tag is the deployable artifact - it includes all the previous hotfixes + this.

7. **Build, and deploy**

  - Build the artifact from the updated tag above.
  - In order to reduce the payload size and replace the application as a whole, find out the files that are changed from the previous tag using tools such as `diff` or `rsync`.
  - Package only the changed files with an installation script and a rollback script.
    - Installation script only replaces the changed files while making a backup of them.
    - The rollback script undos the changes from the installation script in case of any issues reported for this hotfix.
  - Deploy to bundle to the Airtel's production environment.
    - This deployment should be staggered so that any issues caused by the hotfix can be caught early on with lesser number of devices affected.

8. **Repeat**

  - Repeat the steps 2-7 for any other branches/versions identified in Step 1.

9. **Backport the fix upstream - only if appropriate**

  - If the issue ART-001 exists in `main` or `release` (the active release branch) too → cherry-pick or PR the fix there to prevent it recurring in future releases or other tenants.
  - If it's purely tenant-specific e.g. Airtel → keep it only in the Airtel lane; no backport needed.
  - Notify Airtel of the patch tags/commits deployed.

Let us tweak the scenario a bit. Let us say that we want to only fix the issue described in the ticket and nothing else. This then becomes a HotFix instead of CHF. Let us say that in the branch created in the Step 2 above - `chf/airtel-branding-fix` - contains not only the branding issue fix but also other fixes. Let us also say that the commit that consists of the branding issue fix also consists of other fixes. One of the ways to sort it out is as follows. These are in place of Steps 3 and 4 above and can be thought of as sub-steps particular to this scenario.

1. **Identify the commit**
  
  - Find the specific commit hash that contains the required fix along with other changes, e.g., `a1b2c3d`.
    
2. **Cherry-pick without committing**
  
    ```bash
    git cherry-pick -n a1b2c3d
    ```
    
  - `-n` (no-commit) applies all changes from the selected commit into the working tree/staging area but does *not* create a commit yet.
    
3. **Apply Surgical Fix**
  
    ```bash
    git restore --staged .        # unstage everything
    git add -p                    # interactively review and stage hunk-by-hunk
    #or
    git add -p <file-path>        # if the exact file containing the change is known
    ```
    
  - `git add -p` lets us interactively go through each change hunk
    - Choosing `y` (yes) on a hunk stages it. Do this only for the specific changes that are required.
    - And, `n` (no) everything else. These won't get staged.
  - If the required fix and another fix are in the *same hunk*, we can use `s` to split the hunk further, or `e` to manually edit it.
    
4. **Verification**
  
    ```bash
    git diff --staged             # confirm only the required changes are staged
    git diff                      # confirm rejected hunks are still unstaged
    ```
    
5. **Clean up**
  
  - Clean up rejected changes using
    
    ```bash
    git restore .                 # discard the unstaged (unwanted) changes
    ```
    
6. **Commit**
  
  - Commit with a clear message
    
    ```bash
    git commit -m "fix: correct Airtel branding typo"
    ```
    
After the above steps, we can continue from the Step 5 of the main scenario.

