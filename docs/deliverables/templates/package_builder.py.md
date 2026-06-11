# `package_builder.py` template

## Purpose

Turn a validated diff manifest into a deployable bundle.

## CLI surface

- `build --manifest <path> --layout <layout> --outdir <dir>`

## Behavioral rules

- consume only validated diff outputs
- copy only approved files
- create install and rollback scripts
- produce a manifest and checksum file
- refuse to guess missing destination layouts

## Output contract

The build command should return JSON describing:

- archive path
- checksum
- files packed
- validation result
- blockers
