# AGENTS.md

- `main` is protected: changes must be made through a pull request, not pushed directly.
- Run tests locally (`swift test`) before pushing.
- Tests use Swift Testing (`import Testing`, `@Test`, `#expect`), not XCTest. `swift-tools-version` is 6.0.
- If `swift test` fails with `error: no such module 'Testing'`, the active toolchain is Command Line Tools only. Run `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test` instead.
