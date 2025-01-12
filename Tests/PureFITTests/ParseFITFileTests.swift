//
//  ParseFITFileTests.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/11/25.
//

import Testing
import Foundation
@testable import PureFIT

struct ParseFITFileTests {
    @Test func parseFITFileTest() async throws {
        let url = Bundle.module.url(forResource: "fitfile1", withExtension: "fit", subdirectory: "Fixtures")!
        let fit = try FITFile(url: url)
        let crcSize = fit.header.crc == nil ? 0 : 2
        #expect(Int(fit.header.dataSize) + Int(fit.header.headerSize) + crcSize == 193162)
        #expect(fit.records.count == 4301)
    }

    @Test func parseInvalidFile() async throws {
        let url = Bundle.module.url(forResource: "not-a-fit-file", withExtension: "fit", subdirectory: "Fixtures")!
        #expect(throws: FITHeader.DecodeError.invalidLength) {
            let _ = try FITFile(url: url)
        }
    }

    @Test func parsingFITFile() async throws {
        let url = Bundle.module.url(forResource: "fitfile1", withExtension: "fit", subdirectory: "Fixtures")!
        let fit = try FITFile(url: url)
        let parsed = FITParsedFile(fitFile: fit)

        // fileId message
        #expect(parsed.messages[0]?.count == 1)
        let fileIdMessage = try #require(parsed.messages[0]?.first)
        #expect(fileIdMessage.fields.keys.sorted() == [0,1,3,4])
        #expect(fileIdMessage.fields[0] == .enum(4)) // file type
        #expect(fileIdMessage.fields[1] == .uint16(255)) // manufacturer
        #expect(fileIdMessage.fields[3] == .uint32z(282475249)) // serial
        #expect(fileIdMessage.fields[4] == .uint32(1100201060)) // time created

        // record messages
        #expect(parsed.messages[20]?.count == 4257)
        let secondRecordMessage = try #require(parsed.messages[20]?[1])
        #expect(secondRecordMessage.fields.keys.sorted() == [0,1,2,3,4,5,6,7,39,41,253])
        #expect(secondRecordMessage.fields[253] == .uint32(1096542999))
        #expect(secondRecordMessage.fields[0] == .sint32(500395805))
        #expect(secondRecordMessage.fields[1] == .sint32(-1045723574))
        #expect(secondRecordMessage.fields[2] == .uint16(3415))
        #expect(secondRecordMessage.fields[5] == .uint32(1400))
        #expect(secondRecordMessage.fields[6] == .uint16(2434))
        #expect(secondRecordMessage.fields[3] == .uint8(118))
        #expect(secondRecordMessage.fields[4] == .uint8(86))
        #expect(secondRecordMessage.fields[39] == .uint16(540))
        #expect(secondRecordMessage.fields[41] == .uint16(2520))
        #expect(secondRecordMessage.fields[7] == .uint16(190))

        // developer fields
        #expect(secondRecordMessage.developerFields.keys.sorted() == [5,6,8,9,11])
        #expect(secondRecordMessage.developerFields[5] == .float32(2.43359375))
        #expect(secondRecordMessage.developerFields[6] == .uint32(14))
        #expect(secondRecordMessage.developerFields[8] == .uint16(61))
        #expect(secondRecordMessage.developerFields[9] == .float32(11.25))
        #expect(secondRecordMessage.developerFields[11] == .uint16(5))
    }
}
