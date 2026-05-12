# Hotfix Lifecycle Management — Repo Jumpstart Specification

# Objective

Create a repository for enterprise-grade hotfix lifecycle management.

The system must support:

- local Git operations
- GitHub MCP operations
- approval-gated execution
- chainable workflows
- release engineering automation
- agent-driven orchestration
- hotfix propagation
- release branch management
- tagging and auditability

The target environment is one where:
- multiple release lines coexist
- customer-specific hotfixes may exist
- rolling deployments are required
- production fixes must be propagated safely

---

# Technology Stack

## Backend

```text
Python
```

Recommended:
- Python 3.12+
- FastAPI
- Pydantic
- Typer (CLI)
- LangChain or custom agent framework
- GitPython optional
- subprocess for direct Git execution

---

## Frontend

```text
Angular
```

Recommended:
- Angular 20+
- Angular Material
- RxJS
- NgRx optional

---

# High-Level Architecture

```text
+---------------------------------------------------+
| Frontend (Angular)                                |
| - workflow UI                                     |
| - approvals                                       |
| - execution visibility                            |
+---------------------------------------------------+
                    |
                    v
+---------------------------------------------------+
| Backend API (FastAPI)                             |
+---------------------------------------------------+
                    |
                    v
+---------------------------------------------------+
| Agent Orchestration Layer                         |
|                                                   |
| - selects execution strategy                      |
| - chains operations                               |
| - validates workflows                             |
| - interacts with tools                            |
+---------------------------------------------------+
          |                               |
          |                               |
          v                               v
+-------------------------+     +-------------------------+
| Local Git Tool Layer    |     | GitHub MCP Tool Layer   |
|                         |     |                         |
| executes local Git      |     | interacts via MCP       |
| commands on host        |     | with GitHub operations  |
+-------------------------+     +-------------------------+
```

---

# Critical Architectural Principle

The Local Git Layer and GitHub MCP Layer are NOT hierarchical.

They exist in parallel.

The agent decides which layer to use based on execution context.

---

# Execution Strategy Rules

## Use Local Git Layer When

- repository exists locally
- filesystem access is available
- shell execution is permitted
- direct Git execution is preferred

---

## Use GitHub MCP Layer When

- repository is remote-only
- access is through MCP server
- GitHub-hosted workflow is required
- operations must happen through GitHub APIs

---

# Agent Responsibilities

The agent is the orchestrator.

The agent:
- understands available tools
- selects execution strategy
- chains operations
- asks for approval
- validates operations
- executes workflows

---

# Agent Requirements

The agent must be aware of:

## Local Git Tools

Examples:
- sync_release_branch
- create_hotfix_branch
- merge_hotfix_into_release

---

## GitHub MCP Tools

Examples:
- github_create_branch
- github_merge_branch
- github_create_tag

---

# Agent Decision Example

## Scenario A

Repository exists locally.

Agent chooses:
```text
Local Git Tool Layer
```

---

## Scenario B

Repository only accessible via GitHub MCP.

Agent chooses:
```text
GitHub MCP Tool Layer
```

---

# Repository Structure

## Backend Structure (Python)

```text
backend/
├── app/
│   ├── api/
│   │   ├── routes/
│   │   └── schemas/
│   │
│   ├── agents/
│   │   ├── orchestrator/
│   │   ├── planning/
│   │   └── prompts/
│   │
│   ├── tools/
│   │   ├── local_git/
│   │   │   ├── commands/
│   │   │   ├── execution/
│   │   │   └── workflows/
│   │   │
│   │   └── github_mcp/
│   │       ├── prompts/
│   │       ├── operations/
│   │       └── workflows/
│   │
│   ├── core/
│   ├── models/
│   ├── services/
│   └── utils/
│
├── tests/
├── pyproject.toml
└── README.md
```

---

# Frontend Structure (Angular)

