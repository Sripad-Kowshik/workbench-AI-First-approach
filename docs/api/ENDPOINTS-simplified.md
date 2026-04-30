# API Endpoints — Simplified

This document provides a non-technical, easy-to-read summary of the backend API endpoints. For each endpoint you'll find the HTTP method and path, a short plain-language description, and the typical successful result or common errors.

## OAuth

- GET /auth/github/login: Start GitHub login (opens GitHub sign-in). Success: browser redirected to GitHub. Error: shows an error page if parameters missing.
- GET /auth/github/callback: GitHub returns here after login. Success: user redirected back to the app. Error: shows message when login failed.
- GET /auth/github/status: Check if GitHub is connected. Success: { connected: true | false, user_identity: value|null }.
- DELETE /auth/github/revoke: Disconnect GitHub. Success: { revoked: true } or { revoked: false, detail: "No active GitHub connection." }.

- GET /auth/jira/login: Start Jira login (redirects to Atlassian). Success: redirect. Error: parameter or flow errors.
- GET /auth/jira/callback: Jira returns here after login. Success: user redirected back. Error: message when login failed.
- GET /auth/jira/status: Check Jira connection. Success: { connected: true|false, user_identity, cloud_id }.
- DELETE /auth/jira/revoke: Disconnect Jira. Success: { revoked: true }.

- GET /auth/status: Overall OAuth status across providers. Success: summary of connected providers.

## GitHub Integration

- GET /github/issues: List stored GitHub issues for a repository. Success: { total_issues, issues: [...] }. Errors: 400 if repo not specified; 500 for server/plugin errors.
- GET /github/commits: List commits stored for a repository. Success: { total_commits, commits: [...], repo_key }. Errors: 400 if repo missing; 500 for server errors.
- GET /github/patches: List pull request patches. Success: { total_patches, patches: [...] }. Errors: 400/500 as above.
- GET /github/branches: List branches. Success: { total_branches, branches: [...] }. Errors: 400/500.
- GET /github/tags: List tags. Success: { total_tags, tags: [...] }. Errors: 400/500.
- GET /github/compare: Compare branches. Success: summary with commits and file changes. Errors: 400 if compare branch missing; 500 on API failure.
- POST /github/merge-commits: Merge selected commits into a base branch. Success: { status: "success", message, merged_commits }. Errors: 4xx/5xx if merge fails or fields missing.
- GET /github/commit-diff: Get diff for a commit. Success: { sha, files, diff }. Errors: 400/404/500 depending on inputs and fetch outcome.

## Jira Integration

- GET /jira/issues: Fetch stored Jira issues for a project. Success: { total_issues, issues: [...] }. Errors: 500 if credentials missing or fetch fails.

## LLM / AI

- GET /llm/generate_gh_branch_name: Ask AI to suggest a Git branch name for a GitHub issue. Success: plugin response, e.g. { branch_name: "..." }. Errors: 400 if repo missing; 500 for plugin errors.
- POST /llm/generate_jira_branch_name: Generate branch names for Jira keys. Success: list of generated names. Errors: 500 for plugin errors.
- GET /llm/generate-pitfall-suggestions: Get AI suggestions for commit pitfalls. Success: { pitfalls: [...] }. Errors: 500 on plugin error.
- GET /llm/match_gh_commit_gh_issues: Match commits to GitHub issues. Success: plugin-defined matches. Errors: 500 on plugin error.
- POST /llm/match_gh_commit_jira_issues: Match commits to Jira issues. Success: match results list. Errors: 400/500 depending on missing repo or plugin error.
- GET /llm/gh-cherry-pick-commits and POST /llm/jira-cherry-pick-commits: Create branch with selected commits (AI-assisted). Success: returns helper result (status success or error). Errors: 400/422 when inputs missing; 500 for unexpected failures.

- GET /ai/pr-eval and GET /ai/jira-eval: Return or trigger AI evaluations for PRs or Jira issues. Success: { evaluations: [...] }. Errors: 400 if repo missing; 500 on unexpected errors.

## Build

- GET /build/gh_actions: Trigger GitHub Actions runs per configured build settings. Success: { dispatched: true, workflow_ids: [...] }. Errors: 500 if build config or dispatch fails.

## Workbench / Project Management

- POST /workbench/insert-new-product: Add a product. Success: { info: "Inserted product details to database." }. Errors: 400 if already exists; 500 on failure.
- DELETE /workbench/delete-product: Delete product by value. Success: { info: "Deleted product from database." }. Errors: 400/404/500 depending on missing product or DB issues.
- GET /workbench/get-all-products: List products. Success: { products: [...] }. Errors: 404 if table missing.

