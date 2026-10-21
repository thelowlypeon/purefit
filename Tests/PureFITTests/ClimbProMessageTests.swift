//
//  ClimbProMessageTests.swift
//  PureFIT
//

import Foundation
import Testing
@testable import PureFIT

// No fixture has climb_pro messages, so these build the message from raw values.
struct ClimbProMessageTests {
    @Test func climbPro() throws {
        let climb = ClimbProMessage(fields: [
            .standard(ClimbProMessage.Field.climbProEvent.rawValue): [.enum(1)],
            .standard(ClimbProMessage.Field.climbNumber.rawValue): [.uint16(3)],
            .standard(ClimbProMessage.Field.currentDist.rawValue): [.float32(1234.5)],
        ])
        #expect((climb.standardFieldValue(for: .climbProEvent) as? EnumField<ClimbProEvent>.Value)?.enumValue == .start)
        #expect((climb.standardFieldValue(for: .climbNumber) as? IntegerField.Value)?.value == 3)
        #expect((climb.standardFieldValue(for: .currentDist) as? DistanceField.Value)?.measurement.converted(to: .meters).value == 1234.5)
    }
}
