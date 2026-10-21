import Foundation

if CommandLine.arguments.dropFirst().first == footprintChildFlag {
    runFootprintChild(Array(CommandLine.arguments.dropFirst(2)))
}

// MARK: - Arguments

var iterations = 10
var warmup = 3
var format = "table"
var fixtureNames: [String]? = ["garmin-cycling-unprofiled-messages.fit"]
var budgetPath: String?
var measureMemory = false
var footprintSamples = 5

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
    case "--memory": measureMemory = true
    case "--footprint-samples": footprintSamples = max(Int(value()) ?? footprintSamples, 1)
    case "--help", "-h":
        print("""
        purefit-benchmark [options]

          --iterations N   timed runs per scenario (default 10)
          --warmup N       untimed runs before timing (default 3)
          --fixture NAMES  comma-separated fixtures (default garmin-cycling-unprofiled-messages.fit)
          --all            benchmark every fixture
          --format FORMAT  table (default), markdown, or json
          --memory         also measure heap allocations and peak physical footprint
          --footprint-samples N
                           fresh processes per footprint measurement (default 5)
          --check FILE     compare against a budget and exit non-zero if exceeded
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
    fixtures = fixtureNames.map { name in
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
    let pureFITMemory: MemoryResult?
    let garminMemory: MemoryResult?

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
        let pureMemory = measureMemory ? MemoryResult(
            heap: try measureHeap(warmup: warmup) { try scenario.pureFIT(fixture) },
            footprintSamples: measureFootprint(
                scenario: scenario.name, implementation: "purefit", fixture: fixture, samples: footprintSamples
            )
        ) : nil
        let garminMemory = try scenario.garmin.flatMap { garminBody in
            measureMemory ? MemoryResult(
                heap: try measureHeap(warmup: warmup) { try garminBody(fixture) },
                footprintSamples: measureFootprint(
                    scenario: scenario.name, implementation: "garmin", fixture: fixture, samples: footprintSamples
                )
            ) : nil
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
            garminCount: garmin?.checksum,
            pureFITMemory: pureMemory,
            garminMemory: garminMemory
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

func memoryColumns(_ memory: MemoryResult?) -> [String] {
    guard let memory else { return ["—", "—", "—"] }
    return [
        formatBytes(memory.heap.peakBytes),
        memory.heap.allocations.formatted(),
        formatBytes(memory.footprintMedian),
    ]
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
        guard measureMemory else { continue }
        print("\nMemory: peak live heap and allocations in one warm run; peak footprint growth, median of \(footprintSamples) fresh processes.\n")
        print("| Scenario | PureFIT heap | PureFIT allocations | PureFIT footprint | Garmin heap | Garmin allocations | Garmin footprint |")
        print("| --- | --- | --- | --- | --- | --- | --- |")
        for row in fixtureRows {
            let columns = [row.scenario] + memoryColumns(row.pureFITMemory) + memoryColumns(row.garminMemory)
            print("| " + columns.joined(separator: " | ") + " |")
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
        guard measureMemory else { continue }
        print("  memory: peak heap, allocations, peak footprint (median of \(footprintSamples) processes)")
        for row in fixtureRows {
            let pure = memoryColumns(row.pureFITMemory)
            let garmin = memoryColumns(row.garminMemory)
            print("  \(padded(row.scenario, 24))"
                + "PureFIT \(padded(pure[0], 9))\(padded(pure[1], 12))\(padded(pure[2], 10))"
                + "Garmin \(padded(garmin[0], 9))\(padded(garmin[1], 12))\(garmin[2])")
        }
    }
}

// MARK: - Regression gate

// Budgets are absolute PureFIT numbers, per fixture and scenario. Deliberately not measured
// against the Garmin SDK: a release of theirs shouldn't be able to move our pass mark.
if let budgetPath {
    struct Budget: Codable {
        let maxMedianMilliseconds: [String: [String: Double]]
        let maxPeakHeapKilobytes: [String: [String: Double]]?
    }
    let budget = try JSONDecoder().decode(
        Budget.self,
        from: try Data(contentsOf: URL(fileURLWithPath: budgetPath))
    )
    if budget.maxPeakHeapKilobytes != nil && !measureMemory {
        fail("\(budgetPath) has memory budgets; run with --memory to check them")
    }

    var failures = [String]()
    var checked = 0
    func check(_ row: Row, _ limits: [String: [String: Double]]?, _ value: Double?, unit: String) {
        guard let limit = limits?[row.fixture]?[row.scenario], let value else { return }
        checked += 1
        let status = value <= limit ? "ok" : "OVER"
        print(String(format: "check %@ %@: %.1f %@ (limit %.0f %@) %@",
                     row.fixture, row.scenario, value, unit, limit, unit, status))
        if value > limit {
            failures.append(String(format: "%@ / %@: %.1f %@ exceeds %.0f %@",
                                   row.fixture, row.scenario, value, unit, limit, unit))
        }
    }
    for row in rows {
        check(row, budget.maxMedianMilliseconds, row.pureFITMedian * 1000, unit: "ms")
    }
    for row in rows {
        let heapKilobytes = row.pureFITMemory.map { Double($0.heap.peakBytes) / 1024 }
        check(row, budget.maxPeakHeapKilobytes, heapKilobytes, unit: "KB heap")
    }

    if checked == 0 {
        fail("Budget file matched no scenario that was run")
    }

    if !failures.isEmpty {
        print("\nPerformance regression:")
        failures.forEach { print("  \($0)") }
        exit(1)
    }
    print("\nAll \(checked) checks within budget.")
}
