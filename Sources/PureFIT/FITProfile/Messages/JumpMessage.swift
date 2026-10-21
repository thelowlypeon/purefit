//
//  JumpMessage.swift
//  PureFIT
//

public struct JumpMessage: ProfiledMessage {
    public let globalMessageType: GlobalMessageType = .jump
    public let fields: [FieldDefinitionNumber : [FITValue]]

    public enum Field: UInt8, CaseIterable, StandardMessageField, FieldDefinitionProviding {
        case timestamp = 253
        case distance = 0
        case height = 1
        case rotations = 2
        case hangTime = 3
        case score = 4
        case positionLat = 5
        case positionLong = 6
        case speed = 7
        case enhancedSpeed = 8

        public var fieldDefinition: any FieldDefinition {
            switch self {
            case .timestamp: DateField(name: "Timestamp")
            case .distance: DistanceField(name: "Distance", baseType: .float32, unit: .meters, scale: 1, offset: 0)
            case .height: DistanceField(name: "Height", baseType: .float32, unit: .meters, scale: 1, offset: 0)
            case .rotations: IntegerField(name: "Rotations", baseType: .uint8)
            case .hangTime: DurationField(name: "Hang Time", baseType: .float32, unit: .seconds, scale: 1, offset: 0)
            case .score: DoubleField(name: "Score", baseType: .float32, scale: 1)
            case .positionLat: AngleField(name: "Position Latitude", baseType: .sint32, scale: 1, offset: 0)
            case .positionLong: AngleField(name: "Position Longitude", baseType: .sint32, scale: 1, offset: 0)
            case .speed: SpeedField(name: "Speed", baseType: .uint16, unit: .metersPerSecond, scale: 1000, offset: 0)
            case .enhancedSpeed: SpeedField(name: "Enhanced Speed", baseType: .uint32, unit: .metersPerSecond, scale: 1000, offset: 0)
            }
        }
    }
}
