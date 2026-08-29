# AGENTS.md

- `main` is protected: changes must be made through a pull request, not pushed directly.
- Run tests locally (`swift test`) before pushing.
- Tests use Swift Testing (`import Testing`, `@Test`, `#expect`), not XCTest. `swift-tools-version` is 6.0.
- If `swift test` fails with `error: no such module 'Testing'`, the active toolchain is Command Line Tools only. Run `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test` instead.
- `Benchmarks/` is a separate SwiftPM package (so the library takes no dependency on the Garmin SDK). Run it from that directory, always `-c release`. Its first build compiles Garmin's C++/ObjC SDK and takes a few minutes.
- Benchmark CI gates on PureFIT's own absolute times in `Benchmarks/budget.json` — deliberately not measured against the Garmin SDK, so their releases can't move our pass mark. Only raise a budget for a deliberate trade-off, and say so in the PR.
