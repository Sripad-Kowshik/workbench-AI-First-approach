# API Endpoints Specification

A comprehensive list of API endpoints provided by the Workbench backend, organized by category for AI agents and human users. Each endpoint includes its HTTP method, path, description, expected request parameters/body, response format, and potential error responses.

## OAuth (/auth/*)

`GET /auth/github/login`

- Description: Initiate GitHub OAuth flow (redirect to GitHub)
- Request body:
  - request: Request (required) - FastAPI Request object
- Response:
  - 302 Redirect - Redirect to GitHub OAuth URL

`GET /auth/github/callback`

- Description: GitHub OAuth callback
- Request body:
  - request: Request (required) - FastAPI Request object
  - code: string (optional, query parameter) - Authorization code from GitHub
  - state: string (optional, query parameter) - State parameter for CSRF protection
  - error: string (optional, query parameter) - Error code from GitHub
  - error_description: string (optional, query parameter) - Error description from GitHub
- Response:
  - 302 Redirect - Redirect to GitHub OAuth URL or frontend page based on success/failure
- Errors:
  - 400 Bad Request - Missing or invalid parameters

`GET /auth/github/status`

- Description: GitHub connection status
- Response:
  - 200 OK - GitHub connection status

  ```json
  {
    "connected": true,
    "user_identity": "<user>"
  }
  ```

  or
  
  ```json
  {
    "connected": false,
    "user_identity": null
  }
  ```

`DELETE /auth/github/revoke`

- Description: Revoke GitHub OAuth token
- Response:
  - 200 OK - GitHub OAuth token revoked
  
  ```json
  {
    "revoked": true,
    "provider": "github"
  }
  ```

  or

  ```json
  {
      "revoked": false,
      "detail": "No active GitHub connection."
  }
  ```

`GET /auth/jira/login`

- Description: Initiate Jira OAuth flow (redirect to Atlassian)
- Request body:
  - request: Request (required) - FastAPI Request object
- Response:
  - 302 Redirect - Redirect to Atlassian OAuth URL

`GET /auth/jira/callback`

- Description: Jira OAuth callback
- Request body:
  - request: Request (required) - FastAPI Request object
  - code: string (optional, query parameter) - Authorization code from Jira
  - state: string (optional, query parameter) - State parameter for CSRF protection
  - error: string (optional, query parameter) - Error code from Jira
  - error_description: string (optional, query parameter) - Error description from Jira
- Response:
  - 302 Redirect - Redirect to Jira OAuth URL or frontend page based on success/failure
- Errors:
  - 400 Bad Request - Missing or invalid parameters

`GET /auth/jira/status`

- Description: Jira connection status
- Response:
  - 200 OK - Jira connection status

  ```json
  {
    "connected": true,
    "user_identity": "<user>",
    "cloud_id": "<cloud_id>"
  }
  ```

  or
  
  ```json
  {
    "connected": false,
    "user_identity": null,
    "cloud_id": null
  }
  ```

`DELETE /auth/jira/revoke`

- Description: Revoke Jira OAuth token
- Response:
  - 200 OK - Jira OAuth token revoked
  
  ```json
  {
    "revoked": true,
    "provider": "jira"
  }
  ```

`GET /auth/status`

- Description: Combined OAuth status for all providers
- Response:
  - 200 OK - Combined OAuth status

## GitHub Integration (/github/*)

`GET /github/issues`

- Description: Fetch GitHub issues for a repository (reads from DB)
- Query parameters:
  - `owner`: string (optional) - repo owner
  - `repo`: string (optional) - repo name
  - `repo_key`: string (optional) - owner/repo combined
-- Response:
  - 200 OK - application/json:

  ```json
  {
    "total_issues": 2,
    "issues": [
      {
        "id": 1,
        "milestone_id": null,
        "repository_id": 10,
        "user_id": 5,
        "body": "Issue body",
        "closed_at": null,
        "created_at": "2025-01-01T00:00:00Z",
        "locked": false,
        "number": 123,
        "pull_request": false,
        "state": "open",
        "title": "Sample issue",
        "updated_at": "2025-01-01T01:00:00Z"
      }
    ]
  }
  ```

- Errors:
  - 400 Bad Request - when no repo identifier provided (returns {"error": "Missing repository. Provide 'owner' and 'repo' or 'repo_key'."})
  - 500 Internal Server Error - when token is missing, plugin/db fetch fails, or unexpected exception (returns {"error": "< message >"})

`GET /github/commits`

- Description: Fetch commits stored for a repository
- Query parameters:
  - `owner`: string (optional) - repo owner (if provided, `repo` must also be provided)
  - `repo`: string (optional) - repo name (if provided, `owner` must also be provided)
  - `repo_key`: string (optional) - combined owner/repo (alternative to providing `owner`+`repo`)
  - `id`: list[str] (optional) - filter by commit id(s) or ranges
  - `days`: int (optional, default=30) - time window
-- Response:
  - 200 OK - application/json:

  ```json
  {
    "total_commits": 3,
    "commits": [
      {
        "id": "1",
        "sha": "abc123",
        "author": "alice",
        "message": "Fix bug",
        "date": "2025-01-01",
        "files_changed": 2,
        "total_additions": 10,
        "total_deletions": 2,
        "total_changes": 12,
        "changed_files": [ { "filename": "src/app.py", "additions": 5, "deletions": 0 } ],
        "file_patches": []
      }
    ],
    "created_at": null,
    "repo_key": "owner/repo"
  }
  ```

