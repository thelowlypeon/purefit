//
//  HRVMessageTests.swift
//  PureFIT
//

import Foundation
import Testing
@testable import PureFIT

struct HRVMessageTests {
    @Test func readHRVData() async throws {
        // NOTE: this test is important because it's one of the few cases where there are multiple values per field value
        let fit = try Fixture.garminCycling.pureFITFile()
        let hrvMessages = fit.messages.compactMap { $0 as? HRVMessage }
        let hrvMessage = try #require(hrvMessages.first)
        #expect(hrvMessage.fields == [.standard(0): [.uint16(558), .uint16(557)]])
        let times = try #require((hrvMessage.standardFieldValue(for: .time) as? MultipleValueField<DurationField>.Value)?.values)
        #expect(times.map { $0.duration } == [0.558, 0.557])
        #expect(times.map { $0.format() } == ["558 ms", "557 ms"]) // on ios 13 it's "558 ms"
    }
}
