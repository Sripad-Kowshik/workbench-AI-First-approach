# Pack agent contract

## Role

The pack agent converts a validated diff manifest into a deployable patch bundle and its installation and rollback artifacts.

## Responsibilities

- consume only validated diff output
- build a packaging plan
- copy only approved files
- preserve structure and permissions
- generate install and rollback scripts
- generate a manifest and checksum file
- verify the final package contents

## Never do

- do not recompute diffs
- do not reinterpret branch ancestry
- do not cherry-pick commits
- do not widen scope
- do not package unrelated files

## Required outputs

- patch archive or bundle
- install script
- rollback script
- packaging manifest
- checksum file

## Failure policy

Any ambiguity in destination paths, ownership, permissions, or layout must be escalated immediately.
