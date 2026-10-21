//
//  TimeInZoneMessageTests.swift
//  PureFIT
//

import Foundation
import Testing
@testable import PureFIT

struct TimeInZoneMessageTests {
    @Test func readTimeInZoneData() async throws {
        let fit = try Fixture.garminCycling.pureFITFile()

        let timeInZoneMessages = fit.messages.compactMap { $0 as? TimeInZoneMessage }
        #expect(timeInZoneMessages.count == 14)
        let timeInZoneMessage = try #require(timeInZoneMessages.first)
        let timeInHRZoneFieldValues = (timeInZoneMessage.standardFieldValue(for: .timeInHRZone) as? MultipleValueField<DurationField>.Value)?.values
        let timeInHRZoneValues = timeInHRZoneFieldValues?.map { $0.duration * 1000 }
        #expect(timeInHRZoneValues == [4117, 26999, 344998, 473005, 68997, 0, 0])
        let timeInPowerZoneFieldValues = (timeInZoneMessage.standardFieldValue(for: .timeInPowerZone) as? MultipleValueField<DurationField>.Value)?.values
        let timeInPowerZoneValues = timeInPowerZoneFieldValues?.map { $0.duration * 1000 }
        #expect(timeInPowerZoneValues == [51003, 5996, 124004, 302113, 237997, 118007, 67991, 0, 0, 0])
    }

    @Test func readZoneBoundaries() throws {
        let fit = try Fixture.garminCycling.pureFITFile()
        let message = try #require(fit.messages.compactMap { $0 as? TimeInZoneMessage }.first { $0.value(at: .hrZoneHighBoundary) != nil })
        let hrBoundaries = (message.standardFieldValue(for: .hrZoneHighBoundary) as? MultipleValueField<IntegerField>.Value)?.values.map(\.value)
        #expect(hrBoundaries == [110, 135, 150, 160, 169, 189])
        let powerBoundaries = (message.standardFieldValue(for: .powerZoneHighBoundary) as? MultipleValueField<PowerField>.Value)?.values.map { $0.measurement.converted(to: .watts).value }
        #expect(powerBoundaries == [49, 111, 154, 187, 216, 250, 315, 128, 281, 281])
        #expect((message.standardFieldValue(for: .hrCalcType) as? EnumField<HrZoneCalc>.Value)?.enumValue == .percentLactateThreshold)
        #expect((message.standardFieldValue(for: .pwrCalcType) as? EnumField<PwrZoneCalc>.Value)?.enumValue == .percentFtp)
    }

    @Test func speedZoneBoundariesAreScaled() throws {
        let message = TimeInZoneMessage(fields: [.standard(TimeInZoneMessage.Field.speedZoneHighBoundary.rawValue): [.uint16(2500), .uint16(5000)]])
        let boundaries = (message.standardFieldValue(for: .speedZoneHighBoundary) as? MultipleValueField<SpeedField>.Value)?.values.map { $0.measurement.converted(to: .metersPerSecond).value }
        #expect(boundaries == [2.5, 5])
    }
}
