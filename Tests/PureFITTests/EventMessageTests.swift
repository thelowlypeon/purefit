//
//  EventMessageTests.swift
//  PureFIT
//

import Foundation
import Testing
@testable import PureFIT

struct EventMessageTests {
    @Test func readEventData() async throws {
        let fit = try Fixture.garminCycling.pureFITFile()
        let eventMessages = fit.messages.compactMap { $0 as? EventMessage }
        #expect(eventMessages.count == 53)
    }
}
