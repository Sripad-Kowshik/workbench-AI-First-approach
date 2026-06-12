# State, audit, and replay

## Audit trail

All actions should be recoverable from text artifacts. The run log is the source of truth for human review.

## State file

`CHF-STATE.md` should record:

- initialization timestamp
- branch resolution results
- git command steps
- test execution results
- emitted artifact locations
- escalation payloads
- final readiness state

## Replayability

The deterministic scripts should make it possible to replay the same actions in a sandbox and reach the same output.

## Logging discipline

Prefer structured JSON payloads for machine-readable events and keep prose to a minimum.

## Human override

If `STEER.md` exists, the agents should treat it as a live steering instruction, incorporate it, log the change, and remove the file.