- Errors:
  - 400 Bad Request - when no repo identifier provided; also the code maps ValueError to a 400 with message "Invalid ID format provided" when ID parsing fails
  - 500 Internal Server Error - when token is missing, fetch fails, JSON parsing errors, or other exceptions (returns {"error": "< message >"})

`GET /github/patches`

- Description: Fetch PR patches (pull requests) for a repository
- Query parameters:
  - `owner`: string (optional) - repo owner (if provided, `repo` must also be provided)
  - `repo`: string (optional) - repo name (if provided, `owner` must also be provided)
  - `repo_key`: string (optional) - combined owner/repo (alternative to providing `owner`+`repo`)
  - `days`: int (optional, default=30) - time window
-- Response:
  - 200 OK - application/json:

  ```json
  {
    "total_patches": 1,
    "days": 30,
    "patches": [
      {
        "pr_number": 123,
        "title": "Add feature",
        "state": "merged",
        "merged": true,
        "created_at": "2025-01-01T00:00:00Z",
        "author": "bob"
      }
    ],
    "created_at": null,
    "repo_key": "owner/repo"
  }
  ```

- Errors:
  - 400 Bad Request - when no repo identifier provided (returns {"error": "Missing repository. Provide 'owner' and 'repo' or 'repo_key'."})
  - 500 Internal Server Error - when token is missing, plugin/github fetch fails, DB read/parsing errors, or other exceptions (returns {"error": "< message >"})

`GET /github/branches`

- Description: List branches for a repository
- Query parameters:
  - `owner`: string (optional) - repo owner (if provided, `repo` must also be provided)
  - `repo`: string (optional) - repo name (if provided, `owner` must also be provided)
  - `repo_key`: string (optional) - combined owner/repo (alternative to providing `owner`+`repo`)
-- Response:
  - 200 OK - application/json:

  ```json
  {
    "total_branches": 2,
    "branches": [ { "name": "main" }, { "name": "develop" } ]
  }
  ```

- Errors:
  - 400 Bad Request - when no repo identifier provided
  - 500 Internal Server Error - when token is missing, plugin fetch fails, or other exceptions (may return {"error": "Failed to fetch branches from GitHub."} or {"error": "< message >"})

`GET /github/tags`

- Description: List tags for a repository
- Query parameters:
  - `owner`: string (optional) - repo owner (if provided, `repo` must also be provided)
  - `repo`: string (optional) - repo name (if provided, `owner` must also be provided)
  - `repo_key`: string (optional) - combined owner/repo (alternative to providing `owner`+`repo`)
-- Response:
  - 200 OK - application/json:

  ```json
  {
    "total_tags": 1,
    "tags": [ { "name": "v1.0.0" } ]
  }
  ```

- Errors:
  - 400 Bad Request - when no repo identifier provided
  - 500 Internal Server Error - when token is missing, plugin fetch fails, or other exceptions (returns {"error": "Failed to fetch tags"} or {"error": "< message >"})

`GET /github/compare`

- Description: Compare two branches using GitHub API
- Query parameters:
  - `owner`, `repo` or `repo_key`
  - `base_branch`: string (default: "default" → resolved to repo default)
  - `compare_branch`: string (required)
-- Response:
  - 200 OK - application/json:

  ```json
  {
    "base_branch": "main",
    "compare_branch": "feature/x",
    "total_commits": 5,
    "behind_by": 2,
    "commits": [ { "sha": "abc123", "short_sha": "abc1234", "message": "Fix", "author_name": "alice", "date": "2025-01-01" } ],
    "file_changes": [ { "filename": "src/app.py", "status": "modified", "additions": 10, "deletions": 2 } ]
  }
  ```

- Errors:
  - 400 Bad Request - when `compare_branch` is missing (returns {"error": "Compare branch must be specified"}) or when repo identifier is missing
  - 500 Internal Server Error - when the GitHub API request fails or other exceptions occur (requests.exceptions.RequestException and other exceptions return {"error": "< message >"})

`POST /github/merge-commits`

- Description: Merge selected commits into a base branch (creates temp branch, cherry-picks, merges)
- Request body (form):
  - `base_branch`: string (form, default="default")
  - `selected_commits`: list[str] (form) - commit SHAs to merge
  - repo identification via query (`owner`/`repo`/`repo_key`) via dependency
-- Response:
  - 200 OK - application/json:

  ```json
  {
    "status": "success",
    "message": "Successfully merged 2 commits",
    "merged_commits": [ "abc123", "def456" ]
  }
  ```

- Errors:
  - 400 Bad Request - when no repo identifier provided
  - 422 Unprocessable Entity - missing required form fields (handled by FastAPI validation)
  - 4xx/5xx - non-exception GitHub merge failures are forwarded with the GitHub HTTP status code and JSON payload { "status": "error", "message": "Merge failed with status < code >" }
  - 500 Internal Server Error - on requests.exceptions.RequestException or other unexpected exceptions (returns { "status": "error", "message": "< message >" })

`GET /github/commit-diff`

- Description: Fetch diff details for a commit SHA
- Query parameters: `commit_sha` (required), `owner`/`repo`/`repo_key`
-- Response:
  - 200 OK - application/json:

  ```json
  {
    "sha": "abc123",
    "files": [ { "filename": "file.py", "status": "modified", "additions": 10, "deletions": 2 } ],
    "diff": "@@ -1,4 +1,6 @@\n+..."
  }
  ```

