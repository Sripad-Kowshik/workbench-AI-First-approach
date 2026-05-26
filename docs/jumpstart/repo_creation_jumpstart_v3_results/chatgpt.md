# Scenario 0 — Bootstrap upstream

## Current repo state

```bash
$ pwd
~/workspace/HCF-agentic-testbed

$ git branch -a
fatal: not a git repository

$ mkdir HCF-agentic-testbed
$ cd HCF-agentic-testbed
$ git init -b main
Initialized empty Git repository
```

## Plan

1. Create baseline telecom appliance repo structure.
2. Add compact operational/service configuration artifacts.
3. Add initial sustaining workflow notes and USER_STORY.md.
4. Commit bootstrap baseline.

---

## Sub-step 0.1 — Create baseline repo structure

Author: Vikram

### Files created

```text
README.md
services/dns/cache.conf
services/dhcp/failover.conf
services/ipam/sync.conf
ops/release-workflow.md
ops/sustaining-model.md
USER_STORY.md
```

### Relevant directory structure

```text
HCF-agentic-testbed/
├── README.md
├── USER_STORY.md
├── ops/
│   ├── release-workflow.md
│   └── sustaining-model.md
└── services/
    ├── dhcp/
    │   └── failover.conf
    ├── dns/
    │   └── cache.conf
    └── ipam/
        └── sync.conf
```

### Example file contents

`README.md`

```md
# HCF Agentic Testbed

Simulated telecom DNS/DHCP/IPAM appliance repository.

Used for:
- sustaining engineering
- CHF orchestration
- hotfix propagation
- tenant drift testing

Supported tenants:
- Airtel
- Reliance
- TATA
```

`services/dhcp/failover.conf`

```conf
lease_retention_hours=48
peer_timeout_ms=2500
failover_mode=active-passive
```

`USER_STORY.md`

```md
## 2026-05-26

- Vikram initialized telecom appliance baseline.
- Repo prepared for future release engineering workflows.
- Tenant support model established for Airtel, Reliance, and TATA.
```

### Git commands used

```bash
git add README.md
git add services/dns/cache.conf
git add services/dhcp/failover.conf
git add services/ipam/sync.conf
git add ops/release-workflow.md
git add ops/sustaining-model.md
git add USER_STORY.md

git commit -m "Bootstrap telecom appliance sustaining baseline" \
  --author="Vikram <vikram@telecom-corp.local>"
```

### Commit result

```text
[main (root-commit) a1f3c21] Bootstrap telecom appliance sustaining baseline
 Author: Vikram <vikram@telecom-corp.local>
```

---

# Scenario 1 — Upstream evolves

## Current repo state

```bash
$ git branch -a
* main

$ git tag

$ git log --oneline -10
a1f3c21 Bootstrap telecom appliance sustaining baseline
```

## Plan

1. Add DHCP HA tuning note.
2. Add DNS recursion/cache operational tuning.
3. Add telemetry reconnect handling.
4. Add incident notes and observability guidance.
5. Update USER_STORY.md incrementally.

---

## Sub-step 1.1 — DHCP failover tuning

Author: Priya

### Files changed

```text
services/dhcp/failover.conf
ops/dhcp-ha-note.md
USER_STORY.md
```

### Changes

`services/dhcp/failover.conf`

```diff
- lease_retention_hours=48
+ lease_retention_hours=24
+ stale_cleanup_interval_sec=300
```

`ops/dhcp-ha-note.md`

```md
# DHCP HA

Reduced stale lease retention after HA peer failover.

Observed duplicate reservation buildup during node flap tests.
```

### Git commands used

```bash
git add services/dhcp/failover.conf
git add ops/dhcp-ha-note.md
git add USER_STORY.md

git commit -m "DHCP: reduce stale lease retention during HA failover" \
  --author="Priya <priya@telecom-corp.local>"
```

### Commit result

```text
[main 8be7dd2] DHCP: reduce stale lease retention during HA failover
 Author: Priya <priya@telecom-corp.local>
```

---

## Sub-step 1.2 — DNS cache tuning

Author: Rahul

### Files changed

```text
services/dns/cache.conf
ops/dns-recursion-note.md
USER_STORY.md
```

### Changes

`services/dns/cache.conf`

```diff
+ recursion_clients=1200
+ cache_lock_retry_ms=15
```

### Git commands used

```bash
git add services/dns/cache.conf
git add ops/dns-recursion-note.md
git add USER_STORY.md

git commit -m "DNS: document cache lock contention mitigation" \
  --author="Rahul <rahul@telecom-corp.local>"
```

### Commit result