- POST /workbench/insert-project-details: Add project details. Success: { info: "Inserted project details to database." }. Errors: 400/404/500 depending on validation or DB issues.
- POST /workbench/insert-project-jira-bugs: Link Jira bugs to a project. Success: { info: "Inserted jira bugs for project details to database." }. Errors: 500 on failure.
- GET /workbench/update-project-status: Update a project's status. Success: { info: "Successfully updated the project status." }. Errors: 400/404/500.
- GET /workbench/get-project-jira-bugs: Get linked Jira bugs for a project. Success: { jira_bugs: [...] }. Errors: 400/404.
- DELETE /workbench/delete-project-jira-bug and DELETE /workbench/delete-project-details: Delete bug or project. Success: info messages. Errors: 400/404/500 as appropriate.
- GET /workbench/get-all-project-details: Get all projects and their Jira bugs. Success: list of projects. Errors: 404 if none exist.

- GET /workbench/available-repos: List accessible GitHub repos. Success: { repositories: [...], total: n }. Errors: 500 on fetch failure.
- GET /workbench/available-jira-boards: List accessible Jira projects. Success: { boards: [...], total: n }. Errors: 500 on fetch failure.

- GET /workbench/license/verify: Check current license. Success: license status JSON. Errors: 404 if status not available.

- POST/GET/DELETE /workbench/config/github/tokens and /workbench/config/jira/tokens: Manage saved GitHub/Jira tokens. Success: returns token entry summaries. Errors: 500 for validation or saving errors.

## Analytics / Metrics

- GET /analytics/developers/performance: Get weekly developer activity for a person. Success: metadata + metrics such as commits/prs. Errors: 502 when analytics service fails; 500 on unexpected errors.
- GET /analytics/developers/metrics and GET /analytics/qa/metrics: Developer/QA metrics for a person. Success: metrics object. Errors: 502/500.
- POST /metrics/dev/run and POST /metrics/qa/run: Trigger metrics computation for dev or QA. Success: { status: "ok", results: {...} }. Errors: 500 on failure.

## HR

- POST /hr/reconcile/run: Upload HR CSVs or ask the system to fetch HR data, then reconcile identities. Success: { imported_people, persisted, candidates }. Errors: 400/422/500 for bad files or processing errors.
- GET /hr/ingestion/run and GET /hr/ingestion/reconcile: Run ingestion and reconciliation pipelines. Success: counts and summaries (imported_people, scanned, persisted, candidates_sample). Errors: 400/422/500.
- GET /hr/reconcile/get_reconciled_users: List reconciled users (optionally filtered). Success: { users: [...] }. Errors: 422/500.
- GET /hr/levels, /hr/teams, /hr/functional_managers, /hr/reporting_managers, /hr/managers: Return simple lists of organizational levels, teams, or managers. Success: lists like { levels: [...] } or { managers: [...] }. Errors: 422/500.

## User Data

- POST /user_data/upload: Upload a CSV of user data. Success: { id, filename, uploadedAt, rows }. Errors: 400/422/500 on invalid upload or processing.
- GET /user_data/files: List uploaded files. Success: { files: [...] }. Errors: 500.
- GET /user_data/files/{file_id}: Get a specific file's content/metadata. Success: { filename, data: [...] }. Errors: 422/500.
- DELETE /user_data/files/{file_id}: Delete an uploaded file. Success: { success: true, message }. Errors: 422/500.

## Workbench UI / Review Forms

- POST /workbench/config/ui/review_form: Save a review-form configuration for the UI. Success: { ui_key, info }. Errors: 400/500.
- GET /workbench/config/ui/review_forms: List saved forms. Success: { forms: [...] }.
- GET /workbench/config/ui/review_form/{ui_key}: Get a specific form. Success: form JSON or 404 if not found.
- POST /workbench/review_form/submit and POST /workbench/manager_review/submit: Submit a completed review. Success: { status: "submitted", id, message }. Errors: 400/500.
- POST /workbench/review_form/save_draft and POST /workbench/manager_review/save_draft: Save a draft. Success: { status: "saved", draft_id }.
- GET /workbench/review_form/get, /workbench/review_form/drafts, /workbench/review_form/final_score and manager equivalents: Retrieve drafts, final scores, or specific reviews. Success: appropriate objects; Errors: 404 when not found.