- Errors:
  - 400 Bad Request - when no repo identifier provided
  - 404 Not Found - when `fetch_commit_diff` returns an error (the handler raises HTTPException 404 with detail from the plugin; response body: {"error": "< message >"})
  - 500 Internal Server Error - when token is missing or other exceptions occur (handler raises HTTPException 500; response body: {"error": "< message >"})

## Jira Integration (/jira/*)

`GET /jira/issues`

- Description: Fetch Jira issues for a project (uses stored credentials or OAuth)
- Query parameters / dependencies:
  - `project_key` and `base_url` (provided together via `JiraProjectKey` dependency)
  - `max_results`: int (default=1000)
  - `filter_hotfix`: bool (optional)
- Response:
  - 200 OK - application/json:

  ```json
  {
    "total_issues": 2,
    "issues": [
      {
        "id": "PROJ-123",
        "summary": "Example issue",
        "status": "Open",
        "assignee": "alice",
        "created_at": "2025-01-01T00:00:00Z"
      }
    ]
  }
  ```

- Errors:
  - 500 Internal Server Error - when no Jira credentials are found.
    - Example body: { "error": "No Jira credentials found/available." }
  - 500 Internal Server Error - when the Jira plugin raises an exception while fetching.
    - Example body: { "error": "Exception while fetching Jira issues" }
  - 500 Internal Server Error - when the plugin returns a falsy result (fetch failed).
    - Example body: { "error": "Failed to fetch issues from Jira" }
  - 500 Internal Server Error - any other unexpected exception is caught and returned as:
    - Example body: { "error": "< message >" }

## LLM / AI (/llm/*, /ai/*)

`GET /llm/generate_gh_branch_name`

- Description: Generate a branch name for a GitHub issue via the LLM plugin
- Query parameters:
  - `issue_number`: int (required)
  - `owner`: string (optional) - repo owner (if provided, `repo` must also be provided)
  - `repo`: string (optional) - repo name (if provided, `owner` must also be provided)
  - `repo_key`: string (optional) - combined owner/repo (alternative to providing `owner`+`repo`)
- Response:
  - 200 OK - returns the plugin response (plugin-defined shape, e.g. { "branch_name": "..." })
- Errors:
  - 400 Bad Request - when `github` dependency is missing.
    - Example: { "error": "Missing repository. Provide 'owner' and 'repo' or 'repo_key'." }
  - 400 Bad Request - when repo info cannot be resolved (invalid repo info).
    - Example: { "error": "Invalid repository information provided" }
  - 500 Internal Server Error - when the LLM plugin returns an object containing `"error"` (handler forwards with status 500).

`POST /llm/generate_jira_branch_name`

- Description: Generate branch names for Jira issue keys
- Request body (JSON): single `{ "issue_key": "PROJ-123" }` or list of such objects
- Query / dependencies:
  - `project_key`: (implicit dependency `JiraProjectKey`) - requires both `project_key` and `base_url` when supplied; otherwise optional
  - `project_name`: string (optional)
- Response:
  - 200 OK - returns plugin response (e.g. { "generated": [ { "issue_key": "PROJ-123", "branch_name": "..." } ] })
- Errors:
  - 500 Internal Server Error - when the LLM plugin returns an object containing `"error"` (handler forwards with status 500).

`GET /llm/generate-pitfall-suggestions`

- Description: Return pitfall suggestions for a commit using LLM
- Query parameters:
  - `commit_sha`: string (required)
  - `project_id`: string (optional)
- Response:
  - 200 OK - returns plugin response (e.g. { "pitfalls": [ ... ] })
- Errors:
  - 500 Internal Server Error - when the plugin response contains `"error"` (handler forwards with status 500).

`GET /llm/match_gh_commit_gh_issues`

- Description: Match a GitHub commit to GitHub issues via LLM
- Query parameters:
  - `issue_number`: int (required)
  - `check_date`: bool (optional, default=false)
- Response:
  - 200 OK - returns plugin response (matching results array)
- Errors:
  - 500 Internal Server Error - when the plugin response contains `"error"` (handler forwards with status 500).

`POST /llm/match_gh_commit_jira_issues`

- Description: Match GitHub commits to Jira issues
- Request body (JSON): single `{ "issue_key": "PROJ-123" }` or list of such objects
- Query / dependencies:
  - `owner`, `repo`, `repo_key` - repo identification via `required_github_repo_key` dependency
  - `from_branch`: string (optional, default="default")
  - `target_branch`: string (optional)
  - `check_date`: bool (optional)
- Response:
  - 200 OK - returns list of match results (plugin-defined shape)
- Errors:
  - 400 Bad Request - when `github` dependency is missing. Example: { "error": "Missing repository. Provide 'owner' and 'repo' or 'repo_key'." }
  - 500 Internal Server Error - when GitHub token is not available. Example: { "error": "No GitHub token found/available." }
  - 500 Internal Server Error - when the plugin returns `{"error": ...}` (handler forwards with status 500).
  - 500 Internal Server Error - when an element in the plugin response list contains `"error"` (handler forwards that element with status 500).

`GET /llm/gh-cherry-pick-commits`

- Description: Create a branch with selected commits (AI-assisted)
- Query parameters:
  - `commit_sha`: list[str] (Query, required) - multiple occurrences allowed
  - `from_branch_name`: string (optional, default="default")
  - `target_branch_name`: string (optional)
  - `issue_number`: int (optional)
  - `owner`, `repo`, `repo_key` - repo identification via dependency
- Response:
  - 200 OK - when `create_branch_with_commits` returns a dict with `status` == `"success"` (returned verbatim)
  - non-200 - when the helper returns a dict with `status` != `"success"`; the handler returns that dict with the dict's `status_code` or 500 by default
