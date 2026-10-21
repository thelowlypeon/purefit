import Darwin
import Foundation

/// Heap activity on the measuring thread during one run of a scenario.
struct HeapUsage: Codable, Equatable {
    let allocations: Int
    let bytesAllocated: Int
    /// High-water mark of live heap bytes above what was live when the run started.
    let peakBytes: Int
}

struct MemoryResult: Codable {
    let heap: HeapUsage
    /// Peak physical footprint growth, one entry per fresh process.
    let footprintSamples: [Int]

    var footprintMedian: Int {
        let sorted = footprintSamples.sorted()
        return sorted.isEmpty ? 0 : sorted[sorted.count / 2]
    }
}

// MARK: - Heap, via malloc_logger

private typealias MallocLogger = @convention(c) (UInt32, UInt, UInt, UInt, UInt, UInt32) -> Void

private struct HeapCounters {
    var thread: pthread_t?
    var allocations = 0
    var bytesAllocated = 0
    var liveBytes = 0
    var peakBytes = 0
}

// The logger runs inside malloc, so it must not allocate. Swift's exclusivity checks on a
// global `var` do (thread-local storage on first use), which recurses until the stack
// overflows; mutating through a raw pointer isn't checked.
private let counters: UnsafeMutablePointer<HeapCounters> = {
    let pointer = UnsafeMutablePointer<HeapCounters>.allocate(capacity: 1)
    pointer.initialize(to: HeapCounters())
    return pointer
}()

/// libmalloc's hook for MallocStackLogging, called on every allocation and free in every zone.
private let mallocLogger: UnsafeMutablePointer<MallocLogger?> = {
    // RTLD_DEFAULT is a macro Swift can't import.
    guard let symbol = dlsym(UnsafeMutableRawPointer(bitPattern: -2), "malloc_logger") else {
        fail("malloc_logger not found; can't count allocations")
    }
    return symbol.assumingMemoryBound(to: MallocLogger?.self)
}()

private let logAllocation: MallocLogger = { type, _, pointerOrSize, _, result, _ in
    guard pthread_equal(pthread_self(), counters.pointee.thread) != 0 else { return }
    let allocate: UInt32 = 2
    let deallocate: UInt32 = 4

    // realloc reports both flags, with the old pointer in the second argument.
    if type & deallocate != 0, pointerOrSize != 0 {
        counters.pointee.liveBytes -= malloc_size(UnsafeRawPointer(bitPattern: pointerOrSize))
    }
    if type & allocate != 0, result != 0 {
        let size = malloc_size(UnsafeRawPointer(bitPattern: result))
        counters.pointee.allocations += 1
        counters.pointee.bytesAllocated += size
        counters.pointee.liveBytes += size
        counters.pointee.peakBytes = max(counters.pointee.peakBytes, counters.pointee.liveBytes)
    }
}

/// Counts heap allocations made on this thread while `body` runs once, after `warmup`
/// uninstrumented runs so one-time setup (lazy globals, caches) isn't charged to it.
///
/// Only the calling thread is counted, which keeps the numbers deterministic and is all
/// either library uses. Sizes are `malloc_size`, so include the allocator's rounding.
func measureHeap(warmup: Int, _ body: () throws -> Int) rethrows -> HeapUsage {
    for _ in 0..<max(warmup, 1) {
        _ = try autoreleasepool { try body() }
    }

    counters.pointee = HeapCounters(thread: pthread_self())
    mallocLogger.pointee = logAllocation
    defer { mallocLogger.pointee = nil }
    // The pool is inside the measured region so autoreleased Objective-C objects count.
    _ = try autoreleasepool { try body() }

    return HeapUsage(
        allocations: counters.pointee.allocations,
        bytesAllocated: counters.pointee.bytesAllocated,
        peakBytes: counters.pointee.peakBytes
    )
}

// MARK: - Physical footprint, in a fresh process

/// The process's physical footprint (what Activity Monitor and jetsam see) and its lifetime peak.
func physicalFootprint() -> (current: Int, peak: Int) {
    var info = task_vm_info_data_t()
    var count = mach_msg_type_number_t(
        MemoryLayout<task_vm_info_data_t>.size / MemoryLayout<integer_t>.size
    )
    let result = withUnsafeMutablePointer(to: &info) { pointer in
        pointer.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
            task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), $0, &count)
        }
    }
    guard result == KERN_SUCCESS else { fail("task_info failed: \(result)") }
    return (Int(info.phys_footprint), Int(info.ledger_phys_footprint_peak))
}

/// The lifetime peak can't be reset, so each sample runs the scenario once in its own process
/// and reports how far the peak rose above the footprint just before it started.
func measureFootprint(scenario: String, implementation: String, fixture: URL, samples: Int) -> [Int] {
    guard let executable = Bundle.main.executableURL else { fail("Can't locate own executable") }
    return (0..<samples).map { _ in
        let process = Process()
        process.executableURL = executable
        process.arguments = [footprintChildFlag, scenario, implementation, fixture.path]
        let output = Pipe()
        process.standardOutput = output
        do {
            try process.run()
        } catch {
            fail("Couldn't launch footprint process: \(error)")
        }
        let data = output.fileHandleForReading.readDataToEndOfFile()
        process.waitUntilExit()
        guard process.terminationStatus == 0,
              let text = String(data: data, encoding: .utf8),
              let bytes = Int(text.trimmingCharacters(in: .whitespacesAndNewlines))
        else {
            fail("Footprint process failed for \(implementation) / \(scenario)")
        }
        return bytes
    }
}

let footprintChildFlag = "--footprint-child"

/// Entry point for the process `measureFootprint` launches. Prints the footprint growth in bytes.
func runFootprintChild(_ arguments: [String]) -> Never {
    guard arguments.count == 3,
          let scenario = allScenarios.first(where: { $0.name == arguments[0] })
    else { fail("Usage: \(footprintChildFlag) SCENARIO purefit|garmin FIXTURE") }
    let fixture = URL(fileURLWithPath: arguments[2])

    let body: (URL) throws -> Int
    switch arguments[1] {
    case "purefit": body = scenario.pureFIT
    case "garmin":
        guard let garmin = scenario.garmin else { fail("\(scenario.name) has no Garmin implementation") }
        body = garmin
    default: fail("Unknown implementation \(arguments[1])")
    }

    let before = physicalFootprint().current
    do {
        _ = try autoreleasepool { try body(fixture) }
    } catch {
        fail("\(scenario.name) threw: \(error)")
    }
    print(physicalFootprint().peak - before)
    exit(0)
}

func formatBytes(_ bytes: Int) -> String {
    let megabytes = Double(bytes) / 1_048_576
    return megabytes >= 1
        ? String(format: "%.1f MB", megabytes)
        : String(format: "%.0f KB", Double(bytes) / 1024)
}
