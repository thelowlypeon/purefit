//
//  ParseFITFileTests.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/11/25.
//

import Testing
import Foundation
@testable import PureFIT

struct RawFITFileTests {
    @Test func parseFITFileTest() async throws {
        let fit = try Fixture.workoutdoorsRunning.rawFITFile()
        let crcSize = fit.header.crc == nil ? 0 : 2
        #expect(Int(fit.header.dataSize) + Int(fit.header.headerSize) + crcSize == 193162)
        #expect(fit.records.count == 4301)
    }

    @Test func parseGarminFITFileTest() async throws {
        let fit = try Fixture.garminCycling.rawFITFile()
        let crcSize = fit.header.crc == nil ? 0 : 2
        #expect(Int(fit.header.dataSize) + Int(fit.header.headerSize) + crcSize == 624016)
        #expect(fit.records.count == 23324)
    }

    @Test func parseInvalidFile() async throws {
        #expect(throws: FITHeader.DecodeError.invalidLength) {
            let _ = try Fixture.notAFITFile.rawFITFile()
        }
    }
}
