//
//  ParseFITRecordTests.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/11/25.
//

import Testing
import Foundation
@testable import PureFIT

struct RawFITRecordTests {
    @Test func parseDefinitionAndSubsequentDataRecordTest() async throws {
        let url = Bundle.module.url(forResource: "fitfile1", withExtension: "fit", subdirectory: "Fixtures")!
        let data = try Data(contentsOf: url)

        var definitions: [UInt16: RawFITDefinitionRecord] = [:]
        var offset = 14 // skip the header

        let definitionRecord = try #require(RawFITRecord(data: data, offset: &offset, definitions: &definitions))
        let dataRecord = try #require(RawFITRecord(data: data, offset: &offset, definitions: &definitions))

        guard case .definition(let definition) = definitionRecord
        else {
            Issue.record("definition record incorrectly parsed as data record")
            return
        }

        #expect(definition.architecture == .littleEndian)
        #expect(definition.globalMessageNumber == 0) // fileId
        #expect(definition.fieldCount == 4)
        #expect(definition.fields.map { $0.fieldDefinitionNumber } == [0,1,4,3])
        #expect(definition.fields.map { $0.size } == [1,2,4,4])
        #expect(definition.fields.map { $0.baseType } == [.enum, .uint16, .uint32, .uint32z])

        guard case .data(let data) = dataRecord
        else {
            Issue.record("data record incorrectly parsed as definition record")
            return
        }

        #expect(data.globalMessageNumber == 0)
        #expect(data.fieldsData[0] == 4) // file type 4 = workout file
        let manufacturer = data.fieldsData.uint16(at: 1, architecture: definition.architecture)
        #expect(manufacturer == 255) // 255 is development manufacturer id
        let timeCreated = data.fieldsData.uint32(at: 3, architecture: definition.architecture)
        #expect(timeCreated == 1100201060) // seconds since garmin epoch
        let serial = data.fieldsData.uint32(at: 7, architecture: definition.architecture)
        #expect(serial == 282475249)
    }

    @Test func parseSecondDefinitionAndSubsequentDataRecord() async throws {
        let url = Bundle.module.url(forResource: "fitfile1", withExtension: "fit", subdirectory: "Fixtures")!
        let data = try Data(contentsOf: url)

        var definitions: [UInt16: RawFITDefinitionRecord] = [:]
        var offset = 14 + 30 // header + fileId header and record

        let definitionRecord = try #require(RawFITRecord(data: data, offset: &offset, definitions: &definitions))
        let dataRecord = try #require(RawFITRecord(data: data, offset: &offset, definitions: &definitions))

        guard case .definition(let definition) = definitionRecord
        else {
            Issue.record("definition record incorrectly parsed as data record")
            return
        }
        #expect(definition.architecture == .littleEndian)
        #expect(definition.globalMessageNumber == 23) // deviceInfo
        #expect(definition.fieldCount == 6)
        // 0: device index, 2: manufacturer, 27: product name, 3: serial, 5: software version, 253: timestamp
        #expect(definition.fields.map { $0.fieldDefinitionNumber } == [0,2,27,3,5,253])
        #expect(definition.fields.map { $0.size } == [1,2,13,4,2,4]) // strings are variable, this one is 13
        #expect(definition.fields.map { $0.baseType } == [.uint8, .uint16, .string, .uint32z, .uint16, .uint32])

        guard case .data(let data) = dataRecord
        else {
            Issue.record("data record incorrectly parsed as definition record")
            return
        }
        #expect(data.fieldsData.count == 26)
        #expect(data.globalMessageNumber == 23)
        #expect(data.fieldsData[0] == 0) // deviceIndex 0
        let manufacturer = data.fieldsData.uint16(at: 1, architecture: definition.architecture)
        #expect(manufacturer == 255) // 255 is development manufacturer id
        let productName = data.fieldsData.string(at: 3)
        #expect(productName == "WorkOutDoors") // Shoutout to WorkOutDoors!
        let serial = data.fieldsData.uint32(at: 16, architecture: definition.architecture)
        #expect(serial == 282475249)
        let softwareVersion = data.fieldsData.uint16(at: 20, architecture: definition.architecture)
        #expect(softwareVersion == nil)
        let timestamp = data.fieldsData.uint32(at: 22, architecture: definition.architecture)
        #expect(timestamp == 1100201060) // seconds since garmin epoch
    }

