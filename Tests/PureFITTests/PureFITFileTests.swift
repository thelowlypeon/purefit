//
//  PureFITFileTests.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/15/25.
//

import Foundation
import Testing
@testable import PureFIT

struct PureFITFileTests {
    @Test func initWithDataTest() async throws {
        let data = try Fixture.workoutdoorsRunning.data
        let fit = try PureFITFile(data: data)
        #expect(fit.messages.count == 4285)
    }

    @Test func fieldsPresentIncludeDeveloperFields() async throws {
        let fit = try Fixture.workoutdoorsRunning.pureFITFile()
        let fieldDefinitions = fit.fieldDefinitions
        let recordMessageDefinitions = try #require(fieldDefinitions[GlobalMessageType.record.rawValue])
        // Inside #expect, a literal this long can't be type-checked in reasonable time on Swift 6.4.
        let expectedFields: [FieldDefinitionNumber] = [
            .standard(0),
            .standard(1),
            .standard(2),
            .standard(3),
            .standard(4),
            .standard(5),
            .standard(6),
            .standard(7),
            .standard(39),
            .standard(41),
            .standard(253),
            .developer(0, 5),
            .developer(0, 6),
            .developer(0, 8),
            .developer(0, 9),
            .developer(0, 11)
        ]
        #expect(recordMessageDefinitions.keys.sorted() == expectedFields)
    }

    @Test func fieldDefinitionsIncludeStandardFields() async throws {
        let fit = try Fixture.workoutdoorsRunning.pureFITFile()
        let fieldDefinitions = fit.fieldDefinitions
        let recordMessageFieldDefinitions = try #require(fieldDefinitions[GlobalMessageType.record.rawValue])
        let timestampFieldDefinition = try #require(recordMessageFieldDefinitions[.standard(253)] as? DateField)
        #expect(timestampFieldDefinition.name == "Timestamp")
    }

    @Test func fieldDefinitionsIncludeDeveloperFields() async throws {
        let fit = try Fixture.workoutdoorsRunning.pureFITFile()
        let fieldDefinitions = fit.fieldDefinitions
        let recordMessageFieldDefinitions = try #require(fieldDefinitions[GlobalMessageType.record.rawValue])
        let airPowerFieldDefinition = try #require(recordMessageFieldDefinitions[.developer(0, 11)] as? DeveloperField)
        #expect(airPowerFieldDefinition.name == "Air Power")
        #expect(airPowerFieldDefinition.units == "Watts")
        #expect(airPowerFieldDefinition.scale == 1)
        #expect(airPowerFieldDefinition.offset == 0)
    }

    @Test func fieldDefinitionsIncludeUndefinedFields() async throws {
        let fit = try Fixture.garminCycling.pureFITFile()
        let fieldDefinitions = fit.fieldDefinitions
        let message324Definitions = try #require(fieldDefinitions[324])
        let definition = try #require(message324Definitions[.standard(1)] as? UndefinedField)
        #expect(definition.globalMessageNumber == 324)
        #expect(definition.fieldDefinitionNumber == .standard(1))
        #expect(definition.parse(values: [.bytes([1,2])])?.fitValue == .bytes([1,2]))
    }

    @Test func fieldDefinitionsExcludeAbsentFields() async throws {
        let fit = try Fixture.workoutdoorsRunning.pureFITFile()
        let fieldDefinitions = fit.fieldDefinitions
        let recordMessageFieldDefinitions = try #require(fieldDefinitions[GlobalMessageType.record.rawValue])
        #expect((recordMessageFieldDefinitions[.standard(253)] as? DateField) != nil)
        #expect(recordMessageFieldDefinitions[.standard(254)] == nil)
    }

    @Test func fieldsPresentUnion() async throws {
        let fit = try Fixture.garminCycling.pureFITFile()
        let fieldDefinitions = fit.fieldDefinitions
        let recordMessageFields = try #require(fieldDefinitions[GlobalMessageType.record.rawValue])
        #expect(recordMessageFields[RecordMessage.Field.leftTorqueEffectiveness.fieldDefinitionNumber] != nil) // no left torque effectiveness value in the 9th record message
    }

    @Test func fieldsPresentIncludeUnrecognizedMessages() async throws {
        let fit = try Fixture.garminCycling.pureFITFile()
        let fieldDefinitions = fit.fieldDefinitions
        let message324Fields = try #require(fieldDefinitions[324])
        #expect(message324Fields.keys.sorted() == [.standard(1), .standard(2), .standard(253)])
    }

