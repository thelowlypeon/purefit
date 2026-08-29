//
//  Fixture.swift
//  PureFIT
//

import Foundation
@testable import PureFIT

/// The FIT files in `Fixtures/`. See the README there for what each one contains.
enum Fixture: String {
    /// Garmin Edge 530 road ride. Broad profile coverage, plus message types and fields the
    /// profile doesn't recognize. No developer fields.
    case garminCycling = "garmin-cycling-unprofiled-messages"

    /// Garmin's SDK sample: two developer fields and little else.
    case garminSDKCycling = "garmin-sdk-cycling-developer-fields"

    /// A WorkOutDoors run carrying Stryd's developer fields.
    case workoutdoorsRunning = "workoutdoors-running-developer-fields"

    /// A Stryd run. The developer-field extreme.
    case strydRunning = "stryd-running-developer-fields"

    /// 14 bytes of junk, for the error path.
    case notAFITFile = "not-a-fit-file"

    var url: URL {
        Bundle.module.url(forResource: rawValue, withExtension: "fit", subdirectory: "Fixtures")!
    }

    var data: Data {
        get throws { try Data(contentsOf: url) }
    }

    func rawFITFile() throws -> RawFITFile {
        try RawFITFile(url: url)
    }

    func pureFITFile() throws -> PureFITFile {
        try PureFITFile(url: url)
    }
}
