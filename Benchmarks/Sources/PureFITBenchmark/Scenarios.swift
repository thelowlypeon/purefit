import Foundation
import PureFIT
import ObjcFIT
import SwiftFIT

/// One comparable unit of work, implemented against both libraries.
///
/// Every closure returns a count so the harness can confirm the two libraries
/// actually saw the same data — a benchmark where one side quietly does less
/// work isn't a benchmark.
struct Scenario {
    let name: String
    /// Set when the two libraries can't be compared apples-to-apples.
    let note: String?
    let pureFIT: (URL) throws -> Int
    /// `nil` for scenarios the Garmin SDK has no equivalent for.
    let garmin: ((URL) throws -> Int)?
}

/// Semicircles to degrees, the conversion any caller plotting a track has to do.
private let degreesPerSemicircle = 180.0 / 2147483648.0

private func pureFITRecordCount(_ file: PureFITFile) -> Int {
    file.messages.compactMap { $0 as? RecordMessage }.count
}

/// Decodes with a listener attached so the Garmin SDK materializes messages,
/// which is the work PureFIT does unconditionally.
private func garminDecode(_ url: URL) -> FITListener {
    let decoder = FITDecoder()
    let listener = FITListener()
    decoder.mesgDelegate = listener
    _ = decoder.decodeFile(url.path)
    return listener
}

/// Counts developer field values as messages stream past, without retaining them.
///
/// `FITListener` buckets only messages the profile knows about, so it can't answer
/// "every developer value in the file" — this can, and it's the streaming API's
/// natural idiom for the job.
private final class DeveloperFieldCounter: NSObject, FITMesgDelegate {
    var values = 0

    func onMesg(_ mesg: ObjcFIT.FITMessage) {
        for field in mesg.getDeveloperFields() {
            // Module-qualified: PureFIT has a FITDeveloperField of its own.
            guard let field = field as? ObjcFIT.FITDeveloperField else { continue }
            // Declared nonnull in the header but returns nil for an invalid raw value,
            // so bind through an optional rather than trusting the annotation.
            let value: NSNumber? = field.getValueFor(0)
            if value != nil { values += 1 }
        }
    }
}

let allScenarios: [Scenario] = [
    Scenario(
        name: "Parse",
        note: nil,
        pureFIT: { url in
            let raw = try RawFITFile(url: url, validationMethod: .skipCRCValidation)
            return pureFITRecordCount(try PureFITFile(rawFITFile: raw))
        },
        garmin: { url in
            garminDecode(url).messages.getRecordMesgs().count
        }
    ),

    Scenario(
        name: "Parse + validate CRC",
        note: "The Garmin SDK's `checkIntegrity:` is a separate pass over the file, so it reads the file twice.",
        pureFIT: { url in
            let raw = try RawFITFile(url: url, validationMethod: .requireValidCRC)
            return pureFITRecordCount(try PureFITFile(rawFITFile: raw))
        },
        garmin: { url in
            let decoder = FITDecoder()
            guard decoder.checkIntegrity(url.path) else {
                throw BenchmarkError.integrityCheckFailed(url.lastPathComponent)
            }
            return garminDecode(url).messages.getRecordMesgs().count
        }
    ),

    Scenario(
        name: "Parse + extract GPS",
        note: "Both convert semicircles to degrees. Counts are coordinate pairs.",
        pureFIT: { url in
            let raw = try RawFITFile(url: url, validationMethod: .skipCRCValidation)
            let file = try PureFITFile(rawFITFile: raw)
            var coordinates = [(Double, Double)]()
            for record in file.messages.compactMap({ $0 as? RecordMessage }) {
                guard let latitude = record.standardFieldValue(for: .latitude) as? AngleField.Value,
                      let longitude = record.standardFieldValue(for: .longitude) as? AngleField.Value
                else { continue }
                coordinates.append((
                    latitude.measurement.converted(to: .degrees).value,
                    longitude.measurement.converted(to: .degrees).value
                ))
            }
            return coordinates.count
        },
        garmin: { url in
            var coordinates = [(Double, Double)]()
            for record in garminDecode(url).messages.getRecordMesgs() {
                guard record.isPositionLatValid(), record.isPositionLongValid() else { continue }
                coordinates.append((
                    Double(record.getPositionLat()) * degreesPerSemicircle,
                    Double(record.getPositionLong()) * degreesPerSemicircle
                ))
            }
            return coordinates.count
        }
    ),

    Scenario(
        name: "Parse from Data",
        note: "PureFIT only: the Garmin SDK decodes from a file path, so it can't parse an in-memory buffer.",
        pureFIT: { url in
            let data = try Data(contentsOf: url)
            let raw = try RawFITFile(data: data, validationMethod: .skipCRCValidation)
            return pureFITRecordCount(try PureFITFile(rawFITFile: raw))
        },
        garmin: nil
    ),

    Scenario(
        name: "Read developer fields",
        note: "Counts are developer field values read. Garmin counts them streaming, without retaining messages, so it does strictly less work here than PureFIT — which has to materialize the file before it can walk it.",
        pureFIT: { url in
            let raw = try RawFITFile(url: url, validationMethod: .skipCRCValidation)
            let file = try PureFITFile(rawFITFile: raw)
            let definitions = file.developerFields
            var values = 0
            for message in file.messages {
                for (number, rawValues) in message.fields {
                    guard case .developer = number,
                          let definition = definitions[number],
                          definition.parse(values: rawValues) != nil
                    else { continue }
                    values += 1
                }
            }
            return values
        },
        garmin: { url in
            let decoder = FITDecoder()
            let counter = DeveloperFieldCounter()
            decoder.mesgDelegate = counter
            _ = decoder.decodeFile(url.path)
            return counter.values
        }
    ),

    Scenario(
        name: "Count messages by type",
        note: "PureFIT only: the Garmin listener buckets known messages by type during decode and drops the rest, so there's nothing equivalent to time. Counts are distinct message types found.",
        pureFIT: { url in
            let raw = try RawFITFile(url: url, validationMethod: .skipCRCValidation)
            let file = try PureFITFile(rawFITFile: raw)
            var counts = [FITGlobalMessageNumber: Int]()
            for message in file.messages {
                counts[message.globalMessageNumber, default: 0] += 1
            }
            return counts.count
        },
        garmin: nil
    ),

    Scenario(
        name: "Raw parse (no profile)",
        note: "PureFIT only: decodes records without interpreting them against the FIT profile. Counts are raw records.",
        pureFIT: { url in
            try RawFITFile(url: url, validationMethod: .skipCRCValidation).records.count
        },
        garmin: nil
    ),
]

enum BenchmarkError: Error, CustomStringConvertible {
    case integrityCheckFailed(String)
    case noFixtures(String)

    var description: String {
        switch self {
        case .integrityCheckFailed(let name):
            return "Garmin checkIntegrity failed for \(name)"
        case .noFixtures(let path):
            return "No .fit fixtures found in \(path)"
        }
    }
}