- Errors:
  - 400 Bad Request - when `github` dependency is missing. Example: { "error": "Missing repository. Provide 'owner' and 'repo' or 'repo_key'." }
  - 422 Unprocessable Entity - when neither `issue_number` nor `target_branch_name` is provided. Example: { "error": "Either issue_number or target_branch_name is required" }
  - 500 Internal Server Error - when GitHub token is missing/invalid or other unexpected exceptions. Examples: { "error": "No GitHub token found/available." }, { "error": "Invalid GitHub credentials." }, { "error": "Unexpected error: < message >" }

`POST /llm/jira-cherry-pick-commits`

- Description: Create a branch with selected commits using a Jira issue key to derive branch name
- Query / body / dependencies:
  - `commit_sha`: list[str] (Query, required)
  - `from_branch_name`: string (optional, default="default")
  - `target_branch_name`: string (optional)
  - `issue_key`: body `{ "issue_key": "PROJ-123" }` (optional)
  - `owner`, `repo`, `repo_key` - repo identification via dependency
- Response & Errors: same behavior and errors as `/llm/gh-cherry-pick-commits`.

`GET /ai/pr-eval`

- Description: Return or generate PR AI evaluations
- Query parameters:
  - `days`: int (optional, default=30)
  - `author`: string (optional)
  - `owner`, `repo`, `repo_key` - repo identification via dependency
- Response:
  - 200 OK - JSON: { "evaluations": [ ... ] } (may trigger background LLM run and re-query)
- Errors:
  - 400 Bad Request - when `github` dependency is missing. Example: { "error": "Missing repository. Provide 'owner' and 'repo' or 'repo_key'." }
  - 500 Internal Server Error - on unexpected exceptions (returns { "error": "< message >" }).

`GET /ai/jira-eval`

- Description: Return or generate Jira issue AI evaluations
- Query parameters:
  - `days`: int (optional, default=30)
  - `jira` - JiraProjectKey dependency (requires both `project_key` and `base_url` when provided)
  - `creator`: string (optional)
- Response:
  - 200 OK - JSON: { "evaluations": [ ... ] } (may trigger background LLM run and re-query)
- Errors:
  - 500 Internal Server Error - on unexpected exceptions (returns { "error": "< message >" }).

## Build (/build/*)

`GET /build/gh_actions`

- Description: Trigger GitHub Actions workflows using configured `build_config`
- Query parameters: `target_branch` (optional)
- Response:
  - 200 OK - application/json:

  ```json
  {
    "info": "Successfully dispatched the run(s).",
    "dispatched": true,
    "workflow_ids": ["ci.yml"]
  }
  ```

- Errors:
  - 500 Internal Server Error - when `build_config` or `gh_actions` config is missing or invalid.
    - Example bodies:
      - { "error": "No build_config found." }
      - { "error": "No gh_actions config found." }
      - { "error": "Missing keys in config. Required keys are: owner, repo, token, workflow_id" }
      - { "error": "Value for key '< key >' cannot be empty." }
      - { "error": "Value for key 'workflow_id' must be a string or a list." }
  - 500 Internal Server Error - when YAML parsing fails for the config.
    - Example body: { "error": "Invalid YAML in config." }
  - 500 Internal Server Error - when dispatch fails (build system returned falsy).
    - Example body: { "error": "Error in dispatching some or all the run(s)." }

## Workbench / Project Management (/workbench/*)

`POST /workbench/insert-new-product`

- Description: Insert a new product into `products` table
- Request body (JSON): `Product` - { "value": string, "viewValue": string }
- Response:
  - 200 OK - { "info": "Inserted product details to database." }
- Errors:
  - 400 Bad Request - { "error": "Product already exists in the database." }
  - 500 Internal Server Error - { "error": "Unable to insert product details to database." }
  - 404 Not Found - (edge case when products table missing) handler attempts to create/save; may return 500 on failure

`DELETE /workbench/delete-product`

- Description: Delete product by `value`
- Query parameters:
  - `value`: string (required)
- Response:
  - 200 OK - { "info": "Deleted product from database." }
- Errors:
  - 404 Not Found - { "error": "The Products table doesn't exist." }
  - 400 Bad Request - { "error": "Product does not exist in the database." }
  - 500 Internal Server Error - { "error": "Unable to delete product from database." }

`GET /workbench/get-all-products`

- Description: List all products
- Response:
  - 200 OK - { "products": [ { < product row columns > }, ... ] }
- Errors:
  - 404 Not Found - { "error": "The Products table doesn't exist." }

`POST /workbench/insert-project-details`

- Description: Insert project details
- Request body (JSON): `ProjectDetails` - fields:
  - `id`: string
  - `product`: string (must exist in products)
  - `name`: string
  - `status`: "New" | "In Progress" | "Completed"
  - `scope_date`: datetime (ISO string)
  - `development_date`: datetime (ISO string)
  - `qa_date`: datetime (ISO string)
  - `release_date`: datetime (ISO string)
  - `repo_key`: string
  - `project_key`: string
- Response:
  - 200 OK - { "info": "Inserted project details to database." }
- Errors:
  - 404 Not Found - { "error": "The Products table doesn't exist." }
  - 400 Bad Request - { "error": "Product does not exist in the database." }
  - 500 Internal Server Error - { "error": "Unable to insert project details to database." }

`POST /workbench/insert-project-jira-bugs`

- Description: Link Jira bugs to a project
- Query parameters:
  - `project_id`: string (required)
