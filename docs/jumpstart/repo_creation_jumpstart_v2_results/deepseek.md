I'll simulate executing the AGENTS.md instructions step-by-step, building the repository from scratch. All Git operations and file creations are performed as if in a local repository named `HCF-agentic-testbed`. I'll track the state after each sub-step, including the author, commit message, file contents, directory tree, and branch/tag list.

---

### Step 0 – Repository initialization
- **Plan**: Create directory, initialize Git repo, configure user name (initial), and start with an empty `README.md` on `main`.

**Sub-step 0.1 – init**
```bash
mkdir HCF-agentic-testbed && cd HCF-agentic-testbed
git init
git config user.name "Priya"
git config user.email "priya@telecom-internal.net"
echo "# HCF-agentic-testbed" > README.md
git add README.md
git commit -m "Initial empty repository bootstrap"
```
- **Author**: Priya
- **Commit**: `Initial empty repository bootstrap`
- **Directory**:
```
.
└── README.md
```
- **Branches**: `main`
- **Tags**: none

---

### Scenario 0 — Bootstrap upstream
We'll seed the repository with a believable operational baseline for a telecom DNS/DHCP/IPAM appliance platform. The plan: add lightweight operational artifacts establishing the platform, sustaining workflows, and first USER_STORY.md entries.

**Plan for Scenario 0**:
1. Create `docs/platform-overview.md`
2. Create `ops/dhcp-principles.md`
3. Create `ops/dns-recursion.md`
4. Create `ops/ipam-sync.md`
5. Create `incidents/incident-000.md`
6. Create initial `USER_STORY.md`
7. Commit each file separately with appropriate author.

I'll assign authors:
- Priya continues for initial seeding of core platform files.
- Then Rahul for DHCP area.
- Then Neha for DNS.
- Then Ajay for IPAM.
- Priya again for incident and user story.

#### Sub-step 0.2 – platform overview
```bash
mkdir docs
cat > docs/platform-overview.md <<EOF
# Platform Overview
- Appliance: DNS/DHCP/IPAM integrated
- HA pairs, active-passive
- Multi-tenant support via virtual contexts
- Sustaining Engineering manages hotfixes and CHF bundles
EOF
git add docs/platform-overview.md
git commit -m "DOCS: add platform overview"
```
- Author: Priya
- File: `docs/platform-overview.md` (5 lines)

#### Sub-step 0.3 – DHCP operational note
```bash
mkdir ops
cat > ops/dhcp-principles.md <<EOF
# DHCP Failover Principles
- Lease synchronization every 60s
- MCLT (Maximum Client Lead Time) used for graceful failback
- Stale lease detection after 2 missed sync intervals
EOF
git add ops/dhcp-principles.md
git commit -m "DHCP: document failover and lease sync principles"
```
- Author: Rahul

#### Sub-step 0.4 – DNS recursion note
```bash
cat > ops/dns-recursion.md <<EOF
# DNS Recursion & Cache
- Cache lock contention under high QPS
- Recursive timeout default 2s
- Stale cache serving during backend failure: max 10s
EOF
git add ops/dns-recursion.md
git commit -m "DNS: document cache lock contention mitigation"
```
- Author: Neha

#### Sub-step 0.5 – IPAM synchronization note
```bash
cat > ops/ipam-sync.md <<EOF
# IPAM Sync Behavior
- Full sync every 15 minutes
- Incremental updates via event bus
- Conflict resolution: latest timestamp wins
EOF
git add ops/ipam-sync.md
git commit -m "IPAM: document synchronization and conflict resolution"
```
- Author: Ajay

#### Sub-step 0.6 – incident note (baseline incident)
```bash
mkdir incidents
cat > incidents/incident-000.md <<EOF
# INC-000: Initial Deployment Baseline
- Date: 2025-06-15
- Severity: Info
- Summary: v1.0.0 baseline deployed across all internal labs.
- Owner: Priya
EOF
git add incidents/incident-000.md
git commit -m "INCIDENT: log initial deployment baseline"
```
- Author: Priya

#### Sub-step 0.7 – Initial USER_STORY.md
```bash
cat > USER_STORY.md <<EOF
# User Story / Operational Chronicle

## 2025-06-15
- Priya bootstrapped the repository and established platform documents.
- Rahul added DHCP operational notes.
- Neha contributed DNS cache behavior.
- Ajay documented IPAM sync.
- First baseline incident recorded.
EOF
git add USER_STORY.md
git commit -m "USER_STORY: initial chronicle entries for bootstrap team"
```
- Author: Priya

**End of Scenario 0 repository state**:
- Files:
```
.
├── README.md
├── USER_STORY.md
├── docs/
│   └── platform-overview.md
├── incidents/
│   └── incident-000.md
└── ops/
    ├── dhcp-principles.md
    ├── dns-recursion.md
    └── ipam-sync.md
```
- Branches: `main`
- Commits: 7 (including initial)

---

### Scenario 1 — Upstream evolves
Several small realistic commits adding operational notes and incidents. Authors: Sameer for telemetry, Vikram for appliance recovery, Priya for observability, Rahul for DHCP HA failover tuning, Neha for DNS timeout tweak, then an incident note.

**Plan**:
1. `ops/telemetry-reconnect.md` (Sameer)
2. `ops/appliance-recovery.md` (Vikram)
3. `ops/observability-tips.md` (Priya)
4. Update `ops/dhcp-principles.md` with a note about stale lease reduction (Rahul)
5. Update `ops/dns-recursion.md` with reconnect throttling (Neha)
6. `incidents/incident-001.md` (Priya)
7. Update USER_STORY.md accordingly.

