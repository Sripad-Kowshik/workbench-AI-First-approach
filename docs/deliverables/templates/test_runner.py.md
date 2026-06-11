# `test_runner.py` template

## Purpose

Run the repository test command in a deterministic way and surface failures.

## CLI surface

- `--cmd <command>`
- optional default from `CHF_TEST_CMD`

## Behavioral rules

- log test start and finish to `CHF-STATE.md`
- fail if no test command is available
- print JSON success or JSON error
- never hide stderr/stdout on failure

## Output contract

Return a JSON object with:

- status
- output or failure text
- exit-aware logging in `CHF-STATE.md`
