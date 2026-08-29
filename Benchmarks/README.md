# PureFIT Benchmarks

Compares PureFIT against Garmin's [fit-objective-c-sdk](https://github.com/garmin/fit-objective-c-sdk).
Kept as its own package so the library picks up no dependency on the Garmin SDK.

```sh
swift run -c release PureFITBenchmark          # primary fixture
swift run -c release PureFITBenchmark --all    # every fixture
swift run -c release PureFITBenchmark --help
```

Always `-c release`. Debug builds measure the optimizer's absence.

## Scenarios

| Scenario | PureFIT | Garmin SDK |
| --- | --- | --- |
| Parse | `RawFITFile` + `PureFITFile`, CRC skipped | `decodeFile:` |
| Parse + validate CRC | `.requireValidCRC` | `checkIntegrity:` then `decodeFile:` |
| Parse + extract GPS | lat/long off every `RecordMessage`, to degrees | `getPositionLat/Long`, to degrees |
| Read developer fields | walk `messages`, parse each developer value | custom delegate counting values as they stream |
| Parse from Data | `RawFITFile(data:)` | — decodes from a file path only |
| Count messages by type | group `messages` by global message number | — listener pre-buckets known types, drops the rest |
| Raw parse (no profile) | `RawFITFile` alone | — no equivalent layer |

`cyclingActivityFromGarmin.fit` contains no developer fields, so `activity_developerdata.fit` is the
fixture that actually exercises them. CI runs both for that reason.

Fixtures come from `Tests/PureFITTests/Fixtures` rather than being duplicated here.

Two details keep the comparison fair. The Garmin decoder runs with a `FITListener` attached so it
builds message objects like PureFIT does — without a delegate it skips that work and looks faster
than it is. And every scenario returns a count that the harness checks, so a library that quietly
parses less fails instead of winning.

## Regression gate

`budget.json` caps PureFIT's own median time per scenario:

```sh
swift run -c release PureFITBenchmark --check budget.json
```

Budgets are absolute, not measured against the Garmin SDK — a release of theirs shouldn't be able to
move our pass mark. CI runs about 3x slower than a local M-series Mac and shared runners vary, so the
numbers sit well above observed CI times and catch gross regressions, not drift.

Raise one only for a deliberate trade, and say so in the PR.
