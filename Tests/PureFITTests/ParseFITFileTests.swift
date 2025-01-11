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
        struct ParsedDataRecord {
            let definition: FITDefinitionRecord
            let data: FITDataRecord
        }
        var dataRecords = [UInt16: [ParsedDataRecord]]()
        for record in fit.records {
            switch record {
            case .definition(let def):
                definitionRecords[def.globalMessageNumber] = def
            case .data(let data):
                guard let def = definitionRecords[data.globalMessageNumber] else {
                    Issue.record("no definition for \(data.globalMessageNumber)")
                    return
                }
                if dataRecords[data.globalMessageNumber] == nil {
                    dataRecords[data.globalMessageNumber] = [ParsedDataRecord]()
                }
                dataRecords[data.globalMessageNumber]!.append(.init(definition: def, data: data))
            }
        }
        for (messageType, records) in dataRecords {
            print("messageType \(messageType) (\(records.count) records)")
            if let definition = definitionRecords[messageType] {
                for (index, record) in records.enumerated() {
                    print("---- record \(index) ----")
                    var offset = 0
                    for field in record.definition.fields {
                        print("  * \(field.fieldDefinitionNumber): \(field.baseType)")
                        switch field.baseType {
                        case .uint8, .byte, .enum:
                            let byte = UInt8(record.data.fieldsData.bytes[offset])
                            print("    \(byte)")
                        case .uint16:
                            let uint16 = record.data.fieldsData.uint16(at: offset, architecture: definition.architecture)
                            print("    \(uint16)")
                        case .uint32, .uint32z:
                            let uint32 = record.data.fieldsData.uint32(at: offset, architecture: definition.architecture)
                            print("    \(uint32)")
                        case .string:
                            let str = record.data.fieldsData.string(at: offset)
                            print("    \(str)")
                        default:
                            print("    unknown")
                        }
                        offset += Int(field.size)
                    }
                }
            } else {
                print("can't make sense of this record")
            }
        }

    }
}
