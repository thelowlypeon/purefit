//
//  SessionMessageTests.swift
//  PureFIT
//

import Foundation
import Testing
@testable import PureFIT

struct SessionMessageTests {
    @Test func readSessionData() async throws {
        let fit = try Fixture.garminCycling.pureFITFile()
        let sessions = fit.messages.compactMap { $0 as? SessionMessage }
        #expect(sessions.count == 1)
        let session = try #require(sessions.first)
        #expect((session.standardFieldValue(for: .startTime) as? DateField.Value)?.date.timeIntervalSince(Date(garminOffset: 0)) == 963484495)
        let startLatitudeMeasurement = (session.standardFieldValue(for: .startPositionLatitude) as? AngleField.Value)?.measurement
        #expect(startLatitudeMeasurement?.unit == .garminSemicircle)
        #expect(startLatitudeMeasurement?.converted(to: .degrees).value == 41.94262119010091)
        #expect((session.standardFieldValue(for: .sport) as? EnumField<Sport>.Value)?.enumValue == .cycling)
        #expect((session.standardFieldValue(for: .subSport) as? EnumField<SubSport>.Value)?.enumValue == .road)
        #expect((session.standardFieldValue(for: .totalElapsedTime) as? DurationField.Value)?.duration == 11503.959)
        #expect((session.standardFieldValue(for: .totalTimerTime) as? DurationField.Value)?.duration == 11380.964)
        #expect((session.standardFieldValue(for: .totalDistance) as? DistanceField.Value)?.measurement.converted(to: .meters).value == 100346.79)
        #expect((session.standardFieldValue(for: .messageIndex) as? CompositeField<MessageIndex>.Value)?.compositeValue.values == [.index(0)])
    }

    @Test func sessionCadence() throws {
        let fit = try Fixture.garminCycling.pureFITFile()
        let session = try #require(fit.messages.compactMap { $0 as? SessionMessage }.first)
        let avgCadence = try #require(session.standardFieldValue(for: .avgCadence) as? IntegerField.Value)
        #expect(avgCadence.value == 88)
        #expect(avgCadence.unitSymbol == "rpm")
        let maxCadence = try #require(session.standardFieldValue(for: .maxCadence) as? IntegerField.Value)
        #expect(maxCadence.value == 142)
        #expect(maxCadence.unitSymbol == "rpm")
    }
}
