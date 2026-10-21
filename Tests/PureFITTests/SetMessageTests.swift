//
//  SetMessageTests.swift
//  PureFIT
//

import Foundation
import Testing
@testable import PureFIT

// No fixture has set messages, so these build the message from raw values.
struct SetMessageTests {
    @Test func strengthSet() throws {
        let set = SetMessage(fields: [
            .standard(SetMessage.Field.timestamp.rawValue): [.uint32(1_000_000_000)],
            .standard(SetMessage.Field.setType.rawValue): [.uint8(1)],
            .standard(SetMessage.Field.repetitions.rawValue): [.uint16(10)],
            .standard(SetMessage.Field.weight.rawValue): [.uint16(1000)],
            .standard(SetMessage.Field.category.rawValue): [.uint16(28), .uint16(65534)],
            .standard(SetMessage.Field.weightDisplayUnit.rawValue): [.uint16(2)],
        ])
        #expect((set.standardFieldValue(for: .timestamp) as? DateField.Value)?.date == Date(garminOffset: 1_000_000_000))
        #expect((set.standardFieldValue(for: .setType) as? EnumField<SetType>.Value)?.enumValue == .active)
        #expect((set.standardFieldValue(for: .repetitions) as? IntegerField.Value)?.value == 10)
        #expect((set.standardFieldValue(for: .weight) as? MassField.Value)?.measurement.converted(to: .kilograms).value == 62.5)
        #expect((set.standardFieldValue(for: .category) as? MultipleValueField<EnumField<ExerciseCategory>>.Value)?.values.map(\.enumValue) == [.squat, .unknown])
        #expect((set.standardFieldValue(for: .weightDisplayUnit) as? EnumField<FITBaseUnit>.Value)?.enumValue == .pound)
    }

    @Test func builtFromGlobalMessageNumber() throws {
        let number = GlobalMessageType.set.rawValue
        let message = try FITMessageBuilder.buildMessage(
            definitionRecord: RawFITDefinitionRecord(architecture: .littleEndian, localMessageNumber: 0, globalMessageNumber: number, fieldCount: 0, fields: [], developerFields: []),
            dataRecord: RawFITDataRecord(localMessageNumber: 0, globalMessageNumber: number, fieldsData: [], developerFieldsData: []),
            developerFieldDefinitions: []
        )
        #expect(message is SetMessage)
    }
}
