# PureFIT Benchmarks

A standalone SwiftPM package that compares PureFIT against Garmin's
[fit-objective-c-sdk](https://github.com/garmin/fit-objective-c-sdk). It's kept out of the root
package so the library itself picks up no dependency on the Garmin SDK.

```sh
cd Benchmarks
swift run -c release PureFITBenchmark            # primary fixture
swift run -c release PureFITBenchmark --all      # every fixture
swift run -c release PureFITBenchmark --help
```

Always build `-c release`. Debug builds measure the optimizer's absence, not the parsers.

## What it measures

| Scenario | PureFIT | Garmin SDK |
| --- | --- | --- |
| Parse | `RawFITFile` + `PureFITFile`, CRC skipped | `decodeFile:` |
| Parse + validate CRC | `validationMethod: .requireValidCRC` | `checkIntegrity:` then `decodeFile:` |
| Parse + extract GPS | lat/long off every `RecordMessage`, converted to degrees | `getPositionLat/Long` off every record, converted to degrees |
| Parse from Data | `RawFITFile(data:)` | — (decodes from a file path only) |
| Raw parse (no profile) | `RawFITFile` alone | — (no equivalent layer) |

Fixtures are shared with the test target (`Tests/PureFITTests/Fixtures`) rather than duplicated.

## Keeping it honest

Two things make the comparison meaningful rather than decorative:

- **Both sides materialize messages.** The Garmin decoder runs with a `FITListener` attached, so it
  builds message objects like PureFIT does. Decoding without a delegate would let it skip that work
  and look artificially fast.
- **Counts are asserted to match.** Every scenario returns a count — records parsed, coordinates
  found — and the harness fails if the two libraries disagree, or if a library isn't stable across
  iterations. A benchmark where one side quietly parses less isn't measuring anything.

Timing is the median of N runs after warmup, which discards first-run page-fault and cache noise.

## Regression gate

`ratio-budget.json` caps how slow PureFIT may be *relative to the Garmin SDK*, per scenario:

```sh
swift run -c release PureFITBenchmark --check ratio-budget.json
```

Ratios rather than absolute milliseconds, because shared CI runners vary far too much for a wall
clock threshold to mean anything. Both libraries run back to back on the same machine and absorb the
same noise, so the ratio between them stays stable even when the absolute numbers wander.

Raise a budget when a change is a deliberate trade (correctness or features bought with time), and
say so in the PR. Don't raise one to make a red build go green.
