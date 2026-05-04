## Project Feature — Release Execution and Build Intelligence

---

### Strategic Reframe

The feature is not a "build trigger." It is a Release Execution and Build
Intelligence Layer. Your moat is the context you uniquely hold: the mapping
between Jira tickets, commits, project phases, and build outcomes — context
that GitHub and Jira each have only fragments of. Every design decision below
must exploit that context.

One-line summary:
"GitHub runs builds. You ensure those builds are safe, traceable, and actionable."

---

### What to Remove Immediately

- Arbitrary script execution: RCE risk, blocks enterprise adoption, no upside.
- "Support all CI systems": scope trap. Design a thin internal BuildProvider
  interface cleanly, but ship GitHub Actions deeply first. Add Jenkins/CircleCI
  adapters only when real demand exists.

---

### Phase 1 — Pre-Build: The Release Readiness Gate

Goal: Prevent bad builds from ever being triggered.

The Build button is a first-class UX surface. It should communicate its state
precisely — not just disabled/enabled, but why:
  - "Ready to build" — all checks passed
  - "2 PRs not yet merged — see details" — warning, user can override
  - "Base branch CI is failing" — blocked, build disabled

Pre-flight checks (FastAPI runs these before the button activates):

  Check                               API
  ---                                 ---
  All cherry-picked PRs merged?       GET /repos/{owner}/{repo}/pulls/{pr}/  → merged field
  Base branch CI green?               GET /repos/{owner}/{repo}/commits/{ref}/check-runs
  PRs approved (if configured)?       GET /repos/{owner}/{repo}/pulls/{pr}/reviews
  Linked Jira tickets in valid state? GET /rest/api/3/issue/{issueKey}  → status.name

What your app actually knows: PR state, CI status, Jira ticket status.
Do not overstate the check. Be precise in the UI about what was checked.
Surface as SAFE / RISKY / BLOCKED. BLOCKED disables the button. RISKY
shows a confirmation dialog before proceeding.

Environment Mapping:
  - Pass environment (dev | staging | prod) as a workflow_dispatch input.
  - Auto-suggest based on the project phase the user has already set:
    Development phase → Dev, QA phase → Staging, Release phase → Prod.
  - The user can always override.

---

### Phase 2 — Execution: Real-Time Observability

Goal: Show what is happening right now, without over-engineering.

Trigger:
  POST /repos/{owner}/{repo}/actions/workflows/{workflow_id}/dispatches
  Body: { ref: "release-branch", inputs: { environment: "staging", ... } }

Track via GitHub webhooks (workflow_run, check_run) — never polling.
  - GitHub pushes state changes to your FastAPI endpoint.
  - Validate X-Hub-Signature-256 on every incoming request. Non-negotiable.
    One missed validation allows anyone to inject fake build state into your system.
  - FastAPI relays updates to Angular via WebSocket or Server-Sent Events.
  - Angular reacts instantly — no refresh required.

Show in-app:
  - Workflow status: queued / in_progress / success / failure
  - Job-level breakdown: GET /repos/{owner}/{repo}/actions/runs/{run_id}/jobs
  - Per-step status from the jobs response (each step has name + conclusion)
  - Exact name of the failing step
  - Deep-link to the failing step in GitHub (GitHub log URLs support step anchors)

Do NOT build a log streaming viewer. The value-to-complexity ratio is poor.
Deep-linking to the precise failure location in GitHub is the right call.
Revisit log streaming only if users consistently ask for it.

Also surface build status contextually:
  - On the cherry-pick branch view
  - Inside the linked Jira ticket summaries within your app
  Users should never have to hunt for build state.

One-click retry on failure:
  POST /repos/{owner}/{repo}/actions/runs/{run_id}/rerun-failed-jobs

---

### Phase 3 — Post-Build: Closing the Loop

Goal: Make Jira and your app reflect reality automatically, with zero manual work.

#### On Success — Jira Deployment API

Call the Jira Software Deployment API to register a deployment event against
every linked Jira issue. This populates the native Deployments panel on each
Jira issue and ties issues to the exact GitHub Action that shipped them.

  POST /rest/deployments/0.1/bulk
  Body: {
    deployments: [{
      deploymentSequenceNumber: <github_run_id>,
      updateSequenceNumber: <unix_timestamp_ms>,
      issueKeys: ["PROJ-123", "PROJ-124"],
      displayName: "Release 2.4.1 → Staging",
      url: "<github_run_url>",
      lastUpdated: "<ISO 8601 timestamp>",
      state: "successful",
      pipeline: {
        id: "github-actions",
        displayName: "GitHub Actions",
        url: "<repo_url>"
      },
      environment: {
        id: "staging",
        displayName: "Staging",
        type: "staging"
      }
    }]
  }

#### On Failure — LLM Diagnosis + Jira Status Sync

This is the headline differentiating feature. Almost no CI/CD tool explains
failures — they only report them. You already have LLM infrastructure.
Use it here.

