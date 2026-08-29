# Fixtures

Real FIT files used by the tests and the benchmarks. Named `<writer>-<sport>-<what it covers>.fit`.

| File | Size | Written by | Why it's here |
| --- | --- | --- | --- |
| `garmin-cycling-unprofiled-messages.fit` | 609 KB | Garmin Edge 530 | A real device file with broad coverage: 23,291 messages across 14 profiled types, plus 11 message types and 24,675 field values the profile doesn't recognize. No developer fields. Most profile tests use this. |
| `garmin-sdk-cycling-developer-fields.fit` | 63 KB | Garmin's SDK sample ("FIT Cookbook") | Developer fields and little else — 2 definitions (Doughnuts Earned, Heart Rate) over 3,602 values. Small enough to reason about by hand. |
| `workoutdoors-running-developer-fields.fit` | 188 KB | WorkOutDoors, a third-party iOS app | A non-Garmin writer emitting Stryd's developer fields: 5 definitions, 21,355 values. |
| `stryd-running-developer-fields.fit` | 533 KB | Stryd | The developer-field extreme: 12 definitions, 81,940 values, and 14,901 more with no definition at all. |
| `not-a-fit-file.fit` | 14 B | — | 14 bytes of junk. Covers the error path. |

Tests load these through the `Fixture` enum in `../Fixture.swift` — `try Fixture.strydRunning.pureFITFile()`, or `.rawFITFile()`, `.data`, `.url`.

The benchmarks read from this directory rather than keeping copies, and skip `not-a-fit-file.fit`.
