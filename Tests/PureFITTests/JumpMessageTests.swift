//
//  JumpMessageTests.swift
//  PureFIT
//

import Foundation
import Testing
@testable import PureFIT

// No fixture has jump messages, so these build the message from raw values.
struct JumpMessageTests {
    @Test func jump() throws {
        let jump = JumpMessage(fields: [
            .standard(JumpMessage.Field.height.rawValue): [.float32(1.5)],
            .standard(JumpMessage.Field.hangTime.rawValue): [.float32(0.75)],
            .standard(JumpMessage.Field.rotations.rawValue): [.uint8(2)],
            .standard(JumpMessage.Field.enhancedSpeed.rawValue): [.uint32(12_500)],
        ])
        #expect((jump.standardFieldValue(for: .height) as? DistanceField.Value)?.measurement.converted(to: .meters).value == 1.5)
        #expect((jump.standardFieldValue(for: .hangTime) as? DurationField.Value)?.duration == 0.75)
        #expect((jump.standardFieldValue(for: .rotations) as? IntegerField.Value)?.value == 2)
        #expect((jump.standardFieldValue(for: .enhancedSpeed) as? SpeedField.Value)?.measurement.converted(to: .metersPerSecond).value == 12.5)
    }

    @Test func builtFromGlobalMessageNumber() throws {
        let number = GlobalMessageType.jump.rawValue
        let message = try FITMessageBuilder.buildMessage(
            definitionRecord: RawFITDefinitionRecord(architecture: .littleEndian, localMessageNumber: 0, globalMessageNumber: number, fieldCount: 0, fields: [], developerFields: []),
            dataRecord: RawFITDataRecord(localMessageNumber: 0, globalMessageNumber: number, fieldsData: [], developerFieldsData: []),
            developerFieldDefinitions: []
        )
        #expect(message is JumpMessage)
    }
}
