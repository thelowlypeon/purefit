//
//  ActivityMessageTests.swift
//  PureFIT
//

import Foundation
import Testing
@testable import PureFIT

struct ActivityMessageTests {
    @Test func readActivityData() async throws {
        let fit = try Fixture.garminCycling.pureFITFile()
        let activities = fit.messages.compactMap { $0 as? ActivityMessage }
        #expect(activities.count == 1)
        let activity = try #require(activities.first)
        #expect((activity.standardFieldValue(for: .numSessions) as? IntegerField.Value)?.value == 1)
        #expect(activity.value(at: .standard(2)) == .enum(0)) // oops, need to add this one. this is `type`
        #expect((activity.standardFieldValue(for: .totalTimerTime) as? DurationField.Value)?.duration == 11380.964)
        if #available(iOS 15.0, *) {
            #expect((activity.standardFieldValue(for: .timestamp) as? DateField.Value)?.date.ISO8601Format() == "2020-07-12T13:47:52Z")
            #expect((activity.standardFieldValue(for: .localTimestamp) as? DateField.Value)?.date.ISO8601Format() == "2020-07-12T08:47:52Z")
        }
    }
}
