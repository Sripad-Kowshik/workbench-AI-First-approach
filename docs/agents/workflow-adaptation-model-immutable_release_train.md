# workflow-adaptation-model-7.md

## Workflow Model

This repository follows an immutable release train workflow.

* `main` contains future train development.
* release trains are immutable snapshots.
* releases are represented through:

  * train tags
  * deployment manifests
  * train artifacts
* emergency remediation may use temporary hotfix train branches.

---

## Release Model

* `main` contains future train development.
* train snapshots represent deployable release trains.
* `hotfix-train/*` branches are temporary emergency remediation branches.
* `hotfix/<customer>/*` branches are customer-scoped remediation branches.
* `chf/<ticket>-<description>` branches assemble consolidated corrective work for train remediation.
* fixes propagate into:

  * future train cuts
  * emergency train artifacts
  * scheduled train snapshots

---

## Branch & Tag Semantics

| Pattern                      | Meaning                               |
| ---------------------------- | ------------------------------------- |
| `main`                       | Future train development line         |
| `hotfix-train/*`             | Emergency remediation branch          |
| `hotfix/<customer>/*`        | Customer remediation branch           |
| `chf/<ticket>-<description>` | Consolidated train remediation branch |

| Tag Pattern              | Meaning                     |
| ------------------------ | --------------------------- |
| `train-YYYY.MM`          | Immutable release train     |
| `hotfix-train-YYYY.MM.N` | Emergency remediation train |

---

# CHF Lifecycle Adaptations

## Step 0 — State Rehydration

Replace:

```text
Identify active release/* branch
```

With:

```text
Identify:
- active production train
- latest scheduled train
- active emergency train if present
```

Validate:

* train topology consistency
* immutable train integrity
* deployment manifest alignment

---

## Step 1 — Resolve Working Train

Determine:

* affected production train
* remediation train target
* future train propagation targets

Examples:

```text
train-2026.05
hotfix-train-2026.05.2
```

---

## Step 2 — Create CHF Branch

Create CHF remediation branch from:

* active train snapshot
* active emergency train

Example:

```bash
git checkout train-2026.05
git checkout -b chf/CHF-142-dhcp-fix
```

---

## Step 3 — Resolve Corrective Commits

Identify:

* corrective commits
* dependency commits
* train-specific compatibility requirements

Validate:

* train compatibility
* artifact integrity
* rollback viability

---

## Step 4 — Cherry-pick Corrective Changes

Cherry-pick commits into:

* CHF remediation branch

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

* train remediation manifest
* deployment delta
* rollback inventory

Validate:

* train integrity
* no unrelated train drift
* immutable artifact consistency

---

## Step 6 — Run Validation & Tests

Execute:

* train compatibility validation
* deployment smoke tests
* rollback simulation
* operational validation

Validate:

* train stability
* remediation correctness
* artifact reproducibility

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
Determine propagation into:
- future train snapshots
- emergency remediation trains
- next scheduled train cut
```

Propagation into:

* `main`

depends on:

* workflow policy
* train strategy
* release governance

---

## Step 8 — Packaging

Invoke:

* `AGENTS_pack.md`

Generate:

* emergency train artifact
* deployment manifest
* rollback bundle
* checksum inventory

---

## Step 9 — Evaluator Gate

Pause for:

* train governance review
* operational signoff
* deployment approval

Do not proceed if:

* train integrity is unclear
* rollback metadata is incomplete
* artifact reproducibility fails

---

## Step 10 — Finalize Remediation Train

Finalize:

* emergency train artifact
* immutable remediation tag
* deployment manifest

Example:

```bash
git tag hotfix-train-2026.05.2
```

---

## Step 11 — Future Train Propagation

Determine whether fixes must propagate into:

* next scheduled train
* future train snapshots
* future release manifests

Execute:

* cherry-pick
* merge
* train regeneration

as defined by workflow policy.

---

## Step 12 — Rollout Coordination

Deploy progressively:

1. canary device
2. operational validation
3. staged deployment
4. broader train rollout

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

* train identifiers
* remediation artifacts
* deployment manifests
* rollback references