```text
[main b1e021e] DNS: document cache lock contention mitigation
 Author: Rahul <rahul@telecom-corp.local>
```

---

## Sub-step 1.3 — Telemetry reconnect behavior

Author: Sameer

### Files changed

```text
services/telemetry/reconnect.conf
ops/telemetry-reconnect.md
USER_STORY.md
```

### Relevant structure update

```text
services/
└── telemetry/
    └── reconnect.conf
```

### Git commands used

```bash
mkdir -p services/telemetry

git add services/telemetry/reconnect.conf
git add ops/telemetry-reconnect.md
git add USER_STORY.md

git commit -m "Telemetry: add reconnect throttling guidance" \
  --author="Sameer <sameer@telecom-corp.local>"
```

### Commit result

```text
[main c4d88f0] Telemetry: add reconnect throttling guidance
 Author: Sameer <sameer@telecom-corp.local>
```

---

## Sub-step 1.4 — Incident note and observability

Author: Neha

### Files changed

```text
ops/incidents/INC-1042-cache-pressure.md
ops/observability-tuning.md
USER_STORY.md
```

### Git commands used

```bash
mkdir -p ops/incidents

git add ops/incidents/INC-1042-cache-pressure.md
git add ops/observability-tuning.md
git add USER_STORY.md

git commit -m "Observability: add cache pressure incident guidance" \
  --author="Neha <neha@telecom-corp.local>"
```

### Commit result

```text
[main d22ab10] Observability: add cache pressure incident guidance
 Author: Neha <neha@telecom-corp.local>
```

---

# Scenario 2 — First release cut

## Current repo state

```bash
$ git branch -a
* main

$ git log --oneline -10
d22ab10 Observability: add cache pressure incident guidance
c4d88f0 Telemetry: add reconnect throttling guidance
b1e021e DNS: document cache lock contention mitigation
8be7dd2 DHCP: reduce stale lease retention during HA failover
a1f3c21 Bootstrap telecom appliance sustaining baseline
```

## Plan

1. Cut release/v1.0.0 branch.
2. Add stabilization note.
3. Tag official release baseline.
4. Update USER_STORY.md.

---

## Sub-step 2.1 — Release cut and stabilization

Author: Arvind

### Git commands used

```bash
git checkout -b release/v1.0.0

mkdir -p releases/v1.0.0

git add releases/v1.0.0/RELEASE.md
git add releases/v1.0.0/STABILIZATION.md
git add USER_STORY.md

git commit -m "Release: prepare v1.0.0 stabilization baseline" \
  --author="Arvind <arvind@telecom-corp.local>"

git tag v1.0.0
```

### Commit result

```text
[release/v1.0.0 e912bc1] Release: prepare v1.0.0 stabilization baseline
 Author: Arvind <arvind@telecom-corp.local>
```

### Repo state

```bash
$ git branch -a
  main
* release/v1.0.0

$ git tag
v1.0.0
```

---

# Scenario 3 — Upstream diverges further

## Current repo state

```bash
$ git checkout main

$ git branch -a
* main
  release/v1.0.0

$ git tag
v1.0.0
```

## Plan

1. Add newer IPAM improvements.
2. Add appliance recovery workflow.
3. Add new incident note.
4. Record backport complexity.

---

## Sub-step 3.1 — IPAM sync optimization

Author: Tanuja

### Files changed

```text
services/ipam/sync.conf
ops/ipam-resync.md
USER_STORY.md
```

### Git commands used

```bash
git add services/ipam/sync.conf
git add ops/ipam-resync.md
git add USER_STORY.md

git commit -m "IPAM: reduce full resync frequency during recovery" \
  --author="Tanuja <tanuja@telecom-corp.local>"
```

---

## Sub-step 3.2 — Appliance recovery workflow

Author: Rajesh

### Files changed

```text
ops/appliance-recovery.md
ops/incidents/INC-1088-node-rejoin.md
USER_STORY.md
```

### Git commands used

```bash
git add ops/appliance-recovery.md
git add ops/incidents/INC-1088-node-rejoin.md
git add USER_STORY.md

git commit -m "Recovery: add appliance node rejoin operational guidance" \
  --author="Rajesh <rajesh@telecom-corp.local>"
```

---

# Scenario 4 — Additional release lines

## Current repo state

```bash
$ git log --oneline -5
8d9af12 Recovery: add appliance node rejoin operational guidance
71bc229 IPAM: reduce full resync frequency during recovery
d22ab10 Observability: add cache pressure incident guidance
```

## Plan

1. Cut release/v1.1.0.
2. Add release notes.
3. Tag release.

---

## Sub-step 4.1 — Create v1.1.0 release line