    @Test func developerFields() async throws {
        let fit = try Fixture.workoutdoorsRunning.pureFITFile()
        let developerFields = fit.developerFields
        #expect(developerFields.count == 5)
        let speed = try #require(developerFields[.developer(0, 5)])
        #expect(speed.name == "Speed")
        #expect(speed.baseType == .float32)
        #expect(speed.scale == 1.0)
        #expect(speed.offset == 0.0)
        #expect(speed.units == "M/S")
        #expect(speed.nativeMessageNumber == 5)
        let distance = try #require(developerFields[.developer(0, 6)])
        #expect(distance.name == "Distance")
        #expect(distance.baseType == .uint32)
        #expect(distance.scale == 1.0)
        #expect(distance.offset == 0.0)
        #expect(distance.units == "Meters")
        #expect(distance.nativeMessageNumber == nil)
        let formPower = try #require(developerFields[.developer(0, 8)])
        #expect(formPower.name == "Form Power")
        #expect(formPower.baseType == .uint16)
        #expect(formPower.scale == 1.0)
        #expect(formPower.offset == 0.0)
        #expect(formPower.units == "Watts")
        #expect(formPower.nativeMessageNumber == nil)
        let lss = try #require(developerFields[.developer(0, 9)])
        #expect(lss.name == "Leg Spring Stiffness")
        #expect(lss.baseType == .float32)
        #expect(lss.scale == 1.0)
        #expect(lss.offset == 0.0)
        #expect(lss.units == "KN/m")
        #expect(lss.nativeMessageNumber == nil)
        let air = try #require(developerFields[.developer(0, 11)])
        #expect(air.name == "Air Power")
        #expect(air.baseType == .uint16)
        #expect(air.scale == 1.0)
        #expect(air.offset == 0.0)
        #expect(air.units == "Watts")
        #expect(air.nativeMessageNumber == nil)
    }

    @Test func standardFieldValue() async throws {
        let fit = try Fixture.workoutdoorsRunning.pureFITFile()
        let activityMessages = fit.messages.compactMap { $0 as? ActivityMessage }
        #expect(activityMessages.count == 1)
        let activityMessage = try #require(activityMessages.first)
        let totalTimerTime = try #require(activityMessage.standardFieldValue(for: .totalTimerTime) as? DurationField.Value)
        #expect(totalTimerTime.format() == "1:11:07") // weird. not ideal. need to format durations in a more meanintful way
        #expect(totalTimerTime.duration == 4267.891)
        // this doesn't really need to be public, does it?
        let rawTotalTimerTimeValue = try #require(activityMessage.value(at: .totalTimerTime))
        #expect(rawTotalTimerTimeValue == .uint32(4267891))
    }

    @Test func developerFieldValue() async throws {
        let fit = try Fixture.workoutdoorsRunning.pureFITFile()
        let airPowerField = try #require(fit.developerFields[.developer(0, 11)])
        #expect(airPowerField.name == "Air Power")
        let recordMessages = fit.messages.compactMap { $0 as? RecordMessage }
        let recordMessage = try #require(recordMessages.first)
        let airPower = try #require(recordMessage.developerFieldValue(for: airPowerField))
        #expect(airPower.fitValue == .uint16(5))
        #expect(airPower.units == "Watts")
        #expect(airPower.format() == "5 Watts")
        let lssField = try #require(fit.developerFields[.developer(0, 9)])
        let lss = try #require(recordMessage.developerFieldValue(for: lssField))
        #expect(lss.fitValue == .float32(11.25))
        #expect(lss.fitValue.debugDescription == ".float32(11.25)")
        #expect(lss.fitValue.description == "11.25")
        #expect(lss.units == "KN/m")
        #expect(lss.format() == "11.25 KN/m")
    }

    @Test func uuidFieldValue() async throws {
        let fit = try Fixture.workoutdoorsRunning.pureFITFile()
        let developerDataIDMessage = try #require(fit.messages.filter { $0.globalMessageNumber == GlobalMessageType.developerDataID.rawValue }.first)
        let applicationIDFITValue = try #require(developerDataIDMessage.values(at: 1)?.first)
        #expect(applicationIDFITValue.debugDescription == ".bytes(57, 6F, 72, 6B, 4F, 75, 74, 44, 6F, 6F, 72, 73, 20, 41, 70, 70)")
        #expect(applicationIDFITValue.description == "576F726B-4F75-7444-6F6F-727320417070")
    }

    @Test func compositeFieldDefinition() async throws {
        let fit = try Fixture.strydRunning.pureFITFile()
        let laps = fit.messages.compactMap { $0 as? LapMessage }
        let lap = try #require(laps.first)
        let workoutStepIndex = try #require(lap.standardFieldValue(for: .workoutStepIndex) as? CompositeField<MessageIndex>.Value)
        // composite field format
        #expect(workoutStepIndex.format() == "0")
        #expect(workoutStepIndex.compositeValue.values == [.index(0)])
        #expect(workoutStepIndex.compositeValue.values.map(\.name) == ["Index"])
    }

    @Test func readSessionDeveloperFieldData() async throws {
        let fit = try Fixture.garminSDKCycling.pureFITFile()
        let developerFields = fit.developerFields
        let doughnutsEarnedField = try #require(developerFields[.developer(0, 0)])
        #expect(doughnutsEarnedField.name == "Doughnuts Earned")
        #expect(doughnutsEarnedField.units == "doughnuts")
        let session = try #require(fit.messages.compactMap { $0 as? SessionMessage }.first)
        let doughnutsEarnedValue = try #require(session.developerFieldValue(for: doughnutsEarnedField))
        #expect(doughnutsEarnedValue.fitValue == .float32(3.0008333))
        #expect(doughnutsEarnedValue.format() == "3.0008333 doughnuts") // no float funny business!
    }

