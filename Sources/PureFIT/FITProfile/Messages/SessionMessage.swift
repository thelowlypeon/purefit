//
//  SessionMessage.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

struct SessionMessage: ProfiledMessage {
    enum Field: UInt8, CaseIterable, StandardMessageField {
        case startTime = 2
        case startPositionLatitude = 3
        case startPositionLongitude = 4
        case sport = 5
        case subSport = 6
        case timestamp = 253
        case messageIndex = 254

        var fieldDefinition: any FieldDefinition {
            switch self {
            case .startTime: DateField(name: "Start Time")
            case .startPositionLatitude: AngleField(name: "Starting Longitude", baseType: .sint32, scale: 1, offset: 0)
            case .startPositionLongitude: AngleField(name: "Starting Longitude", baseType: .sint32, scale: 1, offset: 0)
            case .sport: EnumField(name: "Sport", baseType: .enum, enumType: Sport.all)
            case .subSport: EnumField(name: "Sub-sport", baseType: .enum, enumType: SubSport.generic)
            case .timestamp: DateField(name: "Timestamp")
            case .messageIndex: IntegerField(name: "Message Index", baseType: .uint16)
            }
        }
    }
}
