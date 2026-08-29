//
//  FITHeaderParsingTests.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/11/25.
//

import Testing
import Foundation
@testable import PureFIT

struct FITHeaderParsingTests {
    @Test func parseHeaderTest() async throws {
        let data = try Fixture.workoutdoorsRunning.data
        var offset = 0
        let header = try #require(FITHeader(data: data, offset: &offset))
        #expect(header.dataSize == 193146)
        #expect(header.dataType == ".FIT")
        #expect(header.headerSize == 14)
        #expect(header.crc?.checksum == 49693)
        #expect(offset == 14)
    }
}