- Request body (JSON): single `JiraBug` or list of `JiraBug` objects:
  - `id`: string
  - `title`: string
  - `assignee`: string
  - `status`: string
  - `target_date`: date (YYYY-MM-DD)
- Response:
  - 200 OK - { "info": "Inserted jira bugs for project details to database." }
- Errors:
  - 500 Internal Server Error - { "error": "Unable to insert jira bugs for project details to database." }

`GET /workbench/update-project-status`

- Description: Update an existing project's status
- Query parameters:
  - `project_id`: string (required)
  - `project_status`: string (required) - one of: "New", "In Progress", "Completed"
- Response:
  - 200 OK - { "info": "Successfully updated the project status." }
- Errors:
  - 400 Bad Request - { "error": "Unable to find associated with project id {project_id}." }
  - 404 Not Found - { "error": "The Project details table doesn't exist." }
  - 500 Internal Server Error - { "error": "Unable to update project status." }

`GET /workbench/get-project-jira-bugs`

- Description: Get linked Jira bugs for a project
- Query parameters:
  - `project_id`: string (required)
- Response:
  - 200 OK - { "jira_bugs": [ ... ] }
- Errors:
  - 400 Bad Request - { "error": "Unable to find bugs associated with project id {project_id}." }
  - 404 Not Found - { "error": "The jira bugs table doesn't exist." }

`DELETE /workbench/delete-project-jira-bug`

- Description: Remove a bug linked to a project
- Query parameters:
  - `project_id`: string (required)
  - `bug_id`: string (required)
- Response:
  - 200 OK - { "info": "Deleted bug with bug id {bug_id} associated with project id {project_id}." }
- Errors:
  - 400 Bad Request - { "error": "Unable to find bug with bug id {bug_id} associated with project id {project_id}. No changes made." }
  - 404 Not Found - { "error": "The jira bugs table doesn't exist." }

`GET /workbench/get-all-project-details`

- Description: Return all projects with linked Jira bugs
- Response:
  - 200 OK - [ { <project_fields>, "jira_bugs": [ ... ] }, ... ]
- Errors:
  - 404 Not Found - { "error": "Project details doesn't exist in database. Please use \"+ Create Project\" to create and add project." }

`DELETE /workbench/delete-project-details`

- Description: Delete project details and any linked Jira bugs
- Query parameters:
  - `project_id`: string (required)
- Response:
  - 200 OK - { "info": "Deleted record with project id {project_id} and any Jira bugs related to it." }
- Errors:
  - 400 Bad Request - { "error": "Unable to find record with project id {project_id}. No changes made." }
  - 404 Not Found - { "error": "The project details table doesn't exist." }

`GET /workbench/available-repos`

- Description: Return deduplicated list of GitHub repos accessible by configured tokens/OAuth
- Response:
  - 200 OK - { "repositories": [ { "full_name", "owner", "name", "is_private", "html_url" } ], "total": int }
  - 500 Internal Server Error - { "error": "Error fetching repositories: {e}" }

`GET /workbench/available-jira-boards`

- Description: Return deduplicated list of Jira projects accessible by configured credentials/OAuth
- Response:
  - 200 OK - { "boards": [ { "project_key", "name", "base_url", "project_type", "is_private" } ], "total": int }
  - 500 Internal Server Error - { "error": "Error fetching Jira boards: {e}" }

`GET /workbench/license/verify`

- Description: Return current license verification status
- Response:
  - 200 OK - license status JSON (from LicenseStatus)
  - 404 Not Found - { "error": "License status not available." }

`POST /workbench/config/github/tokens` (and corresponding GET/DELETE)

- Description: Add / list / delete GitHub tokens and associated repo-access mappings
- Request body (POST): { "token": string, "label_name": string }
- Responses (summary):
  - 200 OK - on success returns detailed summary (id, label, belongs_to, is_active, successes/failures)
  - 500 Internal Server Error - various error cases (token validation, saving errors)

`POST /workbench/config/jira/tokens` (and corresponding GET/DELETE)

- Description: Add / list / delete Jira credentials and associated project-access mappings
- Request body (POST): { "base_url": string, "username": string, "token": string, "label_name": string }
- Responses (summary):
  - 200 OK - on success returns detailed summary (id, base_url, username, label, belongs_to, is_active, successes/failures)
  - 500 Internal Server Error - various error cases (credential validation, saving errors)

## Analytics (/analytics/*, /metrics/*)

`GET /analytics/developers/performance`

- Description: Weekly developer performance aggregation for a given human identifier. Uses identity reconciliation (identity_map) and the analytics service to compute an "author window" analysis.
- Query parameters / dependencies:
  - `person_query`: string (required) - human identifier (name or email) to reconcile
  - `days`: int (optional, default=7) - time window in days
  - `repo_key`: string (optional) - restrict to a repository (owner/repo)
  - `project_key` + `base_url`: (optional) provided via `JiraProjectKey` dependency (`jira_project`) - restrict to a Jira project
  - `force`: bool (optional, default=false) - force recompute (bypass cache)
- Response:
  - 200 OK - application/json:

  ```json
  {
    "person_query": "alice@example.com",
    "author_login_used": "alice",
    "period_start": "2026-04-23T00:00:00Z",
    "period_end": "2026-04-30T00:00:00Z",
    "scope_type": "repo",
    "scope_id": "owner/repo",
    "query_name": "dev_performance",
    "query_version": "v1",
    "cached": false,
    "evaluation": { "score": 82.5 },
    "evidence": [],
    "metrics": { "commits": 12, "prs": 3 }
  }
  ```

