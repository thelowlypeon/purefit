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
        let url = Bundle.module.url(forResource: "fitfile1", withExtension: "fit", subdirectory: "Fixtures")!
        let data = try Data(contentsOf: url)
        var offset = 0
        let header = try #require(FITHeader(data: data, offset: &offset))
        #expect(header.dataSize == 193146)
        #expect(header.dataType == ".FIT")
        #expect(header.headerSize == 14)
        #expect(header.crc?.checksum == 49693)
        #expect(offset == 14)
    }
}
