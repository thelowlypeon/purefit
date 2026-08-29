import Foundation

/// A single timed scenario for one implementation.
struct Result {
    let scenario: String
    let implementation: String
    /// Wall-clock seconds, one entry per iteration.
    let samples: [Double]
    /// Something the scenario counted (records parsed, coordinates found), used to
    /// show both implementations saw the same data.
    let checksum: Int

    var best: Double { samples.min() ?? 0 }

    var median: Double {
        guard !samples.isEmpty else { return 0 }
        let sorted = samples.sorted()
        return sorted[sorted.count / 2]
    }
}

/// Runs `body` `warmup + iterations` times, timing only the last `iterations` runs.
///
/// The body returns a count that is checked for consistency across runs: if parsing
/// is nondeterministic something is wrong with the benchmark, not the parser.
func measure(
    scenario: String,
    implementation: String,
    iterations: Int,
    warmup: Int,
    _ body: () throws -> Int
) rethrows -> Result {
    for _ in 0..<warmup {
        _ = try body()
    }

    var samples = [Double]()
    var checksum = 0
    for i in 0..<iterations {
        let start = ContinuousClock.now
        let count = try body()
        let elapsed = ContinuousClock.now - start

        samples.append(elapsed.seconds)
        if i == 0 {
            checksum = count
        } else if count != checksum {
            fatalError("\(implementation) produced \(count) on iteration \(i), expected \(checksum)")
        }
    }

    return Result(
        scenario: scenario,
        implementation: implementation,
        samples: samples,
        checksum: checksum
    )
}

extension Duration {
    var seconds: Double {
        let (secs, attos) = components
        return Double(secs) + Double(attos) * 1e-18
    }
}

func formatMilliseconds(_ seconds: Double) -> String {
    String(format: "%.1f ms", seconds * 1000)
}

func padded(_ string: String, _ width: Int) -> String {
    string.count >= width ? string : string + String(repeating: " ", count: width - string.count)
}

func fail(_ message: String) -> Never {
    FileHandle.standardError.write(Data("error: \(message)\n".utf8))
    exit(2)
}
