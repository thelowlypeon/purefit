//
//  SessionMessage.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

public struct SessionMessage: ProfiledMessage {
    public let globalMessageType: GlobalMessageType = .session
    public let fields: [FieldDefinitionNumber : [FITValue]]

    public enum Field: UInt8, CaseIterable, StandardMessageField, FieldDefinitionProviding {
        case startTime = 2
        case startPositionLatitude = 3
        case startPositionLongitude = 4
        case sport = 5
        case subSport = 6
        case totalElapsedTime = 7
        case totalTimerTime = 8
        case totalDistance = 9
        case firstLapIndex = 25
        case numLaps = 26
        case timestamp = 253
        case messageIndex = 254

        public var fieldDefinition: any FieldDefinition {
            switch self {
            case .startTime: DateField(name: "Start Time")
            case .startPositionLatitude: AngleField(name: "Starting Latitude", baseType: .sint32, scale: 1, offset: 0)
            case .startPositionLongitude: AngleField(name: "Starting Longitude", baseType: .sint32, scale: 1, offset: 0)
            case .sport: EnumField<Sport>(name: "Sport", baseType: .enum, enumType: .all)
            case .subSport: EnumField<SubSport>(name: "Sub-sport", baseType: .enum, enumType: .generic)
            case .totalElapsedTime: DurationField(name: "Total Elapsed Time", baseType: .uint32, unit: .seconds, scale: 1000, offset: 0)
            case .totalTimerTime: DurationField(name: "Total Timer Time", baseType: .uint32, unit: .seconds, scale: 1000, offset: 0)
            case .totalDistance: DistanceField(name: "Total Distance", baseType: .uint32, unit: .meters, scale: 100, offset: 0)
            case .firstLapIndex: IntegerField(name: "First Lap Index", baseType: .uint16)
            case .numLaps: IntegerField(name: "Num Laps", baseType: .uint16)
            case .timestamp: DateField(name: "Timestamp")
            case .messageIndex: CompositeField<MessageIndex>(name: "Message Index", baseType: .uint16)
            }
        }
    }
}
