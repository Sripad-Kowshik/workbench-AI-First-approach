# Typical lifecycle of a CHF

Let us take the scenario of there being a `main` branch, and branches `1.1`, `1.2`, `1.3` with respective releases `release-1.1`, `release-1.2`, `release-1.3` derieved from `main`. A typical CHF lifecycle would be:
1. Bug(s) are discovered by QA, support, or monitoring. The bug report(s) are filed for them. Say bugs A, and B on version 1.2.
2. The bugs are triaged by identifying the versions of the product and reproducing the bug.
3. Regression tests and other tests are written.
4. The hotfixes for A, and B are developed, and tested. Then they are packaged as CHF and released as say `release-1.2.1`.
5. Next, the same scenarios are run on other branches and `main` to see where else the same bugs exist. The same test suites may not apply to these other branches. Then, test cases for them should be written separately or adapted accordingly. Let us say bug A exists only on `1.1` and `1.2`, and B exists on `1.2`, `1.3`, and `main`. This means at some point between `1.2` and `1.3` A was resolved.
6. Then, depending on the codebase and the patch itself, it will be decided if the fix is forward-ported, back-ported, or reimplemented. For example, if the code in `1.2` is backward compatible with `1.1` with respect to the bug A (that is the codepaths and the signatures match), the patch for bug A can directly be back-ported to branch `1.1`. For say bug B, is then compatible with `1.3` but not with `main` as it has progressed, then the patch can be forward ported from `1.2` to `1.3`, but should be reimplmented for `main`.
7. The applied patches or implementations are then tested and if necessary, released.
8. If a version is EOL, then it doesn't get tested for the bug and doesn't get a fix.
9. Finally, the bug report is marked as done and closed.

```mermaid
flowchart TD
    A["Bug(s) discovered<br/>by QA / Support / Monitoring"] --> B[Triage<br/>Reproduce and identify affected versions]
    B --> C[Write regression tests<br/>for the affected release branch]
    C --> D["Develop and test hotfix(es)<br/>on release-1.2"]
    D --> E[Bundle fixes into a CHF<br/>e.g. 1.2.1]
    E --> F[Release hotfix for the affected branch]

    F --> G[Test the same scenario on other branches and main]
    G --> H{Is the bug present<br/>in that branch?}

    H -- No --> I[No fix needed there]
    H -- Yes --> J{Is the branch supported?}

    J -- No --> K[EOL branch<br/>No fix / no further testing]
    J -- Yes --> L{Can the same patch apply cleanly?}

    L -- Yes --> M[Back-port / Forward-port<br/>via cherry-pick or merge]
    L -- No --> N[Reimplement / adapt fix<br/>for that branch]

    M --> O[Test branch-specific fix]
    N --> O
    O --> P[Release branch-specific patch<br/>e.g. 1.1.1 / 1.3.1 / mainline fix]

    P --> Q[Propagate fix to main<br/>so future releases include it]
    I --> Q
    Q --> R[Mark bug report done and close it]
```
```
gitGraph
   commit id: "v1.0"
   
   branch branch-1.1
   checkout branch-1.1
   commit id: "release-1.1"
   
   checkout main
   branch branch-1.2
   checkout branch-1.2
   commit id: "release-1.2"
   
   checkout main
   branch branch-1.3
   checkout branch-1.3
   commit id: "release-1.3"
   
   checkout main
   commit id: "v2.0"
   
   %% CHF branch
   checkout branch-1.2
   branch CHF/bugs-A-B
   checkout CHF/bugs-A-B
   commit id: "Bug A & B reported"
   commit id: "Triaged & reproduced"
   commit id: "Write tests"
   commit id: "Develop & test fixes"
   
   checkout branch-1.2
   merge CHF/bugs-A-B
   commit id: "release-1.2.1" tag: "CHF v1.2.1"
   
   %% Port fixes
   checkout branch-1.1
   commit id: "Back-port Bug A" tag: "from 1.2"
   commit id: "Test Bug A"
   
   checkout branch-1.3
   commit id: "Forward-port Bug B" tag: "from 1.2"
   commit id: "Test Bug B"
   
   checkout main
   branch reimpl/B
   checkout reimpl/B
   commit id: "Reimplement Bug B"
   commit id: "Test"
   
   checkout main
   merge reimpl/B
   commit id: "Bug B complete"
   
   checkout branch-1.1
   commit id: "EOL - v1.1"
   commit id: "All bugs closed"
```