#### Sub-step 1.1 – Telemetry reconnect
```bash
cat > ops/telemetry-reconnect.md <<EOF
# Telemetry Reconnect Behavior
- Exponential backoff: 1s, 2s, 4s, 8s, max 30s
- Throttle guidance: avoid reconnect storms after network partition
- Metrics: reconnect_attempts_total, reconnect_failures_total
EOF
git add ops/telemetry-reconnect.md
git commit -m "Telemetry: add reconnect throttling guidance"
```
- Author: Sameer

#### Sub-step 1.2 – Appliance recovery
```bash
cat > ops/appliance-recovery.md <<EOF
# Appliance Recovery Notes
- Watchdog timer: 120s
- Automatic failover if primary unresponsive
- Manual recovery via "system-recover" CLI
EOF
git add ops/appliance-recovery.md
git commit -m "Appliance: document watchdog-based recovery"
```
- Author: Vikram

#### Sub-step 1.3 – Observability tips
```bash
cat > ops/observability-tips.md <<EOF
# Observability
- Export DHCP lease metrics to Prometheus
- DNS query latency percentiles
- IPAM conflict count
EOF
git add ops/observability-tips.md
git commit -m "Observability: add basic export tips"
```
- Author: Priya

#### Sub-step 1.4 – DHCP stale lease reduction (update)
```bash
# Edit ops/dhcp-principles.md, add line:
echo "- Stale lease retention reduced from 4h to 2h during HA failover" >> ops/dhcp-principles.md
git add ops/dhcp-principles.md
git commit -m "DHCP: reduce stale lease retention during HA failover"
```
- Author: Rahul

#### Sub-step 1.5 – DNS cache lock tuning
```bash
# Edit ops/dns-recursion.md: append
echo "- Reduced lock contention by sharding cache per query type" >> ops/dns-recursion.md
git add ops/dns-recursion.md
git commit -m "DNS: document cache lock contention mitigation"
```
- Author: Neha
(Note: commit message realistic, similar to earlier but distinct.)

#### Sub-step 1.6 – Incident 001
```bash
cat > incidents/incident-001.md <<EOF
# INC-001: Telemetry reconnect storm after network blip
- Date: 2025-07-22
- Severity: Medium
- Root cause: missing throttling (fixed via telemetry reconnect guidance)
- Owner: Sameer
EOF
git add incidents/incident-001.md
git commit -m "INCIDENT: log telemetry reconnect storm and fix"
```
- Author: Priya

#### Sub-step 1.7 – Update USER_STORY.md
```bash
cat >> USER_STORY.md <<EOF

## 2025-07-22 to 2025-07-25
- Sameer added telemetry reconnect guidance and later resolved INC-001.
- Vikram documented appliance recovery.
- Priya added observability tips.
- Rahul tuned DHCP stale lease retention.
- Neha improved DNS cache sharding.
EOF
git add USER_STORY.md
git commit -m "USER_STORY: chronicle upstream evolution steps"
```
- Author: Priya

**End Scenario 1 state**: `main` has all new files; branch `main` only.

---

### Scenario 2 — First release cut
Cut release/v1.0.0 from current `main` (the latest commit). Tag `v1.0.0`. Add release note and stabilization note, and update USER_STORY.

**Plan**:
- Create branch `release/v1.0.0` at same commit.
- Tag it.
- Add `releases/v1.0.0.md` (release note) and a stabilization note inside `releases/`.
- Commit these artifacts on the release branch (they are part of the release line).
- Update USER_STORY on main (or also cherry-pick to release) but keeping realism: we'll record the cutting story on main as well; we'll do it on main to reflect operational decision.

Let’s cut the release:
```bash
git checkout -b release/v1.0.0
git tag v1.0.0
```
But we'll stay on `release/v1.0.0` to add release artifacts.

#### Sub-step 2.1 – Release note
```bash
mkdir releases
cat > releases/v1.0.0.md <<EOF
# Release v1.0.0
- Date: 2025-08-01
- Cut by: Priya
- Baseline for initial customer deployments
- Includes DHCP, DNS, IPAM operational guides and incident fixes
- Stabilization: 2-week bake-in period
EOF
git add releases/v1.0.0.md
git commit -m "RELEASE: add v1.0.0 release note"
```
- Author: Priya

#### Sub-step 2.2 – Stabilization note
```bash
cat > releases/stabilization-v1.0.0.md <<EOF
# Stabilization Notes v1.0.0
- Monitoring: lease sync latency, DNS query errors
- No regressions observed in testbed
- Ready for tenant Airtel rollout
EOF
git add releases/stabilization-v1.0.0.md
git commit -m "STABILIZATION: v1.0.0 stabilization note"
```
- Author: Priya

#### Sub-step 2.3 – Update USER_STORY.md on main
We need to record the release cutting. Switch back to main temporarily, update, then merge? The instructions say to update USER_STORY.md to explain who cut the release, etc. I'll do it on main because that's the primary chronicle. We'll do:

```bash
git checkout main
```
Now main is ahead of release/v1.0.0? Actually release branch was created from the same point; but we added two commits on release branch. So main is now behind release branch. We'll update USER_STORY.md on main to reflect the cut. I'll append:

```bash
cat >> USER_STORY.md <<EOF

## 2025-08-01
- Priya cut release/v1.0.0 from main at commit $(git rev-parse --short main~0) and tagged v1.0.0.
- Release notes and stabilization added.
- This release is the baseline for tenant deployments.
EOF
git add USER_STORY.md
git commit -m "USER_STORY: document release v1.0.0 cut"
```
- Author: Priya

