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
    @Test func fieldsPresentIncludeDeveloperFields() async throws {
        let url = Bundle.module.url(forResource: "fitfile1", withExtension: "fit", subdirectory: "Fixtures")!
        let fit = try PureFITFile(url: url)
        let fieldDefinitions = fit.fieldDefinitions
        let recordMessageDefinitions = try #require(fieldDefinitions[GlobalMessageType.record.rawValue])
        #expect(
            recordMessageDefinitions.keys.sorted() == [
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
        )
    }

    @Test func fieldDefinitionsIncludeStandardFields() async throws {
        let url = Bundle.module.url(forResource: "fitfile1", withExtension: "fit", subdirectory: "Fixtures")!
        let fit = try PureFITFile(url: url)
        let fieldDefinitions = fit.fieldDefinitions
        let recordMessageFieldDefinitions = try #require(fieldDefinitions[GlobalMessageType.record.rawValue])
        let timestampFieldDefinition = try #require(recordMessageFieldDefinitions[.standard(253)] as? DateField)
        #expect(timestampFieldDefinition.name == "Timestamp")
    }

    @Test func fieldDefinitionsIncludeDeveloperFields() async throws {
        let url = Bundle.module.url(forResource: "fitfile1", withExtension: "fit", subdirectory: "Fixtures")!
        let fit = try PureFITFile(url: url)
        let fieldDefinitions = fit.fieldDefinitions
        let recordMessageFieldDefinitions = try #require(fieldDefinitions[GlobalMessageType.record.rawValue])
        let airPowerFieldDefinition = try #require(recordMessageFieldDefinitions[.developer(0, 11)] as? DeveloperField)
        #expect(airPowerFieldDefinition.name == "Air Power")
        #expect(airPowerFieldDefinition.units == "Watts")
        #expect(airPowerFieldDefinition.scale == 1)
        #expect(airPowerFieldDefinition.offset == 0)
    }

    @Test func fieldDefinitionsIncludeUndefinedFields() async throws {
        let url = Bundle.module.url(forResource: "cyclingActivityFromGarmin", withExtension: "fit", subdirectory: "Fixtures")!
        let fit = try PureFITFile(url: url)
        let fieldDefinitions = fit.fieldDefinitions
        let message324Definitions = try #require(fieldDefinitions[324])
        let definition = try #require(message324Definitions[.standard(1)] as? UndefinedField)
        #expect(definition.globalMessageNumber == 324)
        #expect(definition.fieldDefinitionNumber == .standard(1))
        #expect(definition.parse(values: [.bytes([1,2])])?.fitValue == .bytes([1,2]))
    }

    @Test func fieldDefinitionsExcludeAbsentFields() async throws {
        let url = Bundle.module.url(forResource: "fitfile1", withExtension: "fit", subdirectory: "Fixtures")!
        let fit = try PureFITFile(url: url)
        let fieldDefinitions = fit.fieldDefinitions
        let recordMessageFieldDefinitions = try #require(fieldDefinitions[GlobalMessageType.record.rawValue])
        #expect((recordMessageFieldDefinitions[.standard(253)] as? DateField) != nil)
        #expect(recordMessageFieldDefinitions[.standard(254)] == nil)
    }

    @Test func fieldsPresentUnion() async throws {
        let url = Bundle.module.url(forResource: "cyclingActivityFromGarmin", withExtension: "fit", subdirectory: "Fixtures")!
        let fit = try PureFITFile(url: url)
        let fieldDefinitions = fit.fieldDefinitions
        let recordMessageFields = try #require(fieldDefinitions[GlobalMessageType.record.rawValue])
        #expect(recordMessageFields[RecordMessage.Field.leftTorqueEffectiveness.fieldDefinitionNumber] != nil) // no left torque effectiveness value in the 9th record message
    }

    @Test func fieldsPresentIncludeUnrecognizedMessages() async throws {
        let url = Bundle.module.url(forResource: "cyclingActivityFromGarmin", withExtension: "fit", subdirectory: "Fixtures")!
        let fit = try PureFITFile(url: url)
        let fieldDefinitions = fit.fieldDefinitions
        let message324Fields = try #require(fieldDefinitions[324])
        #expect(message324Fields.keys.sorted() == [.standard(1), .standard(2), .standard(253)])
    }

    @Test func developerFields() async throws {
        let url = Bundle.module.url(forResource: "fitfile1", withExtension: "fit", subdirectory: "Fixtures")!
        let fit = try PureFITFile(url: url)
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
        let url = Bundle.module.url(forResource: "fitfile1", withExtension: "fit", subdirectory: "Fixtures")!
        let fit = try PureFITFile(url: url)
        let activityMessages = fit.messages.compactMap { $0 as? ActivityMessage }
        #expect(activityMessages.count == 1)
        let activityMessage = try #require(activityMessages.first)
        let totalTimerTime = try #require(activityMessage.standardFieldValue(for: .totalTimerTime) as? DurationField.Value)
        #expect(totalTimerTime.format() == "1.186h") // weird. not ideal. need to format durations in a more meanintful way
        #expect(totalTimerTime.measurement.converted(to: .minutes).value.rounded() == 71)
        // this doesn't really need to be public, does it?
        let rawTotalTimerTimeValue = try #require(activityMessage.value(at: .totalTimerTime))
        #expect(rawTotalTimerTimeValue == .uint32(4267891))
    }

    @Test func developerFieldValue() async throws {
        let url = Bundle.module.url(forResource: "fitfile1", withExtension: "fit", subdirectory: "Fixtures")!
        let fit = try PureFITFile(url: url)
        let airPowerField = try #require(fit.developerFields[.developer(0, 11)])
        #expect(airPowerField.name == "Air Power")
        let recordMessages = fit.messages.compactMap { $0 as? RecordMessage }
        let recordMessage = try #require(recordMessages.first)
        let airPower = try #require(recordMessage.developerFieldValue(for: airPowerField))
        #expect(airPower.fitValue == .uint16(5))
        #expect(airPower.stringValue == "5 Watts")
    }

    @Test func readActivityData() async throws {
        let url = Bundle.module.url(forResource: "cyclingActivityFromGarmin", withExtension: "fit", subdirectory: "Fixtures")!
        let fit = try PureFITFile(url: url)
        let activities = fit.messages.compactMap { $0 as? ActivityMessage }
        #expect(activities.count == 1)
        let activity = try #require(activities.first)
        #expect((activity.standardFieldValue(for: .numSessions) as? IntegerField.Value)?.value == 1)
        #expect(activity.value(at: .standard(2)) == .enum(0)) // oops, need to add this one. this is `type`
        #expect((activity.standardFieldValue(for: .totalTimerTime) as? DurationField.Value)?.measurement.converted(to: .seconds).value == 11380.964)
        if #available(iOS 15.0, *) {
            #expect((activity.standardFieldValue(for: .timestamp) as? DateField.Value)?.date.ISO8601Format() == "2020-07-12T13:47:52Z")
            #expect((activity.standardFieldValue(for: .localTimestamp) as? DateField.Value)?.date.ISO8601Format() == "2020-07-12T08:47:52Z")
        }
    }

    @Test func readHRVData() async throws {
        // NOTE: this test is important because it's one of the few cases where there are multiple values per field value
        let url = Bundle.module.url(forResource: "cyclingActivityFromGarmin", withExtension: "fit", subdirectory: "Fixtures")!
        let fit = try PureFITFile(url: url)
        let hrvMessages = fit.messages.compactMap { $0 as? HRVMessage }
        let hrvMessage = try #require(hrvMessages.first)
        #expect(hrvMessage.fields == [.standard(0): [.uint16(558), .uint16(557)]])
        let times = try #require((hrvMessage.standardFieldValue(for: .time) as? MultipleValueField<DurationField>.Value)?.values)
        #expect(times.map { $0.measurement.converted(to: .milliseconds).value } == [558, 557])
    }

    @Test func readSessionData() async throws {
        let url = Bundle.module.url(forResource: "cyclingActivityFromGarmin", withExtension: "fit", subdirectory: "Fixtures")!
        let fit = try PureFITFile(url: url)
        let sessions = fit.messages.compactMap { $0 as? SessionMessage }
        #expect(sessions.count == 1)
        let session = try #require(sessions.first)
        if #available(iOS 15.0, *) {
            #expect((session.standardFieldValue(for: .startTime) as? DateField.Value)?.date.ISO8601Format() == "2020-07-12T10:34:55Z")
        }
        let startLatitudeMeasurement = (session.standardFieldValue(for: .startPositionLatitude) as? AngleField.Value)?.measurement
        #expect(startLatitudeMeasurement?.unit == .garminSemicircle)
        #expect(startLatitudeMeasurement?.converted(to: .degrees).value == 41.94262119010091)
        #expect((session.standardFieldValue(for: .sport) as? EnumField<Sport>.Value)?.enumValue == .cycling)
        #expect((session.standardFieldValue(for: .subSport) as? EnumField<SubSport>.Value)?.enumValue == .road)
        #expect((session.standardFieldValue(for: .totalElapsedTime) as? DurationField.Value)?.measurement.converted(to: .milliseconds).value == 11503959)
        #expect((session.standardFieldValue(for: .totalTimerTime) as? DurationField.Value)?.measurement.converted(to: .milliseconds).value == 11380964)
        #expect((session.standardFieldValue(for: .totalDistance) as? DistanceField.Value)?.measurement.converted(to: .meters).value == 100346.79)
    }

    @Test func readLapData() async throws {
        let url = Bundle.module.url(forResource: "cyclingActivityFromGarmin", withExtension: "fit", subdirectory: "Fixtures")!
        let fit = try PureFITFile(url: url)
        let laps = fit.messages.compactMap { $0 as? LapMessage }
        #expect(laps.count == 13)
        let messageIndicesFromFitValue = laps.map { $0.value(at: .messageIndex) }
        #expect(messageIndicesFromFitValue == Array(0..<13).map { .uint16($0) })
        let messageIndicesFromStandardField = laps.map { ($0.standardFieldValue(for: .messageIndex) as? IndexField.Value)?.value }
        #expect(messageIndicesFromStandardField == Array(0..<13))
        let startTimes = laps.map { ($0.standardFieldValue(for: .startTime) as? DateField.Value)?.date.timeIntervalSince(Date(garminOffset: 0)) }
        #expect(startTimes == [
            963484495,
            963485415,
            963486367,
            963487323,
            963488223,
            963489196,
            963490189,
            963491127,
            963492158,
            963493050,
            963493891,
            963494772,
            963495579
        ])
        let averageTemperatures = laps.map { ($0.standardFieldValue(for: .averageTemperature) as? TemperatureField.Value)?.measurement.converted(to: .celsius).value }
        #expect(averageTemperatures == [22.0, 20.0, 20.0, 20.0, 21.0, 21.0, 20.0, 21.0, 22.0, 22.0, 22.0, 23.0, 24.0])
    }

    @Test func readTimeInZoneData() async throws {
        let url = Bundle.module.url(forResource: "cyclingActivityFromGarmin", withExtension: "fit", subdirectory: "Fixtures")!
        let fit = try PureFITFile(url: url)

        let timeInZoneMessages = fit.messages.compactMap { $0 as? TimeInZoneMessage }
        #expect(timeInZoneMessages.count == 14)
        let timeInZoneMessage = try #require(timeInZoneMessages.first)
        let timeInHRZoneFieldValues = (timeInZoneMessage.standardFieldValue(for: .timeInHRZone) as? MultipleValueField<DurationField>.Value)?.values
        let timeInHRZoneValues = timeInHRZoneFieldValues?.map { $0.measurement.converted(to: .milliseconds).value }
        #expect(timeInHRZoneValues == [4117, 26999, 344998, 473005, 68997, 0, 0])
        let timeInPowerZoneFieldValues = (timeInZoneMessage.standardFieldValue(for: .timeInPowerZone) as? MultipleValueField<DurationField>.Value)?.values
        let timeInPowerZoneValues = timeInPowerZoneFieldValues?.map { $0.measurement.converted(to: .milliseconds).value }
        #expect(timeInPowerZoneValues == [51003, 5996, 124004, 302113, 237997, 118007, 67991, 0, 0, 0])
    }

    @Test func readRecordData() async throws {
        let url = Bundle.module.url(forResource: "cyclingActivityFromGarmin", withExtension: "fit", subdirectory: "Fixtures")!
        let fit = try PureFITFile(url: url)
        let records = fit.messages.compactMap { $0 as? RecordMessage }
        #expect(records.count == 11389)
        let firstRecord = try #require(records.first)
        #expect(firstRecord.fields[.standard(90)] == nil) // first record doesn't have performance condition
        let record = try #require(records.last)
        #expect(record.fields.keys.sorted() == [
            .standard(0), // lat
            .standard(1), // lon
            .standard(2), // alt
            .standard(3), // HR
            .standard(4), // cadence
            .standard(5), // distance
            .standard(6), // speed
            .standard(7), // power
            .standard(13), //temp
            .standard(29), // accum power
            .standard(30), // LR balance
            .standard(43), // left torque effectiveness
            .standard(44), // right torque effectiveness
            .standard(45), // left pedal smoothness
            .standard(46), // right pedal smoothness
            .standard(53), // fractional cadence
            .standard(61), // ??
            .standard(66), // ??
            .standard(90), // performance condition
            .standard(108), // enhanced respiration rate
            .standard(253) // timestamp
        ])
        #expect((record.standardFieldValue(for: .performanceCondition) as? IntegerField.Value)?.value == 8)
        if #available(iOS 15.0, *) {
            #expect((record.standardFieldValue(for: .timestamp) as? DateField.Value)?.date.ISO8601Format() == "2020-07-12T13:46:41Z")
        }
    }

    @Test func readSessionDeveloperFieldData() async throws {
        let url = Bundle.module.url(forResource: "activity_developerdata", withExtension: "fit", subdirectory: "Fixtures")!
        let fit = try PureFITFile(url: url)
        let developerFields = fit.developerFields
        let doughnutsEarnedField = try #require(developerFields[.developer(0, 0)])
        #expect(doughnutsEarnedField.name == "Doughnuts Earned")
        #expect(doughnutsEarnedField.units == "doughnuts")
        let session = try #require(fit.messages.compactMap { $0 as? SessionMessage }.first)
        let doughnutsEarnedValue = try #require(session.developerFieldValue(for: doughnutsEarnedField))
        #expect(doughnutsEarnedValue.fitValue == .float32(3.0008333))
        #expect(doughnutsEarnedValue.format() == "3.00083327293396 doughnuts") // weird
    }

    @Test func parsingGarminFITFile() async throws {
        let url = Bundle.module.url(forResource: "cyclingActivityFromGarmin", withExtension: "fit", subdirectory: "Fixtures")!
        let raw = try RawFITFile(url: url)
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
        let url = Bundle.module.url(forResource: "activity_developerdata", withExtension: "fit", subdirectory: "Fixtures")!
        let raw = try RawFITFile(url: url)
        let fit = try PureFITFile(rawFITFile: raw)
        #expect(fit.messages.count == 3611)
    }

    @Test func parsingFITFile() async throws {
        let url = Bundle.module.url(forResource: "fitfile1", withExtension: "fit", subdirectory: "Fixtures")!
        let fit = try PureFITFile(url: url)

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
        #expect(secondRecordMessage.fields.keys.sorted() == [
            .standard(0),.standard(1),.standard(2),.standard(3),.standard(4),.standard(5),.standard(6),.standard(7),.standard(39),.standard(41),.standard(253),
            .developer(0, 5), .developer(0, 6), .developer(0, 8), .developer(0, 9), .developer(0, 11)
        ])
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