```text
frontend/
├── src/
│   ├── app/
│   │   ├── core/
│   │   ├── shared/
│   │   ├── features/
│   │   │   ├── workflows/
│   │   │   ├── approvals/
│   │   │   ├── execution/
│   │   │   └── releases/
│   │   │
│   │   ├── services/
│   │   └── models/
│   │
│   ├── assets/
│   └── environments/
│
├── angular.json
└── package.json
```

---

# Local Git Tool Layer

# Objective

Provide direct Git execution on the host machine.

This layer:
- generates commands
- validates commands
- requests approval
- executes commands

---

# Core Design Rule

Each Git operation is represented as a Python function.

The function:
- accepts typed parameters
- returns command metadata
- does NOT auto-execute

---

# Command Result Model

```python
from pydantic import BaseModel
from typing import List


class CommandResult(BaseModel):
    operation: str
    description: str
    commands: List[str]
    requires_approval: bool = True
```

---

# Required Local Git Operations

---

## sync_release_branch()

```python
def sync_release_branch(
    release_branch: str
) -> CommandResult:
    return CommandResult(
        operation="sync_release_branch",
        description="Sync release branch locally",
        commands=[
            "git fetch origin",
            f"git checkout {release_branch}",
            f"git pull origin {release_branch}"
        ]
    )
```

---

## create_hotfix_branch()

```python
def create_hotfix_branch(
    release_branch: str,
    hotfix_branch: str
) -> CommandResult:
    return CommandResult(
        operation="create_hotfix_branch",
        description="Create hotfix branch",
        commands=[
            f"git checkout {release_branch}",
            f"git checkout -b {hotfix_branch}"
        ]
    )
```

---

## commit_hotfix_changes()

```python
def commit_hotfix_changes(
    commit_message: str
) -> CommandResult:
    return CommandResult(
        operation="commit_hotfix_changes",
        description="Commit hotfix changes",
        commands=[
            "git add .",
            f'git commit -m "{commit_message}"'
        ]
    )
```

---

## push_hotfix_branch()

```python
def push_hotfix_branch(
    hotfix_branch: str
) -> CommandResult:
    return CommandResult(
        operation="push_hotfix_branch",
        description="Push hotfix branch",
        commands=[
            f"git push origin {hotfix_branch}"
        ]
    )
```

---

## create_release_tag()

```python
def create_release_tag(
    tag: str,
    message: str
) -> CommandResult:
    return CommandResult(
        operation="create_release_tag",
        description="Create release tag",
        commands=[
            f'git tag -a {tag} -m "{message}"',
            f"git push origin {tag}"
        ]
    )
```

---

## merge_hotfix_into_release()

```python
def merge_hotfix_into_release(
    release_branch: str,
    hotfix_branch: str
) -> CommandResult:
    return CommandResult(
        operation="merge_hotfix_into_release",
        description="Merge hotfix into release",
        commands=[
            f"git checkout {release_branch}",
            f"git merge --no-ff {hotfix_branch}",
            f"git push origin {release_branch}"
        ]
    )
```

---

# Local Git Execution Layer

# Objective

Execute approved Git commands on the host machine.

---

# Required Features

- approval gating
- sequential execution
- stdout/stderr capture
- rollback visibility
- dry-run mode

---

# Execution Result Model

```python
from pydantic import BaseModel
from typing import List


class ExecutionResult(BaseModel):
    success: bool
    executed_commands: List[str]
    stdout: List[str]
    stderr: List[str]
```

---

# Execution Example

```python
import subprocess


def execute_commands(commands: list[str]) -> None:
    for command in commands:
        subprocess.run(command, shell=True, check=True)
```

---

# Approval Flow

Before execution:

```text
The following commands will be executed:

1. git fetch origin
2. git checkout release/v1.0
3. git pull origin release/v1.0

Approve? (y/n)
```

Execution proceeds only after approval.

---

# GitHub MCP Tool Layer

# Objective

Provide GitHub-hosted release operations through MCP tools/prompts.

This layer:
- generates deterministic prompts
- invokes MCP tools
- does NOT execute shell commands

---

# MCP Operation Model