Step 1: Identify the failing job and step from the webhook payload or:
  GET /repos/{owner}/{repo}/actions/runs/{run_id}/jobs

Step 2: Fetch the tail of the failing step log:
  GET /repos/{owner}/{repo}/actions/jobs/{job_id}/logs
  (You do not need the full log — 30 to 50 lines from the failure point is enough)

Step 3: Feed the log excerpt to your LLM:
  "This is a CI build log for a release build targeting [environment].
   Explain the failure in 2-3 plain-English sentences and suggest a likely cause."

  Example output:
  "Build failed at unit tests: Missing environment variable DB_HOST in the
   staging config. This typically means the environment secret was not set
   in the GitHub Actions environment for staging."

Step 4: For each linked Jira ticket, do two API calls:

  4a. Fetch valid transitions for this project (do this once at setup, cache it):
      GET /rest/api/3/issue/{issueKey}/transitions
      The transitionId values are NOT standardized across Jira instances.
      Your app must either prompt the user to configure which transition maps
      to "Blocked" during project setup, or fetch and cache the map at that time.

  4b. Transition the ticket:
      POST /rest/api/3/issue/{issueKey}/transitions
      Body: { transition: { id: "<blocked_transition_id>" } }

  4c. Add a comment with the LLM diagnosis + link to the failing step:
      POST /rest/api/3/issue/{issueKey}/comment
      Body: { body: { type: "doc", content: [...] } }   ← Jira uses ADF format

Naming note: Call this "Automated Status Sync on Failure" or "Failure Propagation."
Do NOT call it "Automated Rollback" — that implies code is being reverted.
Using imprecise language with a Manager/Lead user base will cause confusion
and erode trust.

---

### Phase 4 — Audit Trail (Infrastructure, Not a Feature)

Every other long-term capability — build history, health signals, traceability,
filtered views for managers — depends on the BuildRun record. Treat its schema
as infrastructure. Design it carefully. It is far easier to add columns later
than to reconstruct history from GitHub API calls.

BuildRun schema (minimum):

  Field               Source
  ---                 ---
  id                  Internal UUID
  project_id          Your app's project
  branch              Cherry-pick branch name
  commits             List of commit SHAs included
  jira_tickets        List of Jira issue keys
  environment         Passed as workflow input
  triggered_by        Authenticated user
  github_run_id       From workflow_dispatch response or webhook
  status              Updated via webhook (queued/running/success/failure)
  llm_diagnosis       Generated on failure, stored as text
  created_at          Trigger timestamp
  completed_at        Updated via webhook

Powers:
  - Per-project Build History view, filterable by env / status / ticket
  - Full traceability: Jira ticket → commit → PR → build → result
  - Future: lightweight health signals (success rate, avg duration, frequent failures)
    once you have sufficient history. Do NOT build aggregations over fewer than
    ~20 builds — the signal will be noise.

---

### What to Defer

  Feature                         Why Deferred
  ---                             ---
  Slack / email notifications     Jira comments already notify stakeholders.
                                  Adds OAuth + preference management complexity.
                                  Revisit when users ask for it.

  Flaky build detection           Requires historical data you do not have yet.
                                  Revisit once BuildRun table has 20+ records
                                  per project.

  Full log streaming viewer       Poor value-to-complexity ratio.
                                  Deep-link covers the primary use case.

  Jenkins / CircleCI adapters     Design the BuildProvider interface cleanly,
                                  but do not implement adapters until real demand.

---

### Delivery Sequence

  Priority  Feature                                         Effort
  ---       ---                                             ---
  1         Replace script execution with workflow_dispatch Low
  2         Webhook receipt + signature validation          Medium
  3         Real-time status via WebSocket/SSE to Angular   Medium
  4         Job/step breakdown + deep-link on failure       Medium
  5         One-click retry of failed jobs                  Low
  6         Pre-build readiness check + Build button states Medium
  7         Jira transition on failure (Status Sync)        Low
  8         Jira Deployment API on success                  Low
  9         LLM log diagnosis on failure                    Low — fits existing infra
  10        BuildRun record + Build History view            Medium
  11        Contextual build status on branch/ticket views  Low
  12        Health signals and CI/CD dashboard              High — needs history first

Items 7, 8, and 9 have outsized impact relative to their effort. They are also
the features that most directly justify why your app exists alongside GitHub and
Jira. Prioritize them alongside the observability work, not after it.

---

### Revised Verdict on the Original Critique

Original critique: "Not reliable for real DevOps workflows"

  Limitation               Resolution
  ---                      ---
  No pipeline visibility   Job-level status via webhook + GitHub jobs API
  No build logs            Deep-link to exact failing step (log viewer deferred)
  No failure handling      LLM diagnosis + Jira auto-transition on failure
  No environment control   workflow_dispatch inputs with phase-aware auto-suggestion

Revised verdict:
"Reliable for GitHub Actions-based DevOps workflows. Genuinely differentiated
through Jira-native integration and LLM-powered failure diagnosis. Not a build
trigger — a release intelligence layer."
