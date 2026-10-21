//
//  RecordMessageTests.swift
//  PureFIT
//

import Foundation
import Testing
@testable import PureFIT

struct RecordMessageTests {
    @Test func readRecordData() async throws {
        let fit = try Fixture.garminCycling.pureFITFile()
        let records = fit.messages.compactMap { $0 as? RecordMessage }
        #expect(records.count == 11389)

        let lastRecord = try #require(records.last)
        // Inside #expect, a literal this long can't be type-checked in reasonable time on Swift 6.4.
        let expectedFields: [FieldDefinitionNumber] = [
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
        ]
        #expect(lastRecord.fields.keys.sorted() == expectedFields)
        #expect((lastRecord.standardFieldValue(for: .performanceCondition) as? IntegerField.Value)?.value == 8)
        if #available(iOS 15.0, *) {
            #expect((lastRecord.standardFieldValue(for: .timestamp) as? DateField.Value)?.date.ISO8601Format() == "2020-07-12T13:46:41Z")
        }

        let firstRecord = try #require(records.first)
        #expect(firstRecord.fields[.standard(90)] == nil) // first record doesn't have performance condition
        if #available(iOS 15.0, *) {
            #expect((firstRecord.standardFieldValue(for: .timestamp) as? DateField.Value)?.date.ISO8601Format() == "2020-07-12T10:34:55Z")
        }
        #expect((firstRecord.standardFieldValue(for: .latitude) as? AngleField.Value)?.measurement.converted(to: .degrees).value == 41.94262119010091)
        #expect((firstRecord.standardFieldValue(for: .longitude) as? AngleField.Value)?.measurement.converted(to: .degrees).value == -87.65265975147486)
        #expect((firstRecord.standardFieldValue(for: .altitude) as? DistanceField.Value)?.measurement.converted(to: .meters).value.rounded() == 188)
        #expect((firstRecord.standardFieldValue(for: .heartRate) as? IntegerField.Value)?.value == 109)
        #expect((firstRecord.standardFieldValue(for: .cadence) as? IntegerField.Value)?.value == 39)
        #expect((firstRecord.standardFieldValue(for: .distance) as? DistanceField.Value)?.measurement.converted(to: .meters).value == 4.49)
        #expect((firstRecord.standardFieldValue(for: .speed) as? SpeedField.Value)?.measurement.converted(to: .metersPerSecond).value == 4.264)
        #expect((firstRecord.standardFieldValue(for: .power) as? PowerField.Value)?.measurement.converted(to: .watts).value == 172)
        #expect((firstRecord.standardFieldValue(for: .temperature) as? TemperatureField.Value)?.measurement.converted(to: .celsius).value == 25)
        #expect((firstRecord.standardFieldValue(for: .accumulatedPower) as? PowerField.Value)?.measurement.converted(to: .watts).value == 172)
        #expect(firstRecord.value(at: .leftRightBalance) == .uint8(178))
        #expect((firstRecord.standardFieldValue(for: .leftRightBalance) as? CompositeField<LeftRightBalance>.Value)?.compositeValue.values == [.contribution(50), .isRight(true)])
        #expect((firstRecord.standardFieldValue(for: .leftTorqueEffectiveness) as? DoubleField.Value)?.value == 0)
        #expect((firstRecord.standardFieldValue(for: .rightTorqueEffectiveness) as? DoubleField.Value)?.value == 0)
        #expect((firstRecord.standardFieldValue(for: .leftPedalSmoothness) as? DoubleField.Value)?.value == 0)
        #expect((firstRecord.standardFieldValue(for: .rightPedalSmoothness) as? DoubleField.Value)?.value == 0)
        #expect((firstRecord.standardFieldValue(for: .fractionalCadence) as? DoubleField.Value)?.value == 0)
        #expect((firstRecord.standardFieldValue(for: .enhancedRespiratoryRate) as? DoubleField.Value)?.value == 36.58)
    }

    @Test func recordFractionalValues() throws {
        let fit = try Fixture.garminCycling.pureFITFile()
        let record = fit.messages.compactMap { $0 as? RecordMessage }[2]
        #expect(record.value(at: .leftTorqueEffectiveness) == .uint8(191))
        #expect((record.standardFieldValue(for: .leftTorqueEffectiveness) as? DoubleField.Value)?.value == 95.5)
    }

    @Test func recordLeftRightBalanceWithoutSide() throws {
        let record = RecordMessage(fields: [.standard(RecordMessage.Field.leftRightBalance.rawValue): [.uint8(50)]])
        let balance = try #require(record.standardFieldValue(for: .leftRightBalance) as? CompositeField<LeftRightBalance>.Value)
        #expect(balance.compositeValue.values == [.contribution(50)])
    }

    @Test func recordRunningDynamics() throws {
        let fit = try Fixture.strydRunning.pureFITFile()
        let record = try #require(fit.messages.compactMap { $0 as? RecordMessage }.first { $0.value(at: .stepLength) != nil })
        #expect(record.value(at: .stepLength) == .uint16(6657))
        let stepLength = try #require(record.standardFieldValue(for: .stepLength) as? DistanceField.Value)
        #expect(stepLength.measurement.converted(to: .millimeters).value == 665.7)
        #expect((record.standardFieldValue(for: .stanceTimeBalance) as? DoubleField.Value)?.value == 0)
    }

    @Test func recordStanceTimeBalance() throws {
        let record = RecordMessage(fields: [.standard(RecordMessage.Field.stanceTimeBalance.rawValue): [.uint16(4987)]])
        let balance = try #require(record.standardFieldValue(for: .stanceTimeBalance) as? DoubleField.Value)
        #expect(balance.value == 49.87)
        #expect(balance.unitSymbol == "%")
    }
}