- Errors:
  - 502 Bad Gateway - when the analytics service returns an error (response body: { "error": "< message >" })
  - 500 Internal Server Error - on unexpected exceptions (response body: { "error": "< message >" }); the handler also records a failed AI-evaluation entry.

`GET /analytics/developers/metrics`

- Description: Developer activity metrics for the past `days` (similar inputs to performance endpoint). Returns a metrics object computed by the analytics service.
- Query parameters / dependencies:
  - `person_query`: string (required)
  - `days`: int (optional, default=7)
  - `repo_key`: string (optional)
  - `project_key` + `base_url`: (optional) via `JiraProjectKey` dependency
  - `force`: bool (optional, default=false)
- Response:
  - 200 OK - JSON matching the performance response shape (meta fields + `metrics` object)
- Errors:
  - 502 Bad Gateway - when the analytics service returns an error (response body: { "error": "< message >" })
  - 500 Internal Server Error - on unexpected exceptions (response body: { "error": "< message >" })

`GET /analytics/qa/metrics`

- Description: QA activity metrics for the past `days` (same reconciliation + caching semantics as developer metrics).
- Query parameters / dependencies:
  - `person_query`: string (required)
  - `days`: int (optional, default=7)
  - `repo_key`: string (optional)
  - `project_key` + `base_url`: (optional) via `JiraProjectKey` dependency
  - `force`: bool (optional, default=false)
- Response:
  - 200 OK - JSON: { same meta fields as above, "metrics": { ... } }
- Errors:
  - 502 Bad Gateway - when the analytics service returns an error (response body: { "error": "< message >" })
  - 500 Internal Server Error - on unexpected exceptions (response body: { "error": "< message >" })

`POST /metrics/dev/run`

- Description: Trigger developer metrics computation (background/inline) and persist results. This endpoint invokes `lib.metrics.compute_*` helpers depending on supplied `github`/`jira` parameters.
- Query / body / dependencies:
  - `days`: int (Query, default=30)
  - `github`: optional `GithubRepoKey` dependency (owner/repo or repo_key)
  - `jira`: optional `JiraProjectKey` dependency (project_key + base_url)
  - `author`: string (optional) - filter PR metrics by author
  - `assignee`: string (optional) - filter ticket metrics by assignee
- Response:
  - 200 OK - JSON: { "status": "ok", "results": { "pr_metrics": [...], "ticket_metrics": [...] } }
- Errors:
  - 500 Internal Server Error - on unexpected exceptions (returns HTTP 500 with detail)

`POST /metrics/qa/run`

- Description: Trigger QA metrics computation and persist results (per-project or all projects if none supplied).
- Query / body / dependencies:
  - `days`: int (Query, default=30)
  - `jira`: optional `JiraProjectKey` dependency
  - `creator`: string (optional) - filter by issue creator
- Response:
  - 200 OK - JSON: { "status": "ok", "results": { "qa_metrics": [...] } }
- Errors:
  - 500 Internal Server Error - on unexpected exceptions (returns HTTP 500 with detail)

## HR (/hr/*)

`POST /hr/reconcile/run`

- Description: Reconcile Run - run HR import and reconciliation.
- Description: Upload CSVs (people_file, roles_file) OR provide `hr_endpoint` JSON; optional import and reconcile phases.
- Query parameters:
  - `import_hr` (query, boolean, default=true) - enable ingestion step
  - `reconcile` (query, boolean, default=true) - enable reconciliation step
  - `min_conf` (query, number, default=0.7, 0.0..1.0) - confidence threshold to persist identity links
  - `dry_run` (query, boolean, default=false) - if true, do not write DB; return candidates
- Request body (multipart/form-data): schema `Body_reconcile_run_hr_reconcile_run_post` - supports `people_file`, `roles_file`, and other ingestion fields
- Responses:
  - 200 OK - application/json:

  ```json
  {
    "imported_people": 10,
    "persisted": 5,
    "candidates": []
  }
  ```

- Errors:
  - 400 Bad Request - client-side input errors (invalid CSV/JSON)
  - 422 Unprocessable Entity - validation errors (FastAPI `HTTPValidationError`)
  - 500 Internal Server Error - processing exceptions (returns { "error": "< message >" })

`GET /hr/ingestion/run`

- Description: Ingestion Run - config-driven ingestion (CSV/S3) using ingestion config.
- Query parameters:
  - `full` (query, boolean, default=false) - return entire transformed data when true
  - `sample_size` (query, integer, default=50) - sample size when `full` is false (1..1000)
- Request body: expects JSON with root key `data_ingestion` (ingestion plan/config)
- Responses:
  - 200 OK - application/json:

  ```json
  {
    "imported_people": 10,
    "imported_roles": 2,
    "rows_processed": 123
  }
  ```

- Errors:
  - 400 Bad Request - invalid/missing ingestion config
  - 422 Unprocessable Entity - validation errors
  - 500 Internal Server Error - processing exceptions

`GET /hr/ingestion/reconcile`

- Description: Ingestion Reconcile - ingest (optional) and reconcile external identities.
- Description: See backend for detailed behavior: returns imported counts, scanned counts per system, persisted links, candidate samples, and metadata. Query params below override body values.
- Query parameters:
  - `import_hr` (query, boolean, default=true)
  - `reconcile` (query, boolean, default=true)
  - `min_conf` (query, number, default=0.7)
  - `dry_run` (query, boolean, default=false)
