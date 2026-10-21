//
//  LapMessageTests.swift
//  PureFIT
//

import Foundation
import Testing
@testable import PureFIT

struct LapMessageTests {
    @Test func readLapData() async throws {
        let fit = try Fixture.garminCycling.pureFITFile()
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
        let averageTemperatures = laps.map { ($0.standardFieldValue(for: .avgTemperature) as? TemperatureField.Value)?.measurement.converted(to: .celsius).value }
        #expect(averageTemperatures == [22.0, 20.0, 20.0, 20.0, 21.0, 21.0, 20.0, 21.0, 22.0, 22.0, 22.0, 23.0, 24.0])
    }

    @Test func lapCadence() throws {
        let fit = try Fixture.garminCycling.pureFITFile()
        let lap = try #require(fit.messages.compactMap { $0 as? LapMessage }.first)
        let avgCadence = try #require(lap.standardFieldValue(for: .avgCadence) as? IntegerField.Value)
        #expect(avgCadence.value == 91)
        #expect(avgCadence.unitSymbol == "rpm")
        let maxCadence = try #require(lap.standardFieldValue(for: .maxCadence) as? IntegerField.Value)
        #expect(maxCadence.value == 103)
        #expect(maxCadence.unitSymbol == "rpm")
    }
}
