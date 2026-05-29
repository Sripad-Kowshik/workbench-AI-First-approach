```text
<project-root>/
├── .git/                          # existing
├── README.md
├── ...                           # your actual code files
├── release/                      # your existing release branches, etc.
├── ...
│
├── .hotfix-agents/               # ← NEW dedicated folder (hidden)
│   ├── agents/                   # all agent specification files
│   │   ├── AGENTS_hcf_v9.md
│   │   ├── AGENTS_diff_v3.md
│   │   ├── AGENTS_pack_v3.md
│   │   └── AGENTS_learner_v1.md
│   ├── bootstrap-knowledge-base.sh
│   ├── context/                  # ← created automatically by bootstrap
│   │   ├── company/
│   │   │   └── release-style.md
│   │   ├── customers/
│   │   ├── skills/
│   │   │   └── hotfix-skills.json
│   │   └── RELEASE-KNOWLEDGE.md
│   └── logs/                     # optional: bootstrap logs, etc.
│
├── CHF-STATE.md                  # runtime state (created in root or inside .hotfix-agents/)
├── HOTFIX-HISTORY.md
```
