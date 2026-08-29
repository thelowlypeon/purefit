import Foundation

// MARK: - Arguments

var iterations = 10
var warmup = 3
var format = "table"
var fixtureNames: [String]? = ["cyclingActivityFromGarmin.fit"]
var budgetPath: String?

var arguments = Array(CommandLine.arguments.dropFirst())
while let argument = arguments.first {
    arguments.removeFirst()
    func value() -> String {
        guard let next = arguments.first else {
            fail("Missing value for \(argument)")
        }
        arguments.removeFirst()
        return next
    }

    switch argument {
    case "--iterations": iterations = Int(value()) ?? iterations
    case "--warmup": warmup = Int(value()) ?? warmup
    case "--format": format = value()
    case "--fixture": fixtureNames = value().split(separator: ",").map(String.init)
    case "--all": fixtureNames = nil
    case "--check": budgetPath = value()
    case "--help", "-h":
        print("""
        purefit-benchmark [options]

          --iterations N   timed runs per scenario (default 10)
          --warmup N       untimed runs before timing (default 3)
          --fixture NAMES  comma-separated fixtures (default cyclingActivityFromGarmin.fit)
          --all            benchmark every fixture
          --format FORMAT  table (default), markdown, or json
          --check FILE     compare against a ratio budget and exit non-zero if exceeded
        """)
        exit(0)
    default:
        fail("Unknown argument: \(argument)")
    }
}

// MARK: - Fixtures

// Fixtures are shared with the test target rather than duplicated here.
let repositoryRoot = URL(fileURLWithPath: #filePath)
    .deletingLastPathComponent()  // PureFITBenchmark
    .deletingLastPathComponent()  // Sources
    .deletingLastPathComponent()  // Benchmarks
    .deletingLastPathComponent()  // <repo>
let fixturesDirectory = repositoryRoot
    .appendingPathComponent("Tests/PureFITTests/Fixtures")

let allFixtures = ((try? FileManager.default.contentsOfDirectory(
    at: fixturesDirectory,
    includingPropertiesForKeys: nil
)) ?? [])
    .filter { $0.pathExtension == "fit" && $0.lastPathComponent != "not-a-fit-file.fit" }
    .sorted { $0.lastPathComponent < $1.lastPathComponent }

let fixtures: [URL]
if let fixtureNames {
    fixtures = try fixtureNames.map { name in
        guard let match = allFixtures.first(where: { $0.lastPathComponent == name }) else {
            fail("No fixture named \(name) in \(fixturesDirectory.path)")
        }
        return match
    }
} else {
    fixtures = allFixtures
}
guard !fixtures.isEmpty else { fail("\(BenchmarkError.noFixtures(fixturesDirectory.path))") }

// MARK: - Run

struct Row: Codable {
    let fixture: String
    let fixtureBytes: Int
    let scenario: String
    let note: String?
    let pureFITMedian: Double
    let pureFITBest: Double
    let pureFITCount: Int
    let garminMedian: Double?
    let garminBest: Double?
    let garminCount: Int?

    /// How many times slower PureFIT is than the Garmin SDK. Below 1.0 means faster.
    var ratio: Double? {
        guard let garminMedian, garminMedian > 0 else { return nil }
        return pureFITMedian / garminMedian
    }
}

var rows = [Row]()
for fixture in fixtures {
    let size = (try? Data(contentsOf: fixture).count) ?? 0
    for scenario in allScenarios {
        let pure = try measure(
            scenario: scenario.name,
            implementation: "PureFIT",
            iterations: iterations,
            warmup: warmup,
            { try scenario.pureFIT(fixture) }
        )
        let garmin = try scenario.garmin.map { garminBody in
            try measure(
                scenario: scenario.name,
                implementation: "Garmin",
                iterations: iterations,
                warmup: warmup,
                { try garminBody(fixture) }
            )
        }
        rows.append(Row(
            fixture: fixture.lastPathComponent,
            fixtureBytes: size,
            scenario: scenario.name,
            note: scenario.note,
            pureFITMedian: pure.median,
            pureFITBest: pure.best,
            pureFITCount: pure.checksum,
            garminMedian: garmin?.median,
            garminBest: garmin?.best,
            garminCount: garmin?.checksum
        ))
    }
}

// MARK: - Output

func ratioDescription(_ row: Row) -> String {
    guard let ratio = row.ratio else { return "—" }
    return ratio < 1
        ? String(format: "%.2fx faster", 1 / ratio)
        : String(format: "%.2fx slower", ratio)
}

switch format {
case "json":
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    print(String(data: try encoder.encode(rows), encoding: .utf8)!)

case "markdown":
    for fixture in Set(rows.map(\.fixture)).sorted() {
        let fixtureRows = rows.filter { $0.fixture == fixture }
        let bytes = fixtureRows[0].fixtureBytes
        print("\n**`\(fixture)`** (\(bytes / 1024) KB), median of \(iterations) runs:\n")
        print("| Scenario | PureFIT | Garmin SDK | Relative |")
        print("| --- | --- | --- | --- |")
        for row in fixtureRows {
            let garmin = row.garminMedian.map(formatMilliseconds) ?? "—"
            print("| \(row.scenario) | \(formatMilliseconds(row.pureFITMedian)) | \(garmin) | \(ratioDescription(row)) |")
        }
    }

default:
    for fixture in Set(rows.map(\.fixture)).sorted() {
        let fixtureRows = rows.filter { $0.fixture == fixture }
        print("\n\(fixture) (\(fixtureRows[0].fixtureBytes / 1024) KB) — median of \(iterations) runs, \(warmup) warmup")
        for row in fixtureRows {
            let garmin = row.garminMedian.map(formatMilliseconds) ?? "—"
            print("  \(padded(row.scenario, 24))"
                + "PureFIT \(padded(formatMilliseconds(row.pureFITMedian), 10))"
                + "Garmin \(padded(garmin, 10))"
                + ratioDescription(row))
            if let garminCount = row.garminCount, garminCount != row.pureFITCount {
                print("    note: PureFIT counted \(row.pureFITCount), Garmin counted \(garminCount)")
            }
        }
    }
}

// MARK: - Regression gate

// Budgets are absolute PureFIT timings, per fixture and scenario. Deliberately not measured
// against the Garmin SDK: a release of theirs shouldn't be able to move our pass mark.
if let budgetPath {
    struct Budget: Codable {
        let maxMedianMilliseconds: [String: [String: Double]]
    }
    let budget = try JSONDecoder().decode(
        Budget.self,
        from: try Data(contentsOf: URL(fileURLWithPath: budgetPath))
    )

    var failures = [String]()
    var checked = 0
    for row in rows {
        guard let limit = budget.maxMedianMilliseconds[row.fixture]?[row.scenario] else { continue }
        checked += 1
        let median = row.pureFITMedian * 1000
        let status = median <= limit ? "ok" : "OVER"
        print(String(format: "check %@ %@: %.1f ms (limit %.0f ms) %@",
                     row.fixture, row.scenario, median, limit, status))
        if median > limit {
            failures.append(String(format: "%@ / %@: %.1f ms exceeds %.0f ms",
                                   row.fixture, row.scenario, median, limit))
        }
    }

    if checked == 0 {
        fail("Budget file matched no scenario that was run")
    }

    if !failures.isEmpty {
        print("\nPerformance regression:")
        failures.forEach { print("  \($0)") }
        exit(1)
    }
    print("\nAll \(checked) scenarios within budget.")
}