Author: Kavita

### Git commands used

```bash
git checkout -b release/v1.1.0

mkdir -p releases/v1.1.0

git add releases/v1.1.0/RELEASE.md
git add USER_STORY.md

git commit -m "Release: prepare v1.1.0 rollout baseline" \
  --author="Kavita <kavita@telecom-corp.local>"

git tag v1.1.0
```

---

# Scenario 5 — Tenant drift

## Current repo state

```bash
$ git branch -a
  main
  release/v1.0.0
* release/v1.1.0
```

## Plan

1. Create Airtel tenant branch from v1.0.0.
2. Create Reliance tenant branch from v1.0.0.
3. Create TATA tenant branch from v1.1.0.
4. Add tenant overrides and drift notes.

---

## Sub-step 5.1 — Airtel sustaining branch

Author: Ajay

### Git commands used

```bash
git checkout release/v1.0.0
git checkout -b tenant/airtel

mkdir -p tenant/airtel

git add tenant/airtel/overrides.md
git add USER_STORY.md

git commit -m "AIRTEL: add conservative DHCP failover override" \
  --author="Ajay <ajay@telecom-corp.local>"
```

---

## Sub-step 5.2 — Reliance sustaining branch

Author: Deepak

### Git commands used

```bash
git checkout release/v1.0.0
git checkout -b tenant/reliance

mkdir -p tenant/reliance

git add tenant/reliance/overrides.md
git add USER_STORY.md

git commit -m "RELIANCE: pin legacy recursion concurrency threshold" \
  --author="Deepak <deepak@telecom-corp.local>"
```

---

## Sub-step 5.3 — TATA newer release adoption

Author: Meera

### Git commands used

```bash
git checkout release/v1.1.0
git checkout -b tenant/tata

mkdir -p tenant/tata

git add tenant/tata/overrides.md
git add USER_STORY.md

git commit -m "TATA: enable accelerated telemetry reconnect profile" \
  --author="Meera <meera@telecom-corp.local>"
```

---

# Scenario 6 — Top-down hotfix flow

## Current repo state

```bash
$ git branch -a
  main
  release/v1.0.0
  release/v1.1.0
  tenant/airtel
  tenant/reliance
* tenant/tata

$ git tag
v1.0.0
v1.1.0
```

## Plan

1. Create release hotfix branch from v1.0.0.
2. Apply DNS cache lock fix.
3. Tag hotfix.
4. Package changed files only.
5. Commit packaging artifacts.
6. Cherry-pick into selected branches.
7. Update USER_STORY.md.

---

## Sub-step 6.1 — Create release hotfix

Author: Rahul

### Git commands used

```bash
git checkout release/v1.0.0
git checkout -b hotfix/release/v1.0.0/dns-cache-lock

git add services/dns/cache.conf
git add ops/dns-cache-hotfix.md
git add USER_STORY.md

git commit -m "DNS: reduce cache lock retry amplification during failover" \
  --author="Rahul <rahul@telecom-corp.local>"

git tag v1.0.0-hf-001
```

---

## Sub-step 6.2 — Package hotfix artifacts

Author: Sandeep

### Artifact structure

```text
artifacts/v1.0.0-hf-001/
├── changed-files.txt
├── install-v1.0.0-hf-001.sh
└── package.tar.gz
```

### Git commands used

```bash
mkdir -p artifacts/v1.0.0-hf-001

git diff --name-only v1.0.0..HEAD \
  > artifacts/v1.0.0-hf-001/changed-files.txt

tar -czf artifacts/v1.0.0-hf-001/package.tar.gz \
  services/dns/cache.conf \
  ops/dns-cache-hotfix.md

git add artifacts/v1.0.0-hf-001
git add USER_STORY.md

git commit -m "Hotfix: package v1.0.0-hf-001 deployment bundle" \
  --author="Sandeep <sandeep@telecom-corp.local>"
```

---

## Sub-step 6.3 — Propagate after packaging

Author: Rahul

### Git commands used

```bash
git checkout main
git cherry-pick hotfix/release/v1.0.0/dns-cache-lock

git checkout tenant/airtel
git cherry-pick hotfix/release/v1.0.0/dns-cache-lock
```

### Propagation decision

```text
- Airtel received fix immediately.
- Reliance delayed pending validation.
- TATA excluded because running newer release train.
```

---

# Scenario 7 — Bottom-up hotfix flow

## Plan

1. Create Airtel-specific emergency hotfix.
2. Package tenant fix.
3. Evaluate upward propagation.
4. Cherry-pick selectively.
5. Document hesitation/delay.

---

## Sub-step 7.1 — Tenant emergency fix

