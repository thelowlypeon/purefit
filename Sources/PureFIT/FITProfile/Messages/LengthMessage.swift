//
//  LengthMessage.swift
//  PureFIT
//

public struct LengthMessage: ProfiledMessage {
    public let globalMessageType: GlobalMessageType = .length
    public let fields: [FieldDefinitionNumber : [FITValue]]

    public enum Field: UInt8, CaseIterable, StandardMessageField, FieldDefinitionProviding {
        case messageIndex = 254
        case timestamp = 253
        case event = 0
        case eventType = 1
        case startTime = 2
        case totalElapsedTime = 3
        case totalTimerTime = 4
        case totalStrokes = 5
        case avgSpeed = 6
        case swimStroke = 7
        case avgSwimmingCadence = 9
        case eventGroup = 10
        case totalCalories = 11
        case lengthType = 12
        case playerScore = 18
        case opponentScore = 19
        case strokeCount = 20
        case zoneCount = 21
        case enhancedAvgRespirationRate = 22
        case enhancedMaxRespirationRate = 23
        case avgRespirationRate = 24
        case maxRespirationRate = 25
        case metabolicCalories = 26

        public var fieldDefinition: any FieldDefinition {
            switch self {
            case .messageIndex: CompositeField<MessageIndex>(name: "Message Index", baseType: .uint16)
            case .timestamp: DateField(name: "Timestamp")
            case .event: EnumField<Event>(name: "Event", baseType: .enum, enumType: .activity)
            case .eventType: EnumField<EventType>(name: "Event Type", baseType: .enum, enumType: .start)
            case .startTime: DateField(name: "Start Time")
            case .totalElapsedTime: DurationField(name: "Total Elapsed Time", baseType: .uint32, unit: .seconds, scale: 1000, offset: 0)
            case .totalTimerTime: DurationField(name: "Total Timer Time", baseType: .uint32, unit: .seconds, scale: 1000, offset: 0)
            case .totalStrokes: IntegerField(name: "Total Strokes", baseType: .uint16, unitSymbol: "strokes")
            case .avgSpeed: SpeedField(name: "Average Speed", baseType: .uint16, unit: .metersPerSecond, scale: 1000, offset: 0)
            case .swimStroke: EnumField<SwimStroke>(name: "Swim Stroke", baseType: .enum, enumType: .freestyle)
            case .avgSwimmingCadence: IntegerField(name: "Average Swimming Cadence", baseType: .uint8, unitSymbol: "strokes/min")
            case .eventGroup: IntegerField(name: "Event Group", baseType: .uint8)
            case .totalCalories: EnergyField(name: "Total Calories", baseType: .uint16, unit: .kilocalories, scale: 1, offset: 0)
            case .lengthType: EnumField<LengthType>(name: "Length Type", baseType: .enum, enumType: .idle)
            case .playerScore: IntegerField(name: "Player Score", baseType: .uint16)
            case .opponentScore: IntegerField(name: "Opponent Score", baseType: .uint16)
            case .strokeCount: MultipleValueField(singleFieldDefinition: IntegerField(name: "Stroke Count", baseType: .uint16))
            case .zoneCount: MultipleValueField(singleFieldDefinition: IntegerField(name: "Zone Count", baseType: .uint16))
            case .enhancedAvgRespirationRate: DoubleField(name: "Enhanced Average Respiration Rate", baseType: .uint16, unitSymbol: "breaths/min", scale: 100)
            case .enhancedMaxRespirationRate: DoubleField(name: "Enhanced Max Respiration Rate", baseType: .uint16, unitSymbol: "breaths/min", scale: 100)
            case .avgRespirationRate: IntegerField(name: "Average Respiration Rate", baseType: .uint8, unitSymbol: "breaths/min")
            case .maxRespirationRate: IntegerField(name: "Max Respiration Rate", baseType: .uint8, unitSymbol: "breaths/min")
            case .metabolicCalories: EnergyField(name: "Metabolic Calories", baseType: .uint16, unit: .kilocalories, scale: 1, offset: 0)
            }
        }
    }
}
