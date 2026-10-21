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

    @Test func lapLeftRightBalance() throws {
        let fit = try Fixture.garminCycling.pureFITFile()
        let laps = fit.messages.compactMap { $0 as? LapMessage }
        let raw: [UInt16] = [37308, 37439, 37380, 37316, 37441, 37495, 37389, 37414, 37411, 37476, 37461, 37516, 37523]
        #expect(laps.map { $0.value(at: .leftRightBalance) } == raw.map { .uint16($0) })

        let balances = laps.map { ($0.standardFieldValue(for: .leftRightBalance) as? CompositeField<LeftRightBalance100>.Value)?.compositeValue.values }
        let contributions = [45.4, 46.71, 46.12, 45.48, 46.73, 47.27, 46.21, 46.46, 46.43, 47.08, 46.93, 47.48, 47.55]
        #expect(balances == contributions.map { [.contribution($0), .isRight(true)] })

        let first = try #require(laps.first?.standardFieldValue(for: .leftRightBalance))
        #expect(first.format(locale: Locale(identifier: "en_US")) == "Contribution: 45.4 %, Right: true")
    }

    @Test func lapLeftRightBalanceWithoutSide() throws {
        let lap = LapMessage(fields: [.standard(LapMessage.Field.leftRightBalance.rawValue): [.uint16(4540)]])
        let balance = try #require(lap.standardFieldValue(for: .leftRightBalance) as? CompositeField<LeftRightBalance100>.Value)
        #expect(balance.compositeValue.values == [.contribution(45.4)])
    }
}
