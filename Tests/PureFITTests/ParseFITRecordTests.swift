//
//  ParseFITRecordTests.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/11/25.
//

import Testing
import Foundation
@testable import PureFIT

struct ParseFITRecordTests {
    @Test func parseDefinitionAndSubsequentDataRecordTest() async throws {
        let url = Bundle.module.url(forResource: "fitfile1", withExtension: "fit", subdirectory: "Fixtures")!
        let data = try Data(contentsOf: url)

        var definitions: [UInt16: FITDefinitionRecord] = [:]
        var offset = 14 // skip the header

        let definitionRecord = try #require(FITRecord(data: data, offset: &offset, definitions: &definitions))
        let dataRecord = try #require(FITRecord(data: data, offset: &offset, definitions: &definitions))

        if case .definition(let definition) = definitionRecord {
            #expect(definition.architecture == .littleEndian)
            #expect(definition.globalMessageNumber == 0) // fileId
            #expect(definition.fieldCount == 4)
            #expect(definition.fields.map { $0.fieldDefinitionNumber } == [0,1,4,3])
            #expect(definition.fields.map { $0.size } == [1,2,4,4])
            #expect(definition.fields.map { $0.baseType.rawValue } == [0,132,134,140])
        } else {
            Issue.record("definition record incorrectly parsed as data record")
        }
        if case .data(let data) = dataRecord {
            #expect(data.globalMessageNumber == 0)
            #expect(data.fieldsData.bytes[0] == 4) // file type 4 = workout file
            let manufacturer = data.fieldsData.uint16(at: 1)
            #expect(manufacturer == 255) // 255 is development manufacturer id
            let timeCreated = data.fieldsData.uint32(at: 3)
            #expect(timeCreated == 1100201060) // seconds since garmin epoch
            let serial = data.fieldsData.uint32(at: 7)
            #expect(serial == 282475249)
        } else {
            Issue.record("data record incorrectly parsed as definition record")
        }
    }

    @Test func parseSecondDefinitionAndSubsequentDataRecord() async throws {
        let url = Bundle.module.url(forResource: "fitfile1", withExtension: "fit", subdirectory: "Fixtures")!
        let data = try Data(contentsOf: url)

        var definitions: [UInt16: FITDefinitionRecord] = [:]
        var offset = 14 + 30 // header + fileId header and record

        let definitionRecord = try #require(FITRecord(data: data, offset: &offset, definitions: &definitions))
        let dataRecord = try #require(FITRecord(data: data, offset: &offset, definitions: &definitions))

        if case .definition(let definition) = definitionRecord {
            #expect(definition.architecture == .littleEndian)
            #expect(definition.globalMessageNumber == 23) // deviceInfo
            #expect(definition.fieldCount == 6)
            // 0: device index, 2: manufacturer, 27: product name, 3: serial, 5: software version, 253: timestamp
            #expect(definition.fields.map { $0.fieldDefinitionNumber } == [0,2,27,3,5,253])
            #expect(definition.fields.map { $0.size } == [1,2,13,4,2,4]) // strings are variable, this one is 13
            #expect(definition.fields.map { $0.baseType.rawValue } == [2,132,7,140,132,134])
        } else {
            Issue.record("definition record incorrectly parsed as data record")
        }
        if case .data(let data) = dataRecord {
            #expect(data.fieldsData.bytes.count == 26)
            #expect(data.globalMessageNumber == 23)
            #expect(data.fieldsData.bytes[0] == 0) // deviceIndex 0
            let manufacturer = data.fieldsData.uint16(at: 1)
            #expect(manufacturer == 255) // 255 is development manufacturer id
            let productName = data.fieldsData.string(at: 3)
            #expect(productName == "WorkOutDoors") // Shoutout to WorkOutDoors!
            let serial = data.fieldsData.uint32(at: 16)
            #expect(serial == 282475249)
            let softwareVersion = data.fieldsData.uint16(at: 20)
            #expect(softwareVersion == nil)
            let timestamp = data.fieldsData.uint32(at: 22)
            #expect(timestamp == 1100201060) // seconds since garmin epoch
        } else {
            Issue.record("data record incorrectly parsed as definition record")
        }
    }

    @Test func parseManyRecordsTest() async throws {
        let url = Bundle.module.url(forResource: "fitfile1", withExtension: "fit", subdirectory: "Fixtures")!
        let data = try Data(contentsOf: url)

        var definitions: [UInt16: FITDefinitionRecord] = [:]
        var offset = 14

        var records = [FITRecord]()
        for _ in 0..<50 {
            let record = try FITRecord(data: data, offset: &offset, definitions: &definitions)
            records.append(record)
        }
        // 23: device info
        // 21: event
        // 207: developerDataId
        // 206: fieldDescription
        // 20: record
        #expect(records.count == 50)
        switch records[0] {
        case .definition(let def):
            #expect(def.globalMessageNumber == 0)
        default: Issue.record("expected first record to be a definition message")
        }
        switch records[1] {
        case .data(let data):
            #expect(data.globalMessageNumber == 0)
        default: Issue.record("expected second record to be a data message")
        }
        switch records[2] {
        case .definition(let def):
            #expect(def.globalMessageNumber == 23) // device info
        default: Issue.record("expected first record to be a definition message")
        }
        switch records[3] {
        case .data(let data):
            #expect(data.globalMessageNumber == 23)
        default: Issue.record("expected second record to be a data message")
        }
        switch records[4] {
        case .definition(let def):
            #expect(def.globalMessageNumber == 21) // event
        default: Issue.record("expected second record to be a definition message")
        }
        switch records[5] {
        case .data(let data):
            #expect(data.globalMessageNumber == 21)
        default: Issue.record("expected second record to be a data message")
        }
        switch records[6] {
        case .definition(let def):
            #expect(def.globalMessageNumber == 207) // developerDataId
        default: Issue.record("expected second record to be a definition message")
        }
        switch records[7] {
        case .data(let data):
            #expect(data.globalMessageNumber == 207)
        default: Issue.record("expected second record to be a data message")
        }
        switch records[8] {
        case .definition(let def):
            #expect(def.globalMessageNumber == 206) // fieldDescription
        default: Issue.record("expected second record to be a definition message")
        }
        switch records[9] {
        case .data(let data):
            #expect(data.globalMessageNumber == 206)
        default: Issue.record("expected second record to be a data message")
        }

    }
}