    @Test func parseManyRecordsTest() async throws {
        let url = Bundle.module.url(forResource: "fitfile1", withExtension: "fit", subdirectory: "Fixtures")!
        let data = try Data(contentsOf: url)

        var definitions: [UInt16: RawFITDefinitionRecord] = [:]
        var offset = 14

        var records = [RawFITRecord]()
        for _ in 0..<50 {
            let record = try RawFITRecord(data: data, offset: &offset, definitions: &definitions)
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
        switch records[8] { // air power def
        case .definition(let def):
            #expect(def.globalMessageNumber == 206) // fieldDescription
            #expect(def.architecture == .littleEndian)
            #expect(def.fields.count == 5) // dev data index, field def, base type, field name, units
            #expect(def.fields[0].fieldDefinitionNumber == 0) // developer data index
            #expect(def.fields[0].baseType == .uint8)
            #expect(def.fields[0].size == 1)
            #expect(def.fields[1].fieldDefinitionNumber == 1) // field definition number
            #expect(def.fields[1].baseType == .uint8)
            #expect(def.fields[1].size == 1)
            #expect(def.fields[2].fieldDefinitionNumber == 2) // base type
            #expect(def.fields[2].baseType == .uint8)
            #expect(def.fields[2].size == 1)
            #expect(def.fields[3].fieldDefinitionNumber == 3) // field name
            #expect(def.fields[3].baseType == .string)
            #expect(def.fields[3].size == 10) // null byte terminated
            #expect(def.fields[4].fieldDefinitionNumber == 8) // units
            #expect(def.fields[4].baseType == .string)
            #expect(def.fields[4].size == 6) // null byte terminated
        default: Issue.record("expected second record to be a definition message")
        }
        switch records[9] {
        case .data(let data):
            #expect(data.globalMessageNumber == 206)
            #expect(data.fieldsData[0] == 0) // developer data index
            #expect(data.fieldsData[1] == 11) // field def
            #expect(data.fieldsData[2] == 132) // base type
            #expect(data.fieldsData.string(at: 3) == "Air Power") // field name
            #expect(data.fieldsData.string(at: 13) == "Watts") // units
        default: Issue.record("expected second record to be a data message")
        }
        switch records[12] { // LSS def
        case .definition(let def):
            #expect(def.globalMessageNumber == 206) // fieldDescription
            #expect(def.architecture == .littleEndian)
            #expect(def.fields.count == 5) // dev data index, field def, base type, field name, units
            #expect(def.fields[0].fieldDefinitionNumber == 0) // developer data index
            #expect(def.fields[0].baseType == .uint8)
            #expect(def.fields[0].size == 1)
            #expect(def.fields[1].fieldDefinitionNumber == 1) // field definition number
            #expect(def.fields[1].baseType == .uint8)
            #expect(def.fields[1].size == 1)
            #expect(def.fields[2].fieldDefinitionNumber == 2) // base type
            #expect(def.fields[2].baseType == .uint8)
            #expect(def.fields[2].size == 1)
            #expect(def.fields[3].fieldDefinitionNumber == 3) // field name
            #expect(def.fields[3].baseType == .string)
            #expect(def.fields[3].size == 21) // null byte terminated
            #expect(def.fields[4].fieldDefinitionNumber == 8) // units
            #expect(def.fields[4].baseType == .string)
            #expect(def.fields[4].size == 5) // null byte terminated
        default: Issue.record("expected second record to be a definition message")
        }
        switch records[13] {
        case .data(let data):
            #expect(data.globalMessageNumber == 206)
            #expect(data.fieldsData[0] == 0) // developer data index
            #expect(data.fieldsData[1] == 9) // field def
            #expect(data.fieldsData[2] == 136) // base type
            #expect(data.fieldsData.string(at: 3) == "Leg Spring Stiffness") // field name
            #expect(data.fieldsData.string(at: 24) == "KN/m") // units
        default: Issue.record("expected second record to be a data message")
        }
        // ...
        let definition: RawFITDefinitionRecord
        switch records[18] {
        case .definition(let def):
            definition = def
            #expect(def.developerFields.count == 5)
            #expect(def.globalMessageNumber == 20)
            #expect(def.developerFields.count == 5)
            let airPowerDef = try #require(def.developerFields.first)
            #expect(airPowerDef.developerDataIndex == 0)
            #expect(airPowerDef.developerFieldDefinitionNumber == 11)
            #expect(airPowerDef.size == 2)
            let formPowerDef = def.developerFields[1]
            #expect(formPowerDef.developerDataIndex == 0)
            #expect(formPowerDef.developerFieldDefinitionNumber == 8)
            #expect(formPowerDef.size == 2)
            let lssDef = def.developerFields[2]
            #expect(lssDef.developerDataIndex == 0)
            #expect(lssDef.developerFieldDefinitionNumber == 9)
            #expect(lssDef.size == 4)
            let speedDef = def.developerFields[3]
            #expect(speedDef.developerDataIndex == 0)
            #expect(speedDef.developerFieldDefinitionNumber == 5)
            #expect(speedDef.size == 4)
        default:
            Issue.record("expected second record to be a data message")
            return
        }
        switch records[25] { // 7th Record message
        case .data(let data):
            #expect(data.globalMessageNumber == 20)
            let size: Int = definition.developerFields.reduce(into: 0) { $0 += Int($1.size) }
            #expect(data.developerFieldsData.count == size)

            let airPower = data.developerFieldsData.uint16(at: 0, architecture: .littleEndian)
            #expect(airPower == 3)
            let formPower = data.developerFieldsData.uint16(at: 2, architecture: .littleEndian)
            #expect(formPower == 61)
            let lss = data.developerFieldsData.float32(at: 4, architecture: .littleEndian)
            #expect(lss == 11.25)
            let speed = data.developerFieldsData.float32(at: 8, architecture: .littleEndian)
            #expect(speed == 2.98828125)
        default: Issue.record("expected second record to be a data message")
        }

    }
}