    @Test func parsingGarminFITFile() async throws {
        let raw = try Fixture.garminCycling.rawFITFile()
        let fit = try PureFITFile(rawFITFile: raw)
        #expect(fit.messages.count == 23291)
        let firstRecord = try #require(fit.messages.first(where: { $0.globalMessageNumber == 20 }))
        #expect(firstRecord.value(at: 6) == .uint16(4264)) // NOTE: fitfileviewer.com says this is enhanced speed, field 73 uint32

        let hrvMessages = fit.messages.compactMap { $0 as? HRVMessage }
        #expect(hrvMessages.count == 11571)
        let firstHRVMessage = try #require(hrvMessages.first)
        #expect(firstHRVMessage.values(at: 0) == [.uint16(558), .uint16(557)])
    }

    @Test func parsingActivityWithDeveloperData() async throws {
        // this file from garmin's FIT cookbook
        let raw = try Fixture.garminSDKCycling.rawFITFile()
        let fit = try PureFITFile(rawFITFile: raw)
        #expect(fit.messages.count == 3611)
    }

    @Test func parsingFITFile() async throws {
        let fit = try Fixture.workoutdoorsRunning.pureFITFile()

        // fileId message
        #expect(fit.messages.count(where: { $0.globalMessageNumber == 0 }) == 1)
        let fileIdMessage = try #require(fit.messages.first(where: { $0.globalMessageNumber == 0 }))
        #expect(fileIdMessage.fields.keys.sorted() == [.standard(0),.standard(1),.standard(3),.standard(4)])
        let fileType = try #require(fileIdMessage.value(at: .standard(0)))
        #expect(fileType == .enum(4)) // file type
        let manufacturer = try #require(fileIdMessage.value(at: .standard(1)))
        #expect(manufacturer == .uint16(255)) // manufacturer
        let serial = try #require(fileIdMessage.value(at: .standard(3)))
        #expect(serial == .uint32z(282475249)) // serial
        let timeCreated = try #require(fileIdMessage.value(at: .standard(4)))
        #expect(timeCreated == .uint32(1100201060)) // time created

        // developer data id
        #expect(fit.messages.count(where: { $0.globalMessageNumber == 207 }) == 1)
        let developerDataIdMessage = try #require(fit.messages.filter { $0.globalMessageNumber == 207 }.first)
        #expect(developerDataIdMessage.value(at: 1) == .bytes([87, 111, 114, 107, 79, 117, 116, 68, 111, 111, 114, 115, 32, 65, 112, 112]))

        // record messages
        #expect(fit.messages.count(where: { $0.globalMessageNumber == 20 }) == 4257)
        let secondRecordMessage = fit.messages.filter { $0.globalMessageNumber == 20 }[1]
        let expectedRecordFields: [FieldDefinitionNumber] = [
            .standard(0),.standard(1),.standard(2),.standard(3),.standard(4),.standard(5),.standard(6),.standard(7),.standard(39),.standard(41),.standard(253),
            .developer(0, 5), .developer(0, 6), .developer(0, 8), .developer(0, 9), .developer(0, 11)
        ]
        #expect(secondRecordMessage.fields.keys.sorted() == expectedRecordFields)
        let timestamp = try #require(secondRecordMessage.value(at: 253))
        #expect(timestamp == .uint32(1096542999))
        let latitude = try #require(secondRecordMessage.value(at: 0))
        #expect(latitude == .sint32(500395805))
        let longitude = try #require(secondRecordMessage.value(at: 1))
        #expect(longitude == .sint32(-1045723574))
        let altitude = try #require(secondRecordMessage.value(at: 2))
        #expect(altitude == .uint16(3415))
        let distance = try #require(secondRecordMessage.value(at: 5))
        #expect(distance == .uint32(1400))
        let speed = try #require(secondRecordMessage.value(at: 6))
        #expect(speed == .uint16(2434))
        let heartRate = try #require(secondRecordMessage.value(at: 3))
        #expect(heartRate == .uint8(118))
        let cadence = try #require(secondRecordMessage.value(at: 4))
        #expect(cadence == .uint8(86))
        let verticalOscillation = try #require(secondRecordMessage.value(at: 39))
        #expect(verticalOscillation == .uint16(540))
        let stanceTime = try #require(secondRecordMessage.value(at: 41))
        #expect(stanceTime == .uint16(2520))
        let power = try #require(secondRecordMessage.value(at: 7))
        #expect(power == .uint16(190))

        // developer fields
        let developerFieldDefinitions = fit.messages.filter { $0.globalMessageNumber == 206 }
        #expect(developerFieldDefinitions.count == 5)
        #expect(secondRecordMessage.value(at: .developer(0, 5)) == .float32(2.43359375))
        #expect(secondRecordMessage.value(at: .developer(0, 6)) == .uint32(14))
        #expect(secondRecordMessage.value(at: .developer(0, 8)) == .uint16(61))
        #expect(secondRecordMessage.value(at: .developer(0, 9)) == .float32(11.25))
        #expect(secondRecordMessage.value(at: .developer(0, 11)) == .uint16(5))
    }
}
