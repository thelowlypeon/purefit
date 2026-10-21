//
//  SportMessageTests.swift
//  PureFIT
//

import Foundation
import Testing
@testable import PureFIT

struct SportMessageTests {
    @Test func readSportData() async throws {
        let fit = try Fixture.garminCycling.pureFITFile()
        let sportMessages = fit.messages.compactMap { $0 as? SportMessage }
        #expect(sportMessages.count == 1)
    }
}
