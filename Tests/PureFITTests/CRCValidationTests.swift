//
//  CRCValidationTests.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/11/25.
//

import Testing
import Foundation
@testable import PureFIT

struct CRCValidationTests {
    @Test func validateHeaderCRCTest() async throws {
        let url = Bundle.module.url(forResource: "fitfile1", withExtension: "fit", subdirectory: "Fixtures")!
        let data = try Data(contentsOf: url)
        var offset = 0
        let header = try #require(FITHeader(data: data, offset: &offset))
        #expect(header.isCRCValid(headerData: data.subdata(in: 0..<Int(header.headerSize - 2))) == true)
    }

    @Test func validateHeaderCRCFromFITFileTest() async throws {
        let url = Bundle.module.url(forResource: "fitfile1", withExtension: "fit", subdirectory: "Fixtures")!
        let data = try Data(contentsOf: url)
        let fit = try FITFile(data: data)
        #expect(fit.isHeaderCRCValid(fileData: data) == true)
    }

    @Test func validateCRCTests() async throws {
        let url = Bundle.module.url(forResource: "fitfile1", withExtension: "fit", subdirectory: "Fixtures")!
        let data = try Data(contentsOf: url)
        let fit = try FITFile(data: data)
        #expect(fit.isCRCValid(fileData: data) == true)
    }
}
