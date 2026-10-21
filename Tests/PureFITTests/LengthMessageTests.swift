//
//  LengthMessageTests.swift
//  PureFIT
//

import Foundation
import Testing
@testable import PureFIT

// No fixture has length messages, so these build the message from raw values.
struct LengthMessageTests {
    @Test func poolLength() throws {
        let length = LengthMessage(fields: [
            .standard(LengthMessage.Field.totalTimerTime.rawValue): [.uint32(31250)],
            .standard(LengthMessage.Field.totalStrokes.rawValue): [.uint16(18)],
            .standard(LengthMessage.Field.swimStroke.rawValue): [.enum(2)],
            .standard(LengthMessage.Field.lengthType.rawValue): [.enum(1)],
            .standard(LengthMessage.Field.strokeCount.rawValue): [.uint16(3), .uint16(15)],
        ])
        #expect((length.standardFieldValue(for: .totalTimerTime) as? DurationField.Value)?.duration == 31.25)
        #expect(length.standardFieldValue(for: .totalStrokes)?.format() == "18 strokes")
        #expect((length.standardFieldValue(for: .swimStroke) as? EnumField<SwimStroke>.Value)?.enumValue == .breaststroke)
        #expect((length.standardFieldValue(for: .lengthType) as? EnumField<LengthType>.Value)?.enumValue == .active)
        #expect((length.standardFieldValue(for: .strokeCount) as? MultipleValueField<IntegerField>.Value)?.values.map(\.value) == [3, 15])
    }

    @Test func builtFromGlobalMessageNumber() throws {
        let number = GlobalMessageType.length.rawValue
        let message = try FITMessageBuilder.buildMessage(
            definitionRecord: RawFITDefinitionRecord(architecture: .littleEndian, localMessageNumber: 0, globalMessageNumber: number, fieldCount: 0, fields: [], developerFields: []),
            dataRecord: RawFITDataRecord(localMessageNumber: 0, globalMessageNumber: number, fieldsData: [], developerFieldsData: []),
            developerFieldDefinitions: []
        )
        #expect(message is LengthMessage)
    }
}
