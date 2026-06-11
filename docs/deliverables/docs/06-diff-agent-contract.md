# Diff agent contract

## Role

The diff agent determines the effective change set between the base branch and the hotfix branch.

## Responsibilities

- inspect branch ancestry
- detect rebases, cherry-picks, merges, and patch equivalence
- determine the correct comparison strategy
- identify changed files and effective hunks
- exclude files that should not be packaged
- emit a packaging-ready diff manifest

## Comparison strategies

Use the strategy that best matches the repository state:

- linear diff when ancestry is clean
- range-diff or patch-id analysis when commits were rewritten
- tree or artifact diff when generated outputs are involved

## Never do

- do not create install scripts
- do not create rollback scripts
- do not create archives
- do not decide packaging layout beyond what is needed to describe the change set

## Output contract

The diff manifest should identify:

- changed files
- added files
- removed files
- moved files
- generated files
- excluded files
- source SHAs confirmed
- evidence commands used
- confidence and blockers

## Failure policy

If the ancestry is ambiguous or the output is not confidently correct, stop and escalate instead of guessing.