-- Responses:
  - 200 OK - application/json:

  ```json
  {
    "imported_people": 10,
    "imported_roles": 2,
    "scanned": { "github": 100, "jira": 50 },
    "persisted": 5,
    "candidates_count": 8,
    "candidates_sample": [],
    "dry_run": false,
    "min_confidence": 0.7,
    "note": "Completed"
  }
  ```

- Errors:
  - 422 Unprocessable Entity - validation errors
  - 500 Internal Server Error - processing exceptions

`GET /hr/reconcile/get_reconciled_users`

- Description: Get Reconciled Users - return reconciled users for provided IDs/filters.
- Query parameters:
  - `system` (query, string|null) - optional system filter (e.g., 'github')
  - `min_conf` (query, number, default=0.0) - minimum confidence to include links
- Responses:
  - 200 OK - application/json:

  ```json
  {
    "users": [ { "id": "u1", "name": "Alice", "links": [ { "system": "github", "id": "alice" } ] } ]
  }
  ```

- Errors:
  - 422 Unprocessable Entity - validation errors
  - 500 Internal Server Error - on DB/read errors

`GET /hr/levels`

- Description: List levels for hierarchy filtering.
- Query parameters:
  - `person` (query, string|null) - person id, email, name substring, or external id
  - `source` (query, string|null) - optional source filter for person_roles (e.g., 'jira')
- Responses:
  - 200 OK - application/json:

  ```json
  {
    "levels": [ "L1", "L2", "L3" ]
  }
  ```

- Errors:
  - 422 Unprocessable Entity - validation errors
  - 500 Internal Server Error - on processing errors

`GET /hr/teams`

- Description: List teams for hierarchy filtering.
- Query parameters:
  - `person` (query, string|null)
  - `source` (query, string|null)
- Responses:
  - 200 OK - application/json:

  ```json
  {
    "teams": [ "Platform", "Product", "QA" ]
  }
  ```

- Errors:
  - 422 Unprocessable Entity - validation errors
  - 500 Internal Server Error - on processing errors

`GET /hr/functional_managers`

- Description: List functional managers for hierarchy filtering.
- Query parameters:
  - `person` (query, string|null)
  - `source` (query, string|null)
- Responses:
  - 200 OK - application/json:

  ```json
  {
    "functional_managers": [ { "id": "fm1", "name": "Alice" } ]
  }
  ```

- Errors:
  - 422 Unprocessable Entity - validation errors
  - 500 Internal Server Error - on processing errors

`GET /hr/reporting_managers`

- Description: List reporting managers for hierarchy filtering.
- Query parameters:
  - `person` (query, string|null)
  - `source` (query, string|null)
- Responses:
  - 200 OK - application/json:

  ```json
  {
    "reporting_managers": [ { "id": "rm1", "name": "Bob" } ]
  }
  ```

- Errors:
  - 422 Unprocessable Entity - validation errors
  - 500 Internal Server Error - on processing errors

`GET /hr/managers`

- Description: List managers with id, full_name, and role.
- Description: Returns unique managers; supports filters for `user` and `role`.
- Query parameters:
  - `user` (query, string|null) - person id, email, name substring, or external id to filter by
  - `role` (query, string|null) - manager role filter: 'functional' or 'reporting'
- Responses:
  - 200 OK - application/json:

  ```json
  {
    "managers": [ { "id": "m1", "full_name": "Carol Manager", "role": "functional" } ]
  }
  ```

- Errors:
  - 422 Unprocessable Entity - validation errors
  - 500 Internal Server Error - on processing errors

## User Data (/user_data/*)

`POST /user_data/upload`

- Summary: Upload User Data - upload a CSV file for user data display.
- Description: Expected CSV format with headers in the first row. Returns an object with `id`, `filename`, `uploadedAt`, and `rows` count.
- Request body: multipart/form-data (required) with schema `Body_upload_user_data_user_data_upload_post` (file field(s)).
- Responses:
  - 200 OK - application/json: { "id": string, "filename": string, "uploadedAt": iso-datetime, "rows": int }
  - 422 Unprocessable Entity - validation errors (`HTTPValidationError`)
- Errors:
  - 400 Bad Request - invalid upload (malformed CSV)
  - 500 Internal Server Error - storage/processing errors

`GET /user_data/files`

- Summary: List User Data Files - return metadata for all uploaded files.
- Responses:
  - 200 OK - application/json: { "files": [ { "id": string, "filename": string, "uploadedAt": iso-datetime, "rows": int }, ... ] }
- Errors:
  - 500 Internal Server Error - on read errors

`GET /user_data/files/{file_id}`

- Summary: Get User Data - return file content or metadata for a specific `file_id`.
- Path parameters:
  - `file_id` (path, string, required) - the file identifier
- Responses:
  - 200 OK - application/json: { "filename": string, "data": [ { < row object > }, ... ] }
  - 422 Unprocessable Entity - validation errors (`HTTPValidationError`)
- Errors:
  - 500 Internal Server Error - on read/processing errors

`DELETE /user_data/files/{file_id}`

- Summary: Delete User Data - remove a previously uploaded file by `file_id`.
- Path parameters:
  - `file_id` (path, string, required)
- Responses:
  - 200 OK - application/json: { "success": true, "message": string }
  - 422 Unprocessable Entity - validation errors (`HTTPValidationError`)
- Errors:
  - 500 Internal Server Error - on delete/storage errors

## Workbench UI / Review Forms (/workbench/config/ui/*, /workbench/review_form/*, /workbench/manager_review/*)

`POST /workbench/config/ui/review_form`