```python
from pydantic import BaseModel
from typing import Dict


class McpOperation(BaseModel):
    operation: str
    prompt: str
    variables: Dict[str, str]
```

---

# Required MCP Operations

---

## github_create_hotfix_branch()

```python
def github_create_hotfix_branch(
    repo: str,
    release_branch: str,
    hotfix_branch: str
) -> McpOperation:

    prompt = f'''
    Create a new branch named
    {hotfix_branch}
    from
    {release_branch}
    in repository
    {repo}.
    '''

    return McpOperation(
        operation="github_create_hotfix_branch",
        prompt=prompt,
        variables={
            "repo": repo,
            "release_branch": release_branch,
            "hotfix_branch": hotfix_branch
        }
    )
```

---

## github_merge_hotfix_into_release()

```python
def github_merge_hotfix_into_release(
    repo: str,
    release_branch: str,
    hotfix_branch: str
) -> McpOperation:

    prompt = f'''
    Merge branch
    {hotfix_branch}
    into
    {release_branch}
    using a non-fast-forward merge strategy
    in repository
    {repo}.
    '''

    return McpOperation(
        operation="github_merge_hotfix_into_release",
        prompt=prompt,
        variables={
            "repo": repo,
            "release_branch": release_branch,
            "hotfix_branch": hotfix_branch
        }
    )
```

---

## github_create_release_tag()

```python
def github_create_release_tag(
    repo: str,
    tag: str,
    message: str
) -> McpOperation:

    prompt = f'''
    Create an annotated tag named
    {tag}
    with message
    "{message}"
    in repository
    {repo}.
    '''

    return McpOperation(
        operation="github_create_release_tag",
        prompt=prompt,
        variables={
            "repo": repo,
            "tag": tag,
            "message": message
        }
    )
```

---

# Workflow Layer

# Objective

Chain operations into reusable workflows.

---

# Example Workflow

```python
def perform_hotfix_lifecycle():

    sync = sync_release_branch("release/v1.0")

    hotfix = create_hotfix_branch(
        "release/v1.0",
        "hotfix/v1.0.1-dhcp-fix"
    )

    commit = commit_hotfix_changes(
        "fix: resolve DHCP corruption"
    )

    merge = merge_hotfix_into_release(
        "release/v1.0",
        "hotfix/v1.0.1-dhcp-fix"
    )

    return [
        sync,
        hotfix,
        commit,
        merge
    ]
```

---

# Required Workflow Features

- operation chaining
- partial execution
- dry-run mode
- resumability
- approval checkpoints

---

# Required Merge Strategy

Always use:

```bash
git merge --no-ff
```

Reason:
- preserves release lineage
- preserves auditability
- improves hotfix traceability

---

# Anti-Patterns

Do NOT:
- create customer-specific long-lived branches
- hotfix directly from main
- auto-execute without approval
- silently resolve merge conflicts
- force-push release branches
- deploy untagged commits

---

# Common Hotfix Operations Reference

## Sync Local Release Branch

```bash
git fetch origin
git checkout release/v1.0
git pull origin release/v1.0
```

---

## Create Hotfix Branch

```bash
git checkout release/v1.0
git checkout -b hotfix/v1.0.1-dhcp-lease-corruption
```

---

## Commit Hotfix Changes

```bash
git add .
git commit -m "fix: resolve DHCP lease corruption under high load"
```

---

## Push Hotfix Branch

```bash
git push origin hotfix/v1.0.1-dhcp-lease-corruption
```

---

## Create Release Tag

```bash
git tag -a v1.0.1 -m "Hotfix: DHCP lease corruption"
git push origin v1.0.1
```

---

## Merge Hotfix Into Release Branch

```bash
git checkout release/v1.0
git merge --no-ff hotfix/v1.0.1-dhcp-lease-corruption
git push origin release/v1.0
```

---

## Propagate Hotfix Forward To Main

```bash
git checkout main
git merge --no-ff release/v1.0
git push origin main
```
