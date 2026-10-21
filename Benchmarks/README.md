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

Fixtures come from `Tests/PureFITTests/Fixtures` rather than being duplicated here; see the
[README there](../Tests/PureFITTests/Fixtures/README.md) for what each one is. CI gates on two of
them: `garmin-cycling-unprofiled-messages.fit` has no developer fields at all, so
`garmin-sdk-cycling-developer-fields.fit` is what actually exercises them.

## Memory

`--memory` adds two measurements per scenario, taken after the timings so they can't
slow them down:

- **Heap**: peak live heap bytes and allocation count during one run, after warmup, counted
  through libmalloc's `malloc_logger` hook on the measuring thread. This is deterministic:
  identical code gives the identical byte count on every run, on CI and a local Mac alike,
  so it's what CI gates on.
- **Footprint**: growth in the process's peak physical footprint (`phys_footprint`, what
  jetsam and Activity Monitor see). The peak is cumulative over a process's lifetime and
  can't be reset, so every sample runs the scenario once in a fresh child process and
  reports the peak minus the footprint just before it started. That makes it a cold
  number, including one-time setup; `--footprint-samples` (default 5) sets the sample
  count. Across six local runs PureFIT's varied by up to 6%; the sub-megabyte Garmin
  streaming figures vary more in relative terms.

```sh
swift run -c release PureFITBenchmark --memory --all
```

Local results on an M-series Mac. Heap is exact; footprint is the median of 5 processes.

| Fixture | Scenario | PureFIT heap | PureFIT allocations | Garmin heap | Garmin allocations |
| --- | --- | --- | --- | --- | --- |
| `garmin-cycling-unprofiled-messages.fit` (609 KB) | Parse | 25.4 MB | 710,546 | 22.8 MB | 1,323,029 |
| | Raw parse (no profile) | 3.4 MB | 23,414 | — | — |
| | Read developer fields | 25.4 MB | 710,532 | 24 KB | 1,043,549 |
| `garmin-sdk-cycling-developer-fields.fit` (63 KB) | Parse | 3.3 MB | 93,867 | 7.5 MB | 937,030 |
| | Raw parse (no profile) | 531 KB | 7,250 | — | — |
| | Read developer fields | 3.3 MB | 93,856 | 693 KB | 1,315,176 |
| `stryd-running-developer-fields.fit` (533 KB) | Parse | 15.8 MB | 477,677 | 86.9 MB | 31,977,800 |
| | Raw parse (no profile) | 1.8 MB | 15,079 | — | — |
| | Read developer fields | 15.8 MB | 477,667 | 18.6 MB | 40,652,923 |
| `workoutdoors-running-developer-fields.fit` (188 KB) | Parse | 6.8 MB | 205,477 | 26.4 MB | 6,637,116 |
| | Raw parse (no profile) | 790 KB | 8,606 | — | — |
| | Read developer fields | 6.8 MB | 205,467 | 4.2 MB | 8,949,787 |

Footprint tracks heap closely (PureFIT Parse: 27.3, 3.9, 16.8 and 7.6 MB respectively), so
the heap number is a fair stand-in for what a device actually pays.

What the numbers show:

- **PureFIT's peak scales with the file**, at roughly 30–55x its size, because the whole file
  is materialized before you can look at it. Every scenario built on `PureFITFile` peaks at
  the same place, during construction; what you do afterwards barely registers.
- **`RawFITFile` alone peaks at 3.5–8.5x the file size**, 11–16% of a full parse.
  Callers who only need raw records should stop there.
- **The Garmin SDK's cost depends on how you use it.** Collecting messages with
  `FITListener` materializes them too, at a comparable or higher peak and 2–67x the
  allocations. Streaming through a delegate and keeping nothing is nearly flat in memory,
  which PureFIT can't offer. The streaming figures above include Objective-C objects
  autoreleased during `decodeFile:`, which live until the caller's pool drains; draining a
  pool per message brings `stryd-running-developer-fields.fit` from 18.6 MB to 86 KB.

## Regression check

`budget.json` caps PureFIT's own median time and peak heap per scenario:

```sh
swift run -c release PureFITBenchmark --memory --check budget.json
```

Note that while Benchmarks are run against Garmin's SDK, our checks gate against absolute
numbers, not relative ones. Time budgets are coarse because CI timing is noisy; heap budgets
sit about 10% above the measured value because the heap count isn't noisy at all.
