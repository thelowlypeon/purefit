//
//  SplitMessageTests.swift
//  PureFIT
//

import Foundation
import Testing
@testable import PureFIT

// No fixture has split messages, so these build the message from raw values.
struct SplitMessageTests {
    @Test func split() throws {
        let split = SplitMessage(fields: [
            .standard(SplitMessage.Field.splitType.rawValue): [.enum(12)],
            .standard(SplitMessage.Field.totalDistance.rawValue): [.uint32(100_050)],
            .standard(SplitMessage.Field.avgCadence.rawValue): [.uint16(11_584)],
            .standard(SplitMessage.Field.startElevation.rawValue): [.uint32(3000)],
            .standard(SplitMessage.Field.climbSend.rawValue): [.enum(1)],
            .standard(SplitMessage.Field.status.rawValue): [.enum(3)],
            .standard(SplitMessage.Field.climbGradingScale.rawValue): [.enum(2)],
            .standard(SplitMessage.Field.diveSectionType.rawValue): [.enum(2)],
            .standard(SplitMessage.Field.apneaDiscipline.rawValue): [.enum(9)],
        ])
        #expect((split.standardFieldValue(for: .splitType) as? EnumField<SplitType>.Value)?.enumValue == .runActive)
        #expect((split.standardFieldValue(for: .totalDistance) as? DistanceField.Value)?.measurement.converted(to: .meters).value == 1000.5)
        #expect((split.standardFieldValue(for: .avgCadence) as? DoubleField.Value)?.value == 90.5)
        #expect((split.standardFieldValue(for: .startElevation) as? DistanceField.Value)?.measurement.converted(to: .meters).value == 100)
        #expect(split.standardFieldValue(for: .climbSend)?.format() == "true")
        #expect((split.standardFieldValue(for: .status) as? EnumField<SplitStatus>.Value)?.enumValue == .climbCompleted)
        #expect((split.standardFieldValue(for: .climbGradingScale) as? EnumField<ClimbGradingScale>.Value)?.enumValue == .french)
        #expect((split.standardFieldValue(for: .diveSectionType) as? EnumField<DiveSectionType>.Value)?.enumValue == .hang)
        #expect((split.standardFieldValue(for: .apneaDiscipline) as? EnumField<ApneaDiscipline>.Value)?.enumValue == .staticApnea)
    }
}
