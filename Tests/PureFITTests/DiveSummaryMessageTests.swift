//
//  DiveSummaryMessageTests.swift
//  PureFIT
//

import Foundation
import Testing
@testable import PureFIT

// No fixture has dive_summary messages, so these build the message from raw values.
struct DiveSummaryMessageTests {
    @Test func diveSummary() throws {
        let summary = DiveSummaryMessage(fields: [
            .standard(DiveSummaryMessage.Field.referenceMesg.rawValue): [.uint16(18)],
            .standard(DiveSummaryMessage.Field.maxDepth.rawValue): [.uint32(32_400)],
            .standard(DiveSummaryMessage.Field.avgAscentRate.rawValue): [.sint32(-150)],
            .standard(DiveSummaryMessage.Field.avgRmv.rawValue): [.uint16(1825)],
        ])
        #expect((summary.standardFieldValue(for: .referenceMesg) as? EnumField<GlobalMessageType>.Value)?.enumValue == .session)
        #expect((summary.standardFieldValue(for: .maxDepth) as? DistanceField.Value)?.measurement.converted(to: .meters).value == 32.4)
        #expect((summary.standardFieldValue(for: .avgAscentRate) as? SpeedField.Value)?.measurement.converted(to: .metersPerSecond).value == -0.15)
        #expect(summary.standardFieldValue(for: .avgRmv)?.format(locale: Locale(identifier: "en_US")) == "18.25 L/min")
    }

    @Test func builtFromGlobalMessageNumber() throws {
        let number = GlobalMessageType.diveSummary.rawValue
        let message = try FITMessageBuilder.buildMessage(
            definitionRecord: RawFITDefinitionRecord(architecture: .littleEndian, localMessageNumber: 0, globalMessageNumber: number, fieldCount: 0, fields: [], developerFields: []),
            dataRecord: RawFITDataRecord(localMessageNumber: 0, globalMessageNumber: number, fieldsData: [], developerFieldsData: []),
            developerFieldDefinitions: []
        )
        #expect(message is DiveSummaryMessage)
    }
}
