//
//  SetMessage.swift
//  PureFIT
//

public struct SetMessage: ProfiledMessage {
    public let globalMessageType: GlobalMessageType = .set
    public let fields: [FieldDefinitionNumber : [FITValue]]

    public enum Field: UInt8, CaseIterable, StandardMessageField, FieldDefinitionProviding {
        case timestamp = 254
        case duration = 0
        case repetitions = 3
        case weight = 4
        case setType = 5
        case startTime = 6
        case category = 7
        case categorySubtype = 8
        case weightDisplayUnit = 9
        case messageIndex = 10
        case wktStepIndex = 11

        public var fieldDefinition: any FieldDefinition {
            switch self {
            case .timestamp: DateField(name: "Timestamp")
            case .duration: DurationField(name: "Duration", baseType: .uint32, unit: .seconds, scale: 1000, offset: 0)
            case .repetitions: IntegerField(name: "Repetitions", baseType: .uint16)
            case .weight: MassField(name: "Weight", baseType: .uint16, unit: .kilograms, scale: 16, offset: 0)
            case .setType: EnumField<SetType>(name: "Set Type", baseType: .uint8, enumType: .rest)
            case .startTime: DateField(name: "Start Time")
            case .category: MultipleValueField(singleFieldDefinition: EnumField<ExerciseCategory>(name: "Category", baseType: .uint16, enumType: .benchPress))
            case .categorySubtype: MultipleValueField(singleFieldDefinition: IntegerField(name: "Category Subtype", baseType: .uint16))
            case .weightDisplayUnit: EnumField<FITBaseUnit>(name: "Weight Display Unit", baseType: .uint16, enumType: .other)
            case .messageIndex: CompositeField<MessageIndex>(name: "Message Index", baseType: .uint16)
            case .wktStepIndex: CompositeField<MessageIndex>(name: "Workout Step Index", baseType: .uint16)
            }
        }
    }
}
