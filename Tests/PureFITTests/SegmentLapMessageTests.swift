//
//  SegmentLapMessageTests.swift
//  PureFIT
//

import Foundation
import Testing
@testable import PureFIT

// No fixture has segment_lap messages, so these build the message from raw values.
struct SegmentLapMessageTests {
    @Test func segmentLap() throws {
        let lap = SegmentLapMessage(fields: [
            .standard(SegmentLapMessage.Field.name.rawValue): [.string("Hill repeat")],
            .standard(SegmentLapMessage.Field.status.rawValue): [.enum(1)],
            .standard(SegmentLapMessage.Field.sportEvent.rawValue): [.enum(4)],
            .standard(SegmentLapMessage.Field.avgAltitude.rawValue): [.uint16(7500)],
            .standard(SegmentLapMessage.Field.enhancedAvgAltitude.rawValue): [.uint32(7500)],
            .standard(SegmentLapMessage.Field.leftRightBalance.rawValue): [.uint16(4540)],
        ])
        #expect(lap.standardFieldValue(for: .name)?.format() == "Hill repeat")
        #expect((lap.standardFieldValue(for: .status) as? EnumField<SegmentLapStatus>.Value)?.enumValue == .fail)
        #expect((lap.standardFieldValue(for: .sportEvent) as? EnumField<SportEvent>.Value)?.enumValue == .race)
        #expect((lap.standardFieldValue(for: .avgAltitude) as? DistanceField.Value)?.measurement.converted(to: .meters).value == 1000)
        #expect((lap.standardFieldValue(for: .enhancedAvgAltitude) as? DistanceField.Value)?.measurement.converted(to: .meters).value == 1000)
        #expect((lap.standardFieldValue(for: .leftRightBalance) as? CompositeField<LeftRightBalance100>.Value)?.compositeValue.values == [.contribution(45.4)])
    }

    @Test func builtFromGlobalMessageNumber() throws {
        let number = GlobalMessageType.segmentLap.rawValue
        let message = try FITMessageBuilder.buildMessage(
            definitionRecord: RawFITDefinitionRecord(architecture: .littleEndian, localMessageNumber: 0, globalMessageNumber: number, fieldCount: 0, fields: [], developerFields: []),
            dataRecord: RawFITDataRecord(localMessageNumber: 0, globalMessageNumber: number, fieldsData: [], developerFieldsData: []),
            developerFieldDefinitions: []
        )
        #expect(message is SegmentLapMessage)
    }
}
