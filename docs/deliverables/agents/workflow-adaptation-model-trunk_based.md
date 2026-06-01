# workflow-adaptation-model-2.md

## Workflow Model

This repository follows a trunk-based development workflow.

* `main` is the primary integration trunk.
* release state is represented through:

  * tags
  * build artifacts
  * deployment manifests
* long-lived release branches are not assumed.
* hotfixes originate from `main`.
* hotfixes merge directly back into `main`.

---

## Release Model

* `main` contains the continuously integrated platform state.
* `hotfix/*` branches are temporary corrective branches created from `main`.
* `hotfix/<customer>/*` branches are temporary customer-scoped corrective branches.
* `chf/<ticket>-<description>` branches assemble consolidated corrective work prior to integration.
* release artifacts are generated from tagged commits on `main`.

---

## Branch & Tag Semantics

| Pattern                      | Meaning                                         |
| ---------------------------- | ----------------------------------------------- |
| `main`                       | Primary integration trunk                       |
| `hotfix/*`                   | Temporary corrective integration branch         |
| `hotfix/<customer>/*`        | Customer-specific corrective integration branch |
| `chf/<ticket>-<description>` | Consolidated hotfix integration branch          |

| Tag Pattern                   | Meaning                     |
| ----------------------------- | --------------------------- |
| `release-YYYY.MM.DD`          | Release artifact tag        |
| `release-YYYY.MM.DD-hotfix.N` | Corrective release artifact |

---

# CHF Lifecycle Adaptations

## Step 0 — State Rehydration

Replace:

```text
Identify active release/* branch
```

With:

```text
Identify current trunk state from:
- main
- latest release tag
- deployment artifact metadata
```

Validate:

* `main` is clean
* repository is synchronized
* no partial CHF branches already exist

---

## Step 1 — Resolve Working Line

Use:

```text
main
```

as:

* working integration line
* corrective integration source
* propagation target

Do not search for:

* `release/*`

---

## Step 2 — Create CHF Branch

Create CHF branch from `main`.

Example:

```bash
git checkout main
git pull --ff-only
git checkout -b chf/CHF-142-dhcp-fix
```

---

## Step 3 — Resolve Corrective Commits

Identify:

* corrective commits
* dependency commits
* customer-scoped commits

Validate:

* commit minimality
* dependency closure
* unrelated change exclusion

---

## Step 4 — Cherry-pick Corrective Changes

Cherry-pick commits into:

* CHF integration branch

Example:

```bash
git cherry-pick <sha>
```

If conflicts occur:

* stop immediately
* escalate with structured options

---

## Step 5 — Run Diff Analysis

Invoke:

* `AGENTS_diff.md`

Generate:

* diff manifest
* changed file inventory
* rollback candidate inventory

Validate:

* no unrelated changes
* no accidental trunk drift

---

## Step 6 — Run Validation & Tests

Execute:

* unit tests
* integration tests
* customer-specific smoke tests

Validate:

* corrective behavior
* no regressions
* deployment compatibility

---

## Step 7 — Propagation Analysis

Replace:

```text
Determine propagation into:
- release/*
- main
```

With:

```text
Determine whether:
- direct merge into main is sufficient
- additional release tags are required
- deployment artifacts must be regenerated
```

Propagation target is normally:

* `main`

---

## Step 8 — Packaging

Invoke:

* `AGENTS_pack.md`

Generate:

* release artifact
* deployment bundle
* rollback metadata
* checksum manifest

---

## Step 9 — Evaluator Gate

Pause for:

* evaluator validation
* operational review
* deployment approval

Do not proceed if:

* unrelated drift exists
* rollback metadata is incomplete
* test results are ambiguous

---

## Step 10 — Merge CHF

Merge CHF branch into:

* `main`

Example:

```bash
git checkout main
git merge --no-ff chf/CHF-142-dhcp-fix
```

---

## Step 11 — Release Artifact Finalization

Create:

* release tag
* deployment artifact
* release manifest

Example:

```bash
git tag release-2026.05.07-hotfix.1
```

---

## Step 12 — Rollout Coordination

Deploy progressively:

1. canary device
2. customer validation
3. staged rollout
4. fleet-wide rollout

Track:

* telemetry
* rollback readiness
* deployment health

---

## Step 13 — Close CHF

Update:

* `CHF-STATE.md`
* `HOTFIX-HISTORY.md`

Record:

* release tag
* source SHAs
* deployment artifact IDs
* rollback references
