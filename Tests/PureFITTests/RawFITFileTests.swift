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
        let url = Bundle.module.url(forResource: "fitfile1", withExtension: "fit", subdirectory: "Fixtures")!
        let fit = try RawFITFile(url: url)
        let crcSize = fit.header.crc == nil ? 0 : 2
        #expect(Int(fit.header.dataSize) + Int(fit.header.headerSize) + crcSize == 193162)
        #expect(fit.records.count == 4301)
    }

    @Test func parseInvalidFile() async throws {
        let url = Bundle.module.url(forResource: "not-a-fit-file", withExtension: "fit", subdirectory: "Fixtures")!
        #expect(throws: FITHeader.DecodeError.invalidLength) {
            let _ = try RawFITFile(url: url)
        }
    }
}