Note: We'll avoid merge conflicts because release branch has release files, main has different files; divergence is fine.

**End Scenario 2 state**: 
- Branches: `main`, `release/v1.0.0` (with extra commits)
- Tags: `v1.0.0` on release/v1.0.0
- Release branch ahead of main by 2 commits.

---

### Scenario 3 — Upstream diverges further
Main continues evolving with new changes not in v1.0.0. Add newer operational changes, another incident, update USER_STORY.

**Plan**:
1. On `main`, add `ops/dhcp-failover-aggressive.md` (Rahul)
2. Add `ops/dns-performance-tuning.md` (Neha)
3. Add `incidents/incident-002.md` (Priya)
4. Update USER_STORY with growing backport complexity.

#### Sub-step 3.1 – DHCP aggressive failover
```bash
git checkout main
cat > ops/dhcp-failover-aggressive.md <<EOF
# Aggressive DHCP Failover
- Option to reduce MCLT to 10s for low-latency networks
- Risk: split-brain if network flaps
- Not recommended for WAN links
EOF
git add ops/dhcp-failover-aggressive.md
git commit -m "DHCP: add aggressive failover mode documentation"
```
- Author: Rahul

#### Sub-step 3.2 – DNS performance tuning
```bash
cat > ops/dns-performance-tuning.md <<EOF
# DNS Performance Tuning
- Increase UDP buffer sizes for high QPS
- Pre-fetch popular records before TTL expiry
- Use response rate limiting (RRL) to mitigate amplification attacks
EOF
git add ops/dns-performance-tuning.md
git commit -m "DNS: document performance tuning and RRL"
```
- Author: Neha

#### Sub-step 3.3 – Incident 002
```bash
cat > incidents/incident-002.md <<EOF
# INC-002: DHCP split-brain during WAN flap
- Date: 2025-08-15
- Severity: High
- Cause: aggressive failover enabled on WAN link
- Mitigation: rollback to conservative defaults, add warning
- Owner: Rahul
EOF
git add incidents/incident-002.md
git commit -m "INCIDENT: log DHCP split-brain due to aggressive failover"
```
- Author: Priya

#### Sub-step 3.4 – Update USER_STORY
```bash
cat >> USER_STORY.md <<EOF

## 2025-08-10 to 2025-08-15
- Rahul added aggressive DHCP failover docs, later caused INC-002.
- Neha tuned DNS performance and added RRL.
- Backport complexity growing: main now diverged from v1.0.0 by several commits.
- Priya recorded incident.
EOF
git add USER_STORY.md
git commit -m "USER_STORY: chronicle upstream divergence and INC-002"
```
- Author: Priya

**End Scenario 3**: `main` now has extra commits beyond v1.0.0; release/v1.0.0 remains older.

---

### Scenario 4 — Additional release lines
Cut `release/v1.1.0` from current main. Tag `v1.1.0`. Add release note and stabilization note. This release is visibly newer.

**Plan**:
- Create branch `release/v1.1.0` from latest main.
- Tag `v1.1.0`.
- Add `releases/v1.1.0.md` and `releases/stabilization-v1.1.0.md` on that branch.
- Update USER_STORY on main.

#### Sub-step 4.1 – Cut release branch and tag
```bash
git checkout -b release/v1.1.0 main
git tag v1.1.0
```
Now we're on release/v1.1.0.

#### Sub-step 4.2 – Release note
```bash
cat > releases/v1.1.0.md <<EOF
# Release v1.1.0
- Date: 2025-09-10
- Cut by: Priya
- Includes aggressive failover warning, DNS tuning, and incident fixes
- Recommended for new deployments
EOF
git add releases/v1.1.0.md
git commit -m "RELEASE: add v1.1.0 release note"
```
- Author: Priya

#### Sub-step 4.3 – Stabilization note
```bash
cat > releases/stabilization-v1.1.0.md <<EOF
# Stabilization v1.1.0
- DNS RRL performance validated
- Aggressive failover gated behind feature flag
- Ready for TATA tenant upgrade
EOF
git add releases/stabilization-v1.1.0.md
git commit -m "STABILIZATION: v1.1.0 stabilization report"
```
- Author: Priya

#### Sub-step 4.4 – Update USER_STORY on main
```bash
git checkout main
cat >> USER_STORY.md <<EOF

## 2025-09-10
- Priya cut release/v1.1.0 from main and tagged v1.1.0.
- This release includes all upstream improvements.
- Tenants may choose to stay on older v1.0.0 or adopt v1.1.0.
EOF
git add USER_STORY.md
git commit -m "USER_STORY: note v1.1.0 release cut"
```
- Author: Priya

**State**: branches: main, release/v1.0.0, release/v1.1.0. Tags: v1.0.0, v1.1.0.

---

