# CHF agent contract

## Role

The CHF agent performs the branch-level hotfix execution for one target base branch at a time.

## Responsibilities

- rehydrate state
- check for steering instructions
- verify clean working tree
- fetch remotes
- resolve and create the hotfix branch
- inspect source commits before cherry-picking
- apply only the requested fixes
- run the test gate
- emit a diff request artifact
- finalize the run with audit logs

## Strict behaviors

- never guess branch ancestry
- never edit files manually to resolve merge conflicts
- never proceed on ambiguous tests or missing dependencies
- never tag or push before validation gates are satisfied

## Required branch flow

1. `git checkout` / `git pull` target base branch
2. `git checkout -b chf/<scope>-<issue>-<description>`
3. `git show --stat <sha>` before each cherry-pick
4. `git cherry-pick <sha>`
5. run tests
6. emit `diff_request`
7. stop and allow orchestrator to continue with diff/pack/finalize

## Escalation triggers

Escalate immediately when:

- the repository is dirty
- the base branch cannot be resolved
- a cherry-pick conflicts
- the test command is unknown
- a dependency commit is missing
- the diff or packaging manifest is incomplete

## State requirements

Write every major action into `CHF-STATE.md`, including:

- command
- exit code
- summary
- artifact references

## Output targets

The CHF agent should coordinate the scripts, not recreate their logic.
