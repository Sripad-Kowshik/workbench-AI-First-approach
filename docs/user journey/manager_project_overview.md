## Project Feature — Assisting Managers with Project overview by combining data from GitHub and Jira.

### Guiding Philosophy
Answer three questions managers actually ask, using data that already exists in
GitHub and Jira, with no new manual input beyond what is entered at setup. Every
insight must trace to a real API value. Every AI-assisted inference must be labelled
as such. JQL is used throughout to push filtering server-side and avoid pulling and
processing large issue sets client-side.

---

### Project Setup (Lightweight, Enriched on First Load)

User inputs at creation:
- Project name
- GitHub repo
- Jira board
- Target phase dates: Scope, Development, QA, Release

On creation, immediately auto-populate via JQL:

  Bug auto-suggestion:
    project=MYPROJECT AND issuetype=Bug AND fixVersion="2.1.0"
      AND created >= "2026-03-01" ORDER BY priority DESC
  → Presented as suggestions; user confirms or adjusts selection

  Fix version anchor (secondary reference, not a replacement for user dates):
    GET /rest/api/3/project/{projectKey}/versions
  → Jira fix version due date shown alongside user-entered release target

  GitHub milestone anchor:
    GET /repos/{owner}/{repo}/milestones
  → Milestone due date shown alongside user-entered release target

  Scoping conflict check (run immediately after bug selection):
    issue in (SELECTED_KEYS) AND fixVersion not in ("TARGET_VERSION")
  → Any matched issues flagged as "Scoping conflict: fix version targets a
    different release" before work begins. Pure REST+JQL, zero inference.

---

### Plan vs. Actual Timeline

Managers keep their target dates. The system computes and overlays actuals.
Changelog data is fetched per issue via REST after JQL narrows the issue set.

| Phase        | Target (User)  | Actual (Computed)                             | Source                             |
|--------------|----------------|-----------------------------------------------|------------------------------------|
| Scope        | User date      | Earliest issue created or first branch commit | Jira JQL created ASC + GitHub REST |
| Development  | User date      | First commit on linked branch                 | GitHub REST                        |
| Dev Complete | User date      | Last linked PR merged_at                      | GitHub REST PR endpoint            |
| QA           | User date      | % issues transitioned through QA status       | Jira changelog REST per issue      |
| Release      | User date      | Tag created on branch                         | GitHub REST tags endpoint          |

QA transition tracking via JQL (identifies which issues to pull changelog for):
  project=X AND status changed to "QA" after "2026-04-01"

Reopen rate detection via JQL:
  project=X AND status changed to "In Progress" after "2026-04-15"
    AND status was "Done"

Completion forecast:
- Only shown when 2 or more completed projects exist in the system
- Labelled explicitly: "Forecast based on N completed projects"
- Derived from median cycle time: In Progress → PR Merged, per issue type
  (In Progress timestamp from Jira changelog + PR merged_at from GitHub REST)
- When below threshold: "Not enough history to forecast" — never hidden or omitted

---

### Ownership Mapping (Zero Manual Work)

Pulled automatically. Mapped by email/username once at project setup.

- Jira assignee    → returned in JQL search results by default (fields=assignee)
- GitHub committer → already in collected commit data
- PR author        → already in collected PR data
- PR reviewers     → GET /repos/{owner}/{repo}/pulls/{pr}/reviews

Displayed per linked bug: Jira Owner → Code Committer → PR Reviewer
One row per bug. No forms, no dropdowns, no manual assignment.

---

### Engineering Risk Radar (Prioritised, Not a Flat List)

Displayed as a compact widget. Signals are tiered by confidence and actionability.
Each flag links directly to the offending item, not a summary page.

Tier 1 — Act Now (deterministic, always actionable):

  Broken CI on a linked PR:
  → GET /repos/{owner}/{repo}/commits/{ref}/check-runs
  → Flag any linked open PR where at least one check_run is in failure state

  Jira issue marked Done with zero matched commits:
  → JQL: project=X AND status = "Done" AND issueKey in (PROJECT_ISSUE_KEYS)
  → Cross-reference against matcher results; any issue with no commit match is flagged

Tier 2 — Watch (high signal, moderate noise):

  Stale linked PRs (no review activity beyond configurable threshold, default 48h):
  → PR updated_at from GitHub REST + absence of review events

  Long-running In Progress tickets (beyond project median cycle time):
  → JQL: project=X AND status = "In Progress" AND updated <= "-Nd"
  → Transition timestamp from Jira changelog REST for exact duration

Tier 3 — Informational (useful, noisier):

  Orphan commits (on branch, no linked issue at any confidence tier):
  → Derived from matcher results; no additional API call needed

  Scoping drift (linked issue fix version targets a later release):
  → JQL: issue in (PROJECT_KEYS) AND fixVersion not in ("TARGET_VERSION")
  → Same call as setup check; re-run on each project load

---

### The Three Manager Questions — Answered With Real Data

1. Are we shipping on time?
   → Gantt: user target dates vs. computed actuals + fix version/milestone anchors
   → Forecast only shown when history supports it, with explicit confidence label

2. Is quality slipping?
   → Reopen rate: JQL status transition query + changelog timestamps
   → CI failure rate: GitHub check-runs across all linked PRs
   → Scoping drift count from Tier 3 risk radar

3. Where are the bottlenecks?
   → PR review time: time between PR opened_at and first review submitted_at
   → Time-in-QA: Jira changelog diff between QA transition and Done transition
   → Stale PR and long-running ticket counts from Tier 1/2 radar

---

### Explainability and Trust

Every metric and link displays its derivation:
- "Scope start: first commit on branch — 14 Apr 2026"
- "Dev complete: last linked PR merged — 28 Apr 2026"
- "PR stale: no review in 3 days — last activity 1 May 2026"
- "Issue linked: Explicit Jira key found in commit message"
- "Issue linked: AI-suggested, 74% similarity — confirm or dismiss"

AI-assisted links are never presented as facts. They carry an explicit confirm/
dismiss action. Confirmed links are promoted to "User verified" and treated as
deterministic in all downstream calculations including the Risk Radar.

---

### API Reference Summary

Jira (REST + JQL):
- Issue search with JQL  → GET /rest/api/3/search?jql=...
- Issue changelog        → GET /rest/api/3/issue/{issueId}/changelog
- Fix versions           → GET /rest/api/3/project/{projectKey}/versions
- Board sprints          → GET /rest/agile/1.0/board/{boardId}/sprint

GitHub (REST + GraphQL):
- PR list + merged_at    → GET /repos/{owner}/{repo}/pulls?state=closed
- PR reviews             → GET /repos/{owner}/{repo}/pulls/{pr}/reviews
- Check runs             → GET /repos/{owner}/{repo}/commits/{ref}/check-runs
- Tags                   → GET /repos/{owner}/{repo}/tags
- Milestones             → GET /repos/{owner}/{repo}/milestones
- Cross-references       → GitHub GraphQL: timelineItems > CrossReferencedEvent

---

### Deprioritised (Valid, Not Now)

- Real-time webhooks       → poll on project load first; add webhooks in a later phase
- Full graph database      → a relational links table handles everything above
- Sprint velocity metrics  → Jira already surfaces this natively; avoid duplication
- Forecasting for new      → explicitly gated behind a minimum of 2 completed projects
  installations
