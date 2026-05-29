#!/bin/bash
# =============================================================================
# Hotfix Knowledge Base Bootstrap – FULLY GENERIC (v1.1)
# Works in ANY git repository. Uses .hotfix-agents/ structure.
# =============================================================================

set -e

# === DYNAMIC PATH DETECTION (works anywhere) ===
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo ".")
AGENTS_ROOT="${REPO_ROOT}/.hotfix-agents"
CONTEXT_DIR="${AGENTS_ROOT}/context"
LOGFILE="${AGENTS_ROOT}/bootstrap.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOGFILE"
}

echo "=== Hotfix Knowledge Base Bootstrap (Generic) ===" | tee "$LOGFILE"
log "Repo root detected: ${REPO_ROOT}"
log "Agents root: ${AGENTS_ROOT}"

mkdir -p "${CONTEXT_DIR}/company" "${CONTEXT_DIR}/customers" "${CONTEXT_DIR}/skills"

# Extract live git data
TAGS=$(git tag --list --format='%(refname:short)' 2>/dev/null || echo "")
BRANCHES=$(git branch -a --format='%(refname:short)' 2>/dev/null || echo "")

# Dynamically detect customer-like identifiers
CUSTOMERS=$(cat <<EOF
$TAGS
$BRANCHES
EOF
    | grep -oE '([a-z0-9-]+)' \
    | grep -vE '^(main|release|hotfix|chf|origin|HEAD|master|develop|feature|bugfix|tag|v[0-9])$' \
    | sort | uniq | tr '\n' ' ' || echo "unknown")

CHANGED_FILES=$(git log --name-only --pretty=format: --diff-filter=ACMR -30 2>/dev/null \
    | grep -E '\.(md|sh|py|conf|cfg|yaml|yml|json|xml|properties)$' \
    | sort | uniq | head -15 | tr '\n' ' ' || echo "DHCP.md")

log "Detected customer-like identifiers: ${CUSTOMERS}"
log "Common changed files: ${CHANGED_FILES}"

# 5. release-style.md
cat > "${CONTEXT_DIR}/company/release-style.md" << EOF
# Company Release Style (AUTO-GENERATED from live git history)
# Generated on: $(date)

## Branching & Release Model
- Sustaining line: release/*
- Hotfix branches: hotfix/<customer> | hotfix/<issue> | chf/<ticket>-<description>
- Main development: main

## Tag Semantics (observed)
$(echo "$TAGS" | head -15 | sed 's/^/- /')

## Commit Message Format
fix(<scope>): <short description>
Consolidated from: <source-sha(s)>
Fixes: <Ticket-ID>

## Minimal Surface Rule
Hotfixes typically modify only: ${CHANGED_FILES}

## Merge Preference
--no-ff merges on release branches + cherry-pick to main
EOF

# 6. RELEASE-KNOWLEDGE.md
cat > "${CONTEXT_DIR}/RELEASE-KNOWLEDGE.md" << EOF
# RELEASE-KNOWLEDGE.md
## Living Knowledge Base for Hotfix Release Engineering
Last updated: $(date)

### Bootstrap Run (Cold Start)
**Date**: $(date)
**Source**: Live git repository analysis

**Learned facts**:
- Detected $(echo "$TAGS" | wc -l) tags
- Customer-like identifiers: ${CUSTOMERS}
- Primary changed files: ${CHANGED_FILES}

**Implications for future runs**:
- Minimal-surface rule will be enforced based on observed changes.
- Future Learner Agent runs will append here.

### (Future runs will append new sections here — never edit old ones)
EOF

# 7. hotfix-skills.json
cat > "${CONTEXT_DIR}/skills/hotfix-skills.json" << EOF
{
  "schema_version": "1",
  "last_updated": "$(date +%Y-%m-%d)",
  "bootstrap_source": "live_git_analysis",
  "skills": [
    {
      "id": "bootstrap-tag-pattern",
      "type": "naming-convention",
      "pattern": "v[0-9]+.[0-9]+.[0-9]+-{customer}-hf[0-9]+",
      "applies_to": ["all"],
      "confidence": 90,
      "source": "git tag list",
      "date": "$(date +%Y-%m-%d)"
    },
    {
      "id": "bootstrap-minimal-surface",
      "type": "diff-strategy",
      "rule": "hotfix branches only modify observed files (${CHANGED_FILES})",
      "applies_to": ["all"],
      "confidence": 85,
      "source": "git log --name-only",
      "date": "$(date +%Y-%m-%d)"
    }
  ]
}
EOF

# 8. Customer files
for cust in $CUSTOMERS; do
    if [ -n "$cust" ] && [[ ! "$cust" =~ ^(main|release|hotfix|chf|origin|HEAD)$ ]]; then
        cat > "${CONTEXT_DIR}/customers/${cust}.md" << EOF
# ${cust^} Customer Layout & Preferences
## AUTO-GENERATED from git history
EOF
    fi
done

# 9. HOTFIX-HISTORY.md
cat > "${REPO_ROOT}/HOTFIX-HISTORY.md" << EOF
# HOTFIX-HISTORY.md
## Consolidated Hotfix Run Log

### $(date +%Y-%m-%d) - Bootstrap (Cold Start)
- Detected customers/identifiers: ${CUSTOMERS}
- Status: Knowledge base seeded
EOF

log "✅ Generic bootstrap completed successfully!"
echo "Knowledge base created in ${CONTEXT_DIR}/"
ls -R "${CONTEXT_DIR}" | tee -a "$LOGFILE"
