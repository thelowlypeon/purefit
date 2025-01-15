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

    /*
    @Test func parsingFITFile() async throws {
        let url = Bundle.module.url(forResource: "fitfile1", withExtension: "fit", subdirectory: "Fixtures")!
        let fit = try FITFile(url: url)
        let parsed = InterpretedFITFile(fitFile: fit)

        // fileId message
        #expect(parsed.messages.count(where: { $0.globalMessageNumber == 0 }) == 1)
        let fileIdMessage = try #require(parsed.messages.first(where: { $0.globalMessageNumber == 0 }))
        #expect(fileIdMessage.fields.map { $0.fieldDefinitionNumber }.sorted() == [0,1,3,4])
        #expect(fileIdMessage.first(fieldDefinitionNumber: 0)?.interpretedValue == .enum(4)) // file type
        #expect(fileIdMessage.first(fieldDefinitionNumber: 1)?.interpretedValue == .uint16(255)) // manufacturer
        #expect(fileIdMessage.first(fieldDefinitionNumber: 3)?.interpretedValue == .uint32z(282475249)) // serial
        #expect(fileIdMessage.first(fieldDefinitionNumber: 4)?.interpretedValue == .uint32(1100201060)) // time created

        // record messages
        #expect(parsed.messages.count(where: { $0.globalMessageNumber == 20 }) == 4257)
        let secondRecordMessage = try #require(parsed.messages.filter { $0.globalMessageNumber == 20 }[1])
        #expect(secondRecordMessage.fields.map { $0.fieldDefinitionNumber }.sorted() == [0,1,2,3,4,5,6,7,39,41,253])
        #expect(secondRecordMessage.first(fieldDefinitionNumber: 253)?.interpretedValue == .uint32(1096542999))
        #expect(secondRecordMessage.first(fieldDefinitionNumber: 0)?.interpretedValue == .sint32(500395805))
        #expect(secondRecordMessage.first(fieldDefinitionNumber: 1)?.interpretedValue == .sint32(-1045723574))
        #expect(secondRecordMessage.first(fieldDefinitionNumber: 2)?.interpretedValue == .uint16(3415))
        #expect(secondRecordMessage.first(fieldDefinitionNumber: 5)?.interpretedValue == .uint32(1400))
        #expect(secondRecordMessage.first(fieldDefinitionNumber: 6)?.interpretedValue == .uint16(2434))
        #expect(secondRecordMessage.first(fieldDefinitionNumber: 3)?.interpretedValue == .uint8(118))
        #expect(secondRecordMessage.first(fieldDefinitionNumber: 4)?.interpretedValue == .uint8(86))
        #expect(secondRecordMessage.first(fieldDefinitionNumber: 39)?.interpretedValue == .uint16(540))
        #expect(secondRecordMessage.first(fieldDefinitionNumber: 41)?.interpretedValue == .uint16(2520))
        #expect(secondRecordMessage.first(fieldDefinitionNumber: 7)?.interpretedValue == .uint16(190))

        // developer fields
        let developerFieldDefinitions = parsed.messages.filter { $0.globalMessageNumber == 206 }
        #expect(developerFieldDefinitions.count == 5)
        let developerValues = developerFieldDefinitions.map { developerFieldDefinition in
            guard let baseTypeField = developerFieldDefinition.first(fieldDefinitionNumber: 1)?.interpretedValue,
                  case .uint8(let baseTypeRawValue) = baseTypeField
            else {
                Issue.record("Failed to get base type from developer field")
                return
            }
            let baseType: FITBaseType
            switch baseTypeField {
            case .uint8(let baseTypeRawValue):
                baseType = try #require(FITBaseType(rawValue: baseTypeRawValue))
            default:
                Issue.record("could not find base type from developer field definition")
                return
            }

            let fieldDefinitionNumberField = try #require(developerFieldDefinition.first(fieldDefinitionNumber: 2)?.interpretedValue)
            let fieldDefinitionNumber: UInt8


            let bytes = secondRecordMessage.first(developerFieldDefinitionNumber: fieldDefinitionNumber)?.bytes
            return InterpretedFITValue.from(bytes: bytes, baseType: baseType, architecture: .littleEndian)
        }
        #expect(secondRecordMessage.developerFields.map { $0.fieldDefinitionNumber }.sorted() == [5,6,8,9,11])
        /*
        #expect(secondRecordMessage.developerFields[5] == .float32(2.43359375))
        #expect(secondRecordMessage.developerFields[6] == .uint32(14))
        #expect(secondRecordMessage.developerFields[8] == .uint16(61))
        #expect(secondRecordMessage.developerFields[9] == .float32(11.25))
        #expect(secondRecordMessage.developerFields[11] == .uint16(5))
         */
    }
     */
}
