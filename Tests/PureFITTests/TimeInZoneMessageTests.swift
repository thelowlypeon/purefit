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
}
