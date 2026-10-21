//
//  SplitSummaryMessageTests.swift
//  PureFIT
//

import Foundation
import Testing
@testable import PureFIT

// No fixture has split_summary messages, so these build the message from raw values.
struct SplitSummaryMessageTests {
    @Test func splitSummary() throws {
        let summary = SplitSummaryMessage(fields: [
            .standard(SplitSummaryMessage.Field.splitType.rawValue): [.enum(3)],
            .standard(SplitSummaryMessage.Field.numSplits.rawValue): [.uint16(8)],
            .standard(SplitSummaryMessage.Field.avgSpeed.rawValue): [.uint32(3250)],
        ])
        #expect((summary.standardFieldValue(for: .splitType) as? EnumField<SplitType>.Value)?.enumValue == .intervalActive)
        #expect((summary.standardFieldValue(for: .numSplits) as? IntegerField.Value)?.value == 8)
        #expect((summary.standardFieldValue(for: .avgSpeed) as? SpeedField.Value)?.measurement.converted(to: .metersPerSecond).value == 3.25)
    }

    @Test func builtFromGlobalMessageNumber() throws {
        let number = GlobalMessageType.splitSummary.rawValue
        let message = try FITMessageBuilder.buildMessage(
            definitionRecord: RawFITDefinitionRecord(architecture: .littleEndian, localMessageNumber: 0, globalMessageNumber: number, fieldCount: 0, fields: [], developerFields: []),
            dataRecord: RawFITDataRecord(localMessageNumber: 0, globalMessageNumber: number, fieldsData: [], developerFieldsData: []),
            developerFieldDefinitions: []
        )
        #expect(message is SplitSummaryMessage)
    }
}