### Scenario 5 — Tenant drift
Create tenant branches from different release points. Airtel stays on v1.0.0; TATA adopts v1.1.0; Reliance remains on an older sustaining line (we'll use v1.0.0 but maybe with a delay?). Instructions say Reliance may remain on an older sustaining line temporarily. So we can branch `tenant/airtel` from `release/v1.0.0`, `tenant/tata` from `release/v1.1.0`, and `tenant/reliance` from an earlier point on release/v1.0.0 (say, before the stabilization commit). But to simulate drift, we'll add customer-specific overrides and operational notes. Then update USER_STORY.

**Plan**:
- Create `tenant/airtel` from `release/v1.0.0` (but at the tag). Add `tenants/airtel/overrides.md` (Rahul as Airtel expert)
- Create `tenant/tata` from `release/v1.1.0`. Add `tenants/tata/overrides.md` (Sameer)
- Create `tenant/reliance` from `release/v1.0.0` at commit before stabilization note? We'll simulate that by branching from the v1.0.0 tag but then reverting the stabilization note? Simpler: branch from release/v1.0.0 (the branch) but maybe one commit behind? We can branch from the commit before the stabilization note on release/v1.0.0, i.e., parent of the stabilization commit. I'll check commit graph. But we'll just say reliance stays on older sustaining line by branching from release/v1.0.0 before the stabilization commit. We'll add a reliance-specific override that references an older config.

We'll use fictional authors: Rahul for Airtel, Sameer for TATA, Vikram for Reliance.

#### Sub-step 5.1 – Airtel tenant branch
```bash
git checkout -b tenant/airtel release/v1.0.0
mkdir -p tenants/airtel
cat > tenants/airtel/overrides.md <<EOF
# Airtel Overrides
- DHCP failover: conservative MCLT (60s)
- DNS recursion timeout: 3s
- Lease retention: 2h (as per hotfix pending)
- Customer-specific NTP servers
EOF
git add tenants/airtel/overrides.md
git commit -m "AIRTEL: add tenant-specific overrides from v1.0.0 baseline"
```
- Author: Rahul

#### Sub-step 5.2 – TATA tenant branch
```bash
git checkout -b tenant/tata release/v1.1.0
mkdir -p tenants/tata
cat > tenants/tata/overrides.md <<EOF
# TATA Overrides
- Aggressive failover allowed with feature flag
- DNS RRL threshold: 1000 qps
- IPAM sync frequency: 10 min (faster)
EOF
git add tenants/tata/overrides.md
git commit -m "TATA: add tenant-specific overrides based on v1.1.0"
```
- Author: Sameer

#### Sub-step 5.3 – Reliance tenant branch (older sustaining)
We'll branch from release/v1.0.0 but one commit before the stabilization note. To find that commit, we could note that the stabilization commit on release/v1.0.0 was the second commit after the tag. Let's take the tag commit itself, which has the release note but not the stabilization note. We'll use the tag `v1.0.0` as the base, but add a reliance-specific note indicating they are on an older hotfix level.
```bash
git checkout -b tenant/reliance v1.0.0
mkdir -p tenants/reliance
cat > tenants/reliance/overrides.md <<EOF
# Reliance Overrides
- Release base: v1.0.0 pre-stabilization
- DHCP failover: MCLT 90s (extra conservative)
- DNS cache: disabled stale serving
- Awaiting v1.0.0-chf bundles
EOF
git add tenants/reliance/overrides.md
git commit -m "RELIANCE: add tenant overrides, older sustaining baseline"
```
- Author: Vikram

#### Sub-step 5.4 – Update USER_STORY on main
```bash
git checkout main
cat >> USER_STORY.md <<EOF

## 2025-09-12
- Tenant branches created:
  - Airtel (tenant/airtel) from v1.0.0, owned by Rahul.
  - TATA (tenant/tata) from v1.1.0, owned by Sameer.
  - Reliance (tenant/reliance) from v1.0.0 pre-stabilization, owned by Vikram.
- Drift reflects different adoption speeds.
EOF
git add USER_STORY.md
git commit -m "USER_STORY: document tenant drift and branch creation"
```
- Author: Priya

**End Scenario 5**:
- Branches: main, release/v1.0.0, release/v1.1.0, tenant/airtel, tenant/tata, tenant/reliance.
- Each tenant branch has an overrides file.

---

### Scenario 6 — Top-down hotfix flow
Simulate an upstream/release-level fix propagating downward. We'll create a hotfix on `release/v1.0.0` (since Airtel is on that). Example: fix for DHCP stale lease issue found in INC-001? Wait INC-001 was telemetry, but we can create a new fix. Let's do: "DHCP: reduce stale lease retention during HA failover" was already done on main earlier, but not in v1.0.0. So we can apply that fix to v1.0.0 as a hotfix. That would be a top-down propagation: the fix exists on main but was not backported; now we create a hotfix branch from release/v1.0.0, apply the same change, tag it, package it, then propagate to main (but main already has it, so cherry-pick might be redundant; but propagation to tenant/airtel is important). Let's do: fix origin on main already? Actually the fix "reduce stale lease retention during HA failover" was done on main in Scenario 1 (commit by Rahul). Release/v1.0.0 was cut before that fix, so the release does not have it. So it's a perfect candidate for a hotfix that propagates from main to release line. The flow: we want a top-down flow: upstream fix (main) propagating downward. So we can simulate: create a hotfix branch from release/v1.0.0, cherry-pick that specific commit from main, tag, archive, install script, then propagate to tenant/airtel (as it's on v1.0.0), maybe also to tenant/reliance, and note that TATA (on v1.1.0) already has it because v1.1.0 includes it. Update USER_STORY.

**Plan**:
1. Identify commit on main: the DHCP stale lease commit. Let's get its hash (we'll assume we can). We'll cherry-pick onto `hotfix/v1.0.0-hf001` from `release/v1.0.0`.
2. Tag `hotfix-v1.0.0-hf001`.
3. Create archive of changed files relative to release/v1.0.0 (only `ops/dhcp-principles.md` changed).
4. Create install script `install-hf001.sh`.
5. Then cherry-pick the fix to `tenant/airtel` and `tenant/reliance` (since both on v1.0.0). Exclude TATA.
6. Update USER_STORY.

Authors: Rahul will own this hotfix.

#### Sub-step 6.1 – Create hotfix branch and cherry-pick
```bash
git checkout -b hotfix/v1.0.0-hf001 release/v1.0.0
# Find the commit: we'll assume it's the one with message "DHCP: reduce stale lease retention during HA failover"
git cherry-pick <commit-hash-of-that-fix>
```
Let's assume the cherry-pick applies cleanly. The change is an addition to `ops/dhcp-principles.md`. After cherry-pick, commit remains authored by Rahul (cherry-pick preserves author). So author Rahul. We'll commit with same message.

#### Sub-step 6.2 – Tag hotfix
```bash
git tag hotfix-v1.0.0-hf001
```

#### Sub-step 6.3 – Create archive
We'll create a directory `packaging/hf001/` and generate an archive containing only the changed file relative to v1.0.0. We'll add a manifest.
```bash
mkdir -p packaging/hf001
cp ops/dhcp-principles.md packaging/hf001/
cd packaging
tar -czf hf001.tar.gz hf001
cd ..
```
Then add the archive and manifest to the hotfix branch? The AGENTS.md says: "Compare the hotfix branch against the base release. Create a compact archive containing ONLY the changed files relative to that release." We'll do that as an artifact; we can commit the archive into the hotfix branch or into a separate `packaging` area on the branch? We'll commit the packaging artifacts in the hotfix branch itself.
```bash
cat > packaging/hf001/MANIFEST.txt <<EOF
hotfix-v1.0.0-hf001
base: v1.0.0
changes:
  ops/dhcp-principles.md
EOF
git add packaging/hf001/ packaging/hf001.tar.gz
git commit -m "HOTFIX: package hf001 archive and manifest"
```
- Author: Rahul

#### Sub-step 6.4 – Create install script
```bash
cat > packaging/hf001/install.sh <<EOF
#!/bin/bash
# Hotfix HF001 install script (simulation)
echo "Backing up /opt/appliance/ops/dhcp-principles.md"
cp /opt/appliance/ops/dhcp-principles.md /opt/appliance/backup/dhcp-principles.md.bak
cp packaging/hf001/ops/dhcp-principles.md /opt/appliance/ops/dhcp-principles.md
echo "Hotfix applied"
EOF
git add packaging/hf001/install.sh
git commit -m "INSTALL: add dummy install script for hf001"
```
- Author: Rahul

Now the hotfix branch has the fix, tag, package archive, script.

#### Sub-step 6.5 – Propagate to tenant branches
According to AGENTS.md: "Only AFTER packaging: cherry-pick or merge the fix back into: main, release lines, or tenant branches as appropriate." Here the fix is already on main (upstream); we should propagate to tenant/airtel and tenant/reliance. We'll cherry-pick the fix commit (the one that changes dhcp-principles.md) into those branches.
```bash
git checkout tenant/airtel
git cherry-pick <fix-commit-hash>
# Expect the file already exists but might need minor conflict? We'll assume clean.
git commit # with cherry-pick message
```
Will commit as Rahul (author preserved). Then for Reliance:
```bash
git checkout tenant/reliance
git cherry-pick <fix-commit-hash>
git commit
```

#### Sub-step 6.6 – Update USER_STORY on main
We'll record all these actions.
```bash
git checkout main
cat >> USER_STORY.md <<EOF

## 2025-09-20 – Top-down hotfix hf001
- Rahul created hotfix/v1.0.0-hf001 from release/v1.0.0, backporting DHCP stale lease retention reduction.
- Tagged hotfix-v1.0.0-hf001.
- Created archive and install script.
- Cherry-picked to tenant/airtel and tenant/reliance.
- TATA (on v1.1.0) already includes this fix, so no action.
- Reliance received despite being on older baseline.
EOF
git add USER_STORY.md
git commit -m "USER_STORY: record top-down hotfix hf001 and propagation"
```
- Author: Priya

**End Scenario 6**: Branches updated; tags created.

---

### Scenario 7 — Bottom-up hotfix flow
Tenant emergency fix propagating upward. Example: Airtel encounters a specific issue with DHCP failover on their conservative settings; they need an override that changes MCLT from 60s to 45s. This fix starts from tenant branch, then evaluated for upstream propagation.

**Plan**:
- Identify issue: Airtel reports DHCP failover taking too long due to MCLT 60s.
- Create tenant hotfix branch `tenant/airtel-hf001` from `tenant/airtel`.
- Modify `tenants/airtel/overrides.md` to change MCLT to 45s, add a note.
- Commit (author Rahul).
- Tag `tenant-airtel-hf001`.
- Create archive and install script (only changed file overrides.md).
- Decision: fix is tenant-specific, not propagated upstream because it's a customer tuning. So no propagation to release/main. Update USER_STORY.
- But the scenario says "This is one of the most important CHF workflows. Simulate realistic operational hesitation and validation delays." So we might delay propagation. Here we'll keep it tenant-only for now.

#### Sub-step 7.1 – Create tenant hotfix branch
```bash
git checkout -b tenant/airtel-hf001 tenant/airtel
```

#### Sub-step 7.2 – Apply fix
Edit `tenants/airtel/overrides.md` to change MCLT line: `- DHCP failover: conservative MCLT (45s)` and add `- MCLT reduced to 45s after incident review`.
```bash
# modify file
git add tenants/airtel/overrides.md
git commit -m "AIRTEL: adjust DHCP failover MCLT to 45s for faster recovery"
```
- Author: Rahul

#### Sub-step 7.3 – Tag
```bash
git tag tenant-airtel-hf001
```

#### Sub-step 7.4 – Archive and install script
Compare against tenant/airtel baseline (the commit before the fix). We'll create packaging similarly.
```bash
mkdir -p packaging/airtel-hf001
cp tenants/airtel/overrides.md packaging/airtel-hf001/
cat > packaging/airtel-hf001/MANIFEST.txt <<EOF
tenant-airtel-hf001
base: tenant/airtel pre-fix
changes:
  tenants/airtel/overrides.md
EOF
tar -czf packaging/airtel-hf001.tar.gz packaging/airtel-hf001
cat > packaging/airtel-hf001/install.sh <<EOF
#!/bin/bash
echo "Backing up Airtel overrides..."
cp /opt/appliance/tenants/airtel/overrides.md /opt/appliance/backup/
cp packaging/airtel-hf001/tenants/airtel/overrides.md /opt/appliance/tenants/airtel/
echo "Airtel HF001 applied"
EOF
git add packaging/airtel-hf001/ packaging/airtel-hf001.tar.gz
git commit -m "INSTALL: add archive and script for tenant-airtel-hf001"
```
- Author: Rahul

#### Sub-step 7.5 – Decision and USER_STORY
We'll record the decision to keep tenant-only. Update USER_STORY on main.
```bash
git checkout main
cat >> USER_STORY.md <<EOF

## 2025-09-25 – Bottom-up hotfix for Airtel
- Rahul created tenant/airtel-hf001 to reduce MCLT to 45s (Airtel request).
- Tagged tenant-airtel-hf001, created archive and install script.
- Decision: fix remains tenant-only; not suitable for general release due to aggressive tuning.
- Validation period 2 weeks before considering broader propagation.
EOF
git add USER_STORY.md
git commit -m "USER_STORY: record Airtel tenant hotfix and containment decision"
```
- Author: Priya

**End Scenario 7**: New branch and tag; no propagation to main.

---

### Scenario 8 — CHF creation (Consolidated Hot Fix)
Create a CHF that bundles approved fixes for v1.0.0 line. It will include the top-down hf001 (stale lease reduction) and perhaps another hotfix from a different area, but exclude the Airtel tenant-specific tuning. We'll simulate a second hotfix that exists: maybe a DNS fix for a hypothetical issue. But we need to create another hotfix first, or we can assume one already exists? The scenario says "Selectively pull approved fixes from multiple hotfixes." So we'll create a quick second hotfix on release/v1.0.0, e.g., "DNS: increase recursion timeout for slow links" authored by Neha. Then we'll create a CHF branch `chf/v1.0.0-chf-001` from `release/v1.0.0`, cherry-pick both hotfix commits, exclude Airtel tenant fix, consolidate, tag, archive, install script, then update USER_STORY.

**Plan**:
1. Create another hotfix on release/v1.0.0: `hotfix/v1.0.0-hf002` for DNS timeout. Simulate quickly.
   - Branch from release/v1.0.0, modify `ops/dns-recursion.md` to add "Recursion timeout increased to 3s for satellite links".
   - Author: Neha.
   - Tag `hotfix-v1.0.0-hf002`.
   - Package (optional, we'll mention). But we can just create the hotfix branch and commit, then CHF will cherry-pick it.
2. Create CHF branch `chf/v1.0.0-chf-001` from `release/v1.0.0`.
3. Cherry-pick commits from hf001 and hf002 onto CHF branch. Resolve if needed.
4. Tag `chf-v1.0.0-chf-001`.
5. Create consolidated archive containing both changed files: `ops/dhcp-principles.md` and `ops/dns-recursion.md`.
6. Create install script.
7. Update USER_STORY documenting inclusion/exclusion reasons.
Then propagate CHF to tenant/airtel and tenant/reliance (which are on v1.0.0). TATA already on v1.1.0 may not need. We'll do that as part of Scenario 9 maybe, but this scenario focuses on CHF creation. We'll include propagation to tenants later.

#### Sub-step 8.1 – Second hotfix hf002
```bash
git checkout -b hotfix/v1.0.0-hf002 release/v1.0.0
```
Edit `ops/dns-recursion.md` to add a line: "- Recursion timeout increased to 3s for high-latency links".
Commit:
```bash
git add ops/dns-recursion.md
git commit -m "DNS: increase recursion timeout for satellite links"
```
- Author: Neha
```bash
git tag hotfix-v1.0.0-hf002
```
Package it quickly (add archive and install script) as per pattern.
```bash
mkdir -p packaging/hf002
cp ops/dns-recursion.md packaging/hf002/
cat > packaging/hf002/MANIFEST.txt <<EOF
hotfix-v1.0.0-hf002
base: v1.0.0
changes:
  ops/dns-recursion.md
EOF
tar -czf packaging/hf002.tar.gz packaging/hf002
cat > packaging/hf002/install.sh <<EOF
#!/bin/bash
echo "Backing up DNS ops..."
cp /opt/appliance/ops/dns-recursion.md /opt/appliance/backup/
cp packaging/hf002/ops/dns-recursion.md /opt/appliance/ops/
echo "HF002 applied"
EOF
git add packaging/hf002/ packaging/hf002.tar.gz
git commit -m "INSTALL: package hf002 DNS timeout hotfix"
```
- Author: Neha

#### Sub-step 8.2 – Create CHF branch and cherry-pick
```bash
git checkout -b chf/v1.0.0-chf-001 release/v1.0.0
git cherry-pick <hf001-fix-commit> <hf002-fix-commit>
```
Assuming clean. These commits bring the changes. Then commit (cherry-pick messages remain). Now we need a consolidation commit? The instructions: "Commit realistic consolidation changes." We can add a CHF note file.
```bash
cat > CHF.md <<EOF
# CHF v1.0.0-chf-001
- Includes: hf001 (DHCP stale lease reduction), hf002 (DNS recursion timeout)
- Excludes: tenant-airtel-hf001 (tenant-specific tuning)
- Approved by: Priya
EOF
git add CHF.md
git commit -m "CHF: add consolidation note for chf-001"
```
- Author: Priya (release engineer)

#### Sub-step 8.3 – Tag
```bash
git tag chf-v1.0.0-chf-001
```

#### Sub-step 8.4 – Archive and install script
```bash
mkdir -p packaging/chf001
# copy changed files relative to v1.0.0 base: ops/dhcp-principles.md, ops/dns-recursion.md, CHF.md
cp ops/dhcp-principles.md packaging/chf001/
cp ops/dns-recursion.md packaging/chf001/
cp CHF.md packaging/chf001/
cat > packaging/chf001/MANIFEST.txt <<EOF
chf-v1.0.0-chf-001
base: v1.0.0
changes:
  ops/dhcp-principles.md
  ops/dns-recursion.md
  CHF.md
EOF
tar -czf packaging/chf001.tar.gz packaging/chf001
cat > packaging/chf001/install.sh <<EOF
#!/bin/bash
echo "Applying CHF v1.0.0-chf-001"
cp /opt/appliance/ops/dhcp-principles.md /opt/appliance/backup/
cp /opt/appliance/ops/dns-recursion.md /opt/appliance/backup/
cp packaging/chf001/ops/dhcp-principles.md /opt/appliance/ops/
cp packaging/chf001/ops/dns-recursion.md /opt/appliance/ops/
cp packaging/chf001/CHF.md /opt/appliance/
echo "CHF applied"
EOF
git add packaging/chf001/ packaging/chf001.tar.gz
git commit -m "INSTALL: add CHF archive and install script for chf-001"
```
- Author: Priya

#### Sub-step 8.5 – Update USER_STORY on main
```bash
git checkout main
cat >> USER_STORY.md <<EOF

## 2025-10-01 – CHF creation chf-001
- Priya consolidated hf001 and hf002 into chf/v1.0.0-chf-001, tagged chf-v1.0.0-chf-001.
- Excluded tenant-airtel-hf001 (deemed tenant-specific and not validated for general use).
- Archive and install script created.
- CHF is ready for propagation to tenants on v1.0.0 line.
EOF
git add USER_STORY.md
git commit -m "USER_STORY: document CHF chf-001 creation and exclusion rationale"
```
- Author: Priya

**End Scenario 8**: CHF branch created with tag and packaging.

---

### Scenario 9 — Propagation and long-term drift
We'll now propagate CHF to tenants on v1.0.0 (Airtel and Reliance). Then simulate additional selective propagations: maybe a hotfix that is release-only, a delayed cherry-pick, a rejected backport, etc. We'll also update USER_STORY.

**Plan**:
1. Cherry-pick CHF commits (the combined changes) onto `tenant/airtel` and `tenant/reliance`. Since CHF is a set of two changes, we can cherry-pick the CHF branch tip (which has both changes and CHF.md) onto those tenants. That simulates applying the CHF bundle.
2. Mark that TATA (on v1.1.0) already has these fixes (since they are from v1.1.0? Actually hf001 and hf002 are fixes on v1.0.0 line; v1.1.0 may not include the DNS timeout increase as it was added after v1.1.0. We need to be realistic. v1.1.0 was cut before these hotfixes. So they don't have them either. So we could propagate CHF to TATA as well? But TATA is on v1.1.0, a different release line; a CHF for v1.0.0 is not directly applicable. They would need a separate CHF or backport. We'll leave TATA without these fixes for now, to show drift. Later we might port them via a separate process.
3. Simulate a release-only hotfix that never reaches tenants: e.g., a fix to the appliance recovery process that only applies to the core platform, not customer-specific. We'll create a hotfix on release/v1.1.0, but not propagate to tenant/tata because it's not needed. Tag it, package, and then decide not to push to tenants. Update USER_STORY.
4. Simulate a delayed cherry-pick: a fix from main (like the aggressive failover warning from Scenario 3) eventually backported to release/v1.0.0 after validation. That will be a late backport. Show hesitation.
5. Simulate a patch-on-patch: a hotfix that fixes a regression in a previous hotfix. Show complexity.

We'll implement a selection to demonstrate realistic chaos.

#### Sub-step 9.1 – Propagate CHF to tenant/airtel
```bash
git checkout tenant/airtel
git cherry-pick chf/v1.0.0-chf-001
# This brings all three commits (the two fix commits and the consolidation commit). 
```
If conflicts, resolve. Then commit.

```bash
git commit
```
- Author remains original (Rahul for hf001, Neha for hf002, Priya for consolidation). Commits will be cherry-picked with original authorship.
We need to note in USER_STORY.

#### Sub-step 9.2 – Propagate CHF to tenant/reliance
```bash
git checkout tenant/reliance
git cherry-pick chf/v1.0.0-chf-001
```

#### Sub-step 9.3 – Release-only hotfix on v1.1.0
```bash
git checkout -b hotfix/v1.1.0-hf003 release/v1.1.0
```
Create a fix: adjust appliance recovery watchdog to 90s. Edit `ops/appliance-recovery.md` (exists from Scenario 1 on main; v1.1.0 includes all upstream files, so this file exists on release/v1.1.0).
```bash
# add line: "- Watchdog reduced to 90s for faster failover detection"
git add ops/appliance-recovery.md
git commit -m "Appliance: reduce watchdog timer to 90s"
```
- Author: Vikram
Tag `hotfix-v1.1.0-hf003`.
Package (archive, install).
```bash
mkdir -p packaging/hf003
cp ops/appliance-recovery.md packaging/hf003/
... tar and script
git add packaging/hf003/ packaging/hf003.tar.gz
git commit -m "INSTALL: package hf003 watchdog hotfix"
```
Then decide: this fix is release-platform-only, not tenant-specific, so not propagated to tenant/tata or others. Update USER_STORY.

#### Sub-step 9.4 – Delayed backport: aggressive failover warning to v1.0.0
On main we had an aggressive failover doc and incident. The fix was to add a warning; maybe we want to backport the warning to v1.0.0 after validation. So we'll create a hotfix branch from release/v1.0.0 to add the warning note to `ops/dhcp-failover-aggressive.md` (which doesn't exist on v1.0.0). That file was introduced in Scenario 3. To backport, we'd need to bring the file with just the warning. We'll simulate a backport with hesitation: after 3 weeks, finally done.

```bash
git checkout -b hotfix/v1.0.0-hf004 release/v1.0.0
# Bring the file ops/dhcp-failover-aggressive.md from main but edited to only include the warning.
cat > ops/dhcp-failover-aggressive.md <<EOF
# Aggressive DHCP Failover Warning
- Not recommended for WAN
- Risk of split-brain
- Default remains conservative
EOF
git add ops/dhcp-failover-aggressive.md
git commit -m "DHCP: backport aggressive failover warning to v1.0.0"
```
- Author: Rahul
Tag `hotfix-v1.0.0-hf004`, package, then propagate to tenant/airtel and tenant/reliance. Update USER_STORY.

#### Sub-step 9.5 – Patch-on-patch: regression fix on hf001
Simulate that hf001 introduced a bug: stale lease reduction caused lease storms. Create a quick hotfix `hotfix/v1.0.0-hf005` from release/v1.0.0 that re-adjusts retention to 3h (a compromise). Cherry-pick to tenants after testing.
```bash
git checkout -b hotfix/v1.0.0-hf005 release/v1.0.0
# modify ops/dhcp-principles.md line: change retention to 3h
git add ops/dhcp-principles.md
git commit -m "DHCP: adjust stale lease retention to 3h to mitigate hf001 regression"
```
- Author: Rahul
Tag, package, then propagate to tenants that received hf001 (airtel and reliance). Show in USER_STORY.

#### Sub-step 9.6 – Update USER_STORY with all propagation decisions
We'll do a comprehensive update after all these actions on main.
```bash
git checkout main
cat >> USER_STORY.md <<EOF

## 2025-10-05 – Propagation and drift actions
- CHF chf-001 applied to tenant/airtel and tenant/reliance.
- Release-only hotfix hf003 (watchdog) not propagated to tenants; remains platform fix.
- Delayed backport hf004 (aggressive failover warning) to v1.0.0 line after 3-week validation.
- Patch-on-patch hf005 to fix regression from hf001, applied to Airtel and Reliance.
- TATA remains on v1.1.0 with its own drift; some fixes still missing on v1.1.0 line.
- Backlog of unpropagated fixes grows; sustaining team reviews CHF bundling for next cycle.
EOF
git add USER_STORY.md
git commit -m "USER_STORY: final chronicle of propagation and drift"
```
- Author: Priya

**End Scenario 9**: Complex topology with selective propagation, drift, and patch-on-patch.

---

### Final repository overview
At the end, we have a realistic tree. I'll present the directory structure and branch/tag list.

**Directory structure** (on main after final commit):
```
.
├── README.md
├── USER_STORY.md
├── CHF.md (on main? No, only on CHF branch. main doesn't have it. We'll not include.)
├── docs/
│   └── platform-overview.md
├── incidents/
│   ├── incident-000.md
│   ├── incident-001.md
│   └── incident-002.md
├── ops/
│   ├── appliance-recovery.md
│   ├── dhcp-failover-aggressive.md
│   ├── dhcp-principles.md
│   ├── dns-performance-tuning.md
│   ├── dns-recursion.md
│   ├── ipam-sync.md
│   ├── observability-tips.md
│   └── telemetry-reconnect.md
├── releases/
│   ├── v1.0.0.md
│   ├── v1.1.0.md
│   ├── stabilization-v1.0.0.md
│   └── stabilization-v1.1.0.md
├── tenants/ (only on tenant branches; main doesn't have tenant-specific files)
└── packaging/ (various archives and scripts on hotfix/CHF branches)
```
On main, no tenant overrides or packaging directories because those were created on other branches. The release notes directory exists on release branches. The above is main's current state. The tenant branches have tenant overrides and cherry-picked changes.

**Branches**:
- main
- release/v1.0.0
- release/v1.1.0
- tenant/airtel
- tenant/tata
- tenant/reliance
- hotfix/v1.0.0-hf001
- hotfix/v1.0.0-hf002
- hotfix/v1.0.0-hf004
- hotfix/v1.0.0-hf005
- hotfix/v1.1.0-hf003
- tenant/airtel-hf001
- chf/v1.0.0-chf-001

**Tags**:
- v1.0.0
- v1.1.0
- hotfix-v1.0.0-hf001
- hotfix-v1.0.0-hf002
- tenant-airtel-hf001
- chf-v1.0.0-chf-001
- hotfix-v1.1.0-hf003
- hotfix-v1.0.0-hf004
- hotfix-v1.0.0-hf005

All commits have fictional Indian authors consistent with the storyline. The repository demonstrates top-down, bottom-up, CHF consolidation, selective propagation, drift, and realistic operational noise.
