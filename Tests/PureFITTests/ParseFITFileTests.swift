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
        let data = try Data(contentsOf: url)
        let fit = try FITFile(data: data)
        let crcSize = fit.header.crc == nil ? 0 : 2
        #expect(Int(fit.header.dataSize) + Int(fit.header.headerSize) + crcSize == 193162)
        #expect(fit.records.count == 4301)
    }

    @Test func parseInvalidFile() async throws {
        let url = Bundle.module.url(forResource: "not-a-fit-file", withExtension: "fit", subdirectory: "Fixtures")!
        let data = try Data(contentsOf: url)
        do {
            let fit = try FITFile(data: data)
            Issue.record("expected error when parsing invalid FIT file")
            return
        } catch {
            switch error {
            case FITHeader.ParserError.invalidLength:
                break
            default:
                Issue.record("raised unexpected parsing error when parsing invalid FIT file: \(error)")
                return
            }
        }
    }

    @Test func makingSenseOfAParsedFITFileTest() async throws {
        let url = Bundle.module.url(forResource: "fitfile1", withExtension: "fit", subdirectory: "Fixtures")!
        let data = try Data(contentsOf: url)
        let fit = try FITFile(data: data)
        var definitionRecords = [UInt16: FITDefinitionRecord]()
        struct ParsedDataRecordGroup {
            let definition: FITDefinitionRecord
            var dataRecords: [FITDataRecord]
        }
        let recordRecords = fit.records.filter {
            switch $0 {
            case .definition(let definitionRecord):
                return definitionRecord.globalMessageNumber == 20
            case .data(let dataRecord):
                return dataRecord.globalMessageNumber == 20
            }
        }

        // group records together by their definition because definitions can change within a single file
        var parsedDataRecords = [ParsedDataRecordGroup]()
        var parsedDataRecordGroup: ParsedDataRecordGroup? = nil
        for record in recordRecords {
            switch record {
            case .definition(let definitionRecord):
                if let existingGroup = parsedDataRecordGroup {
                    parsedDataRecords.append(existingGroup)
                }
                parsedDataRecordGroup = ParsedDataRecordGroup(definition: definitionRecord, dataRecords: [])
            case .data(let dataRecord):
                parsedDataRecordGroup?.dataRecords.append(dataRecord)
            }
        }
        if let parsedDataRecordGroup {
            parsedDataRecords.append(parsedDataRecordGroup)
        }
        // end grouping by definition

        guard let firstRecordGroup = parsedDataRecords.first
        else {
            Issue.record("no grouped records")
            return
        }
        let definition = firstRecordGroup.definition
        guard firstRecordGroup.dataRecords.count > 1
        else {
            Issue.record("no record in group")
            return
        }
        let record = firstRecordGroup.dataRecords[1] // this one is more interesting than the first
        var offset = 0
        for field in definition.fields {
            switch field.fieldDefinitionNumber {
            case 253: // timestamp
                let value = record.fieldsData.uint32(at: offset, architecture: definition.architecture)
                #expect(value == 1096542999)
            case 0: // latitude, sint32
                break
            case 1: // longitude, sint32
                break
            case 2: // altitude, uint32
                let value = record.fieldsData.uint16(at: offset, architecture: definition.architecture)
                #expect(value == 3415)
            case 5: // distance, uint32
                let value = record.fieldsData.uint32(at: offset, architecture: definition.architecture)
                #expect(value == 1400)
            case 6: // speed, uint32
                let value = record.fieldsData.uint16(at: offset, architecture: definition.architecture)
                #expect(value == 2434)
            case 3: // heart rate, uint8
                let value = record.fieldsData.bytes[offset]
                #expect(value == 118)
            case 4: // cadence, uint8
                let value = record.fieldsData.bytes[offset]
                #expect(value == 86)
            case 39: // verticaloscillation, uint16
                let value = record.fieldsData.uint16(at: offset, architecture: definition.architecture)
                #expect(value == 540)
            case 41: // stance time duration, uint16
                let value = record.fieldsData.uint16(at: offset, architecture: definition.architecture)
                #expect(value == 2520)
            case 7: // power, uint16
                let value = record.fieldsData.uint16(at: offset, architecture: definition.architecture)
                #expect(value == 190)
            default:
                break
            }

            offset += Int(field.size)
        }
    }
}
