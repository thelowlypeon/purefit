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

## Regression check

`budget.json` caps PureFIT's own median time per scenario:

```sh
swift run -c release PureFITBenchmark --check budget.json
```

Note that while Benchmarks are run against Garmin's SDK, our checks gate against the absolute time, not relative.