Author: Ajay

### Git commands used

```bash
git checkout tenant/airtel
git checkout -b hotfix/tenant/airtel/dhcp-peer-flap

git add tenant/airtel/dhcp-peer-override.conf
git add USER_STORY.md

git commit -m "AIRTEL: mitigate DHCP peer flap under packet loss" \
  --author="Ajay <ajay@telecom-corp.local>"

git tag airtel-v1.0.0-hf-002
```

---

## Sub-step 7.2 — Package Airtel hotfix

Author: Naveen

### Git commands used

```bash
mkdir -p artifacts/airtel-v1.0.0-hf-002

git diff --name-only tenant/airtel..HEAD \
  > artifacts/airtel-v1.0.0-hf-002/changed-files.txt

tar -czf artifacts/airtel-v1.0.0-hf-002/package.tar.gz \
  tenant/airtel/dhcp-peer-override.conf

git add artifacts/airtel-v1.0.0-hf-002
git add USER_STORY.md

git commit -m "Hotfix: package Airtel DHCP peer flap mitigation" \
  --author="Naveen <naveen@telecom-corp.local>"
```

---

## Sub-step 7.3 — Limited upward propagation

Author: Priya

### Git commands used

```bash
git checkout release/v1.0.0
git cherry-pick hotfix/tenant/airtel/dhcp-peer-flap
```

### Operational decision

```text
- Propagated to release/v1.0.0 after validation delay.
- Not propagated to main due to environment-specific behavior.
- Reliance requested additional soak testing.
```

---

# Scenario 8 — CHF creation

## Current repo state

```bash
$ git tag
airtel-v1.0.0-hf-002
v1.0.0
v1.0.0-hf-001
v1.1.0
```

## Plan

1. Create CHF branch from release/v1.0.0.
2. Cherry-pick approved fixes only.
3. Add consolidation manifest.
4. Tag CHF.
5. Package CHF artifacts.
6. Propagate selectively.
7. Update USER_STORY.md.

---

## Sub-step 8.1 — Create CHF branch

Author: Arvind

### Git commands used

```bash
git checkout release/v1.0.0
git checkout -b chf/v1.0.0-002

git cherry-pick v1.0.0-hf-001
git cherry-pick airtel-v1.0.0-hf-002

git add releases/v1.0.0/CHF-002.md
git add USER_STORY.md

git commit -m "CHF: prepare consolidation manifest for v1.0.0-002" \
  --author="Arvind <arvind@telecom-corp.local>"

git tag v1.0.0-chf-002
```

---

## Sub-step 8.2 — Package CHF bundle

Author: Kavita

### Git commands used

```bash
mkdir -p artifacts/v1.0.0-chf-002

git diff --name-only v1.0.0..HEAD \
  > artifacts/v1.0.0-chf-002/changed-files.txt

tar -czf artifacts/v1.0.0-chf-002/package.tar.gz \
  services/dns/cache.conf \
  tenant/airtel/dhcp-peer-override.conf

git add artifacts/v1.0.0-chf-002
git add USER_STORY.md

git commit -m "CHF: package rollout bundle for v1.0.0-chf-002" \
  --author="Kavita <kavita@telecom-corp.local>"
```

---

# Scenario 9 — Propagation and long-term drift

## Plan

1. Delay selected backports.
2. Apply patch-on-patch correction.
3. Maintain tenant divergence.
4. Record operational decisions.

---

## Sub-step 9.1 — Partial rollout correction

Author: Neha

### Git commands used

```bash
git checkout tenant/reliance

git add tenant/reliance/cache-rollback.md
git add USER_STORY.md

git commit -m "RELIANCE: defer DNS cache retry rollout pending soak" \
  --author="Neha <neha@telecom-corp.local>"
```

---

## Final topology snapshot

```text
main
├── release/v1.0.0
│   ├── tenant/airtel
│   │   └── hotfix/tenant/airtel/dhcp-peer-flap
│   ├── tenant/reliance
│   ├── hotfix/release/v1.0.0/dns-cache-lock
│   └── chf/v1.0.0-002
│
└── release/v1.1.0
    └── tenant/tata
```

## Final tags

```bash
v1.0.0
v1.0.0-hf-001
airtel-v1.0.0-hf-002
v1.0.0-chf-002
v1.1.0
```

## Example final branch listing

```bash
$ git branch -a

  main
  release/v1.0.0
  release/v1.1.0
  tenant/airtel
  tenant/reliance
  tenant/tata
  hotfix/release/v1.0.0/dns-cache-lock
  hotfix/tenant/airtel/dhcp-peer-flap
  chf/v1.0.0-002
```