- Description: Create or update a review form UI configuration. Stores the form definition keyed by `ui_key`.
- Request body (JSON): `{ "ui_key": string, "title": string, "sections": [ ... ] }`
- Responses:
  - 200 OK - application/json:

  ```json
  {
    "ui_key": "review-employee-performance",
    "info": "Saved review form configuration."
  }
  ```

- Errors:
  - 400 Bad Request - invalid payload
  - 500 Internal Server Error - when persisting the config

`GET /workbench/config/ui/review_forms`

- Description: List available review form UI configs
- Responses:
  - 200 OK - application/json:

  ```json
  {
    "forms": [ { "ui_key": "review-employee-performance", "title": "Employee Performance" } ]
  }
  ```

`GET /workbench/config/ui/review_ui_config`

- Description: Return UI-level configuration for review forms (global settings)
- Responses:
  - 200 OK - application/json:

  ```json
  ["review-employee-performance", "another-ui-key"]
  ```

`GET /workbench/config/ui/review_form/{ui_key}`

- Description: Get a specific review form configuration by `ui_key`.
- Path parameters:
  - `ui_key` (path, string, required)
- Responses:
  - 200 OK - application/json:

  ```json
  {
    "form": {
      "ui_key": "review-employee-performance",
      "title": "Employee Performance",
      "sections": [ /* review form sections and components */ ]
    }
  }
  ```

- Errors:
  - 404 Not Found - when `ui_key` not present

`POST /workbench/review_form/submit`

- Description: Submit a completed review form (final submission).
- Request body (JSON): `{ "ui_key": string, "review": { ... }, "reviewer": string, "subject": string }`
- Responses:
  - 200 OK - application/json:

```json
{
  "status": "submitted",
  "form": { /* sanitized form JSON as stored */ }
}
```

- Errors:
  - 400 Bad Request - missing/invalid fields
  - 500 Internal Server Error - on save/processing errors

`POST /workbench/review_form/save_draft`

- Description: Save a draft review (returns draft id).
- Request body (JSON): `{ "ui_key": string, "draft": { ... }, "reviewer": string }`
- Responses:
  - 200 OK - application/json:

  ```json
  {
    "status": "draft_saved",
    "form": { /* sanitized draft form JSON as stored */ }
  }
  ```

`GET /workbench/review_form/get`

- Description: Retrieve a review or draft by id (query param `id`).
- Query parameters:
  - `id`: string (required)
- Responses:
  - 200 OK - application/json:

  ```json
  {
    "review_forms": [
      {
        "id": 123,
        "ui_key": "review-employee-performance",
        "form_json": { /* stored form */ },
        "is_draft": 0,
        "updated_at": "2026-04-30T12:34:56Z"
      }
    ]
  }
  ```

- Errors:
  - 404 Not Found - when id not found

`GET /workbench/review_form/drafts`

- Description: List drafts for the current user or project context.
- Responses:
  - 200 OK - application/json:

  ```json
  {
    "draft": { /* latest draft form JSON when present */ }
  }
  ```

`GET /workbench/review_form/final_score`

- Description: Compute or retrieve a final aggregated score for a submitted review.
- Query parameters: may include `review_id` or context filters
- Responses:
  - 200 OK - application/json:
  
  ```json
  {
    "person_query": "alice@example.com",
    "resolved_person_id": "person-123",
    "ai_mean": 78.5,
    "ai_rows": [],
    "self_score": 85.0,
    "review_summary": {
      "review-employee-performance": {
        "avg_raw": 4.2,
        "norm": 80.0,
        "rating": 4,
        "row_id": 12,
        "is_draft": false,
        "updated_at": "2026-04-29T10:00:00Z"
      }
    },
    "weights": { "ai_weight": 0.6, "self_weight": 0.4 },
    "final_form": { "version": 1, "kind": "form", "id": "...", "sections": [ /* ... */ ] }
  }
  ```

`POST /workbench/manager_review/submit`

- Description: Submit a manager-level review (same shapes as review_form/submit but stored under manager review flows).
- Request body (JSON): similar to `/workbench/review_form/submit`
- Responses:
  - 200 OK - application/json:

  ```json
  {
    "status": "submitted",
    "id": 456,
    "user_id": "user-123",
    "manager_id": "mgr-456",
    "ui_key": "manager-review-key",
    "scope_id": null,
    "is_draft": false,
    "form": { /* stored form JSON */ }
  }
  ```

`POST /workbench/manager_review/save_draft`

- Description: Save a manager review draft.
- Responses:
  - 200 OK - application/json:

  ```json
  {
    "status": "draft_saved",
    "id": 457,
    "user_id": "user-123",
    "manager_id": "mgr-456",
    "ui_key": "manager-review-key",
    "scope_id": null,
    "is_draft": true,
    "form": { /* stored draft form JSON */ }
  }
  ```

`GET /workbench/manager_review/get`

- Description: Get a manager review by id.
- Query parameters:
  - `id`: string (required)
- Responses:
  - 200 OK - application/json:

  ```json
  {
    "manager_reviews": [
      {
        "id": 456,
        "user_id": "user-123",
        "manager_id": "mgr-456",
        "form_json": { /* stored form */ },
        "is_draft": 0,
        "updated_at": "2026-04-30T12:00:00Z"
      }
    ]
  }
  ```

`GET /workbench/manager_review/drafts`

- Description: List manager review drafts for the user/context.
- Responses:
  - 200 OK - application/json:
  
  ```json
  {
    "drafts": [ { "id": 457, "ui_key": "manager-review-key", "form_json": { /* draft */ }, "updated_at": "2026-04-30T11:00:00Z" } ]
  }
  ```
