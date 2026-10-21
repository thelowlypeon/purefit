//
//  ClimbProMessage.swift
//  PureFIT
//

public struct ClimbProMessage: ProfiledMessage {
    public let globalMessageType: GlobalMessageType = .climbPro
    public let fields: [FieldDefinitionNumber : [FITValue]]

    public enum Field: UInt8, CaseIterable, StandardMessageField, FieldDefinitionProviding {
        case timestamp = 253
        case positionLat = 0
        case positionLong = 1
        case climbProEvent = 2
        case climbNumber = 3
        case climbCategory = 4
        case currentDist = 5

        public var fieldDefinition: any FieldDefinition {
            switch self {
            case .timestamp: DateField(name: "Timestamp")
            case .positionLat: AngleField(name: "Position Latitude", baseType: .sint32, scale: 1, offset: 0)
            case .positionLong: AngleField(name: "Position Longitude", baseType: .sint32, scale: 1, offset: 0)
            case .climbProEvent: EnumField<ClimbProEvent>(name: "Climb Pro Event", baseType: .enum, enumType: .approach)
            case .climbNumber: IntegerField(name: "Climb Number", baseType: .uint16)
            case .climbCategory: IntegerField(name: "Climb Category", baseType: .uint8)
            case .currentDist: DistanceField(name: "Current Distance", baseType: .float32, unit: .meters, scale: 1, offset: 0)
            }
        }
    }
}
