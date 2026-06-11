# `state_manager.py` template

## Purpose

Maintain run state, log steps, emit artifacts, and write escalation payloads.

## CLI surface

- `init --task-id <id>`
- `step --cmd <cmd> --code <exit> --summary <summary>`
- `log --event <event> --data <json>`
- `emit --artifact <name> --data <json>`
- `escalate --reason <reason> --message <message> --input-type <text|options>`

## Behavioral rules

- always write to `CHF-STATE.md`
- store emitted artifacts under `output/`
- record structured escalation payloads under `output/escalation.json`
- print machine-readable JSON on stdout
