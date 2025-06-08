//
//  ActivityMessage.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

public struct ActivityMessage: ProfiledMessage {
    public let globalMessageType: GlobalMessageType = .activity
    public let fields: [FieldDefinitionNumber : [FITValue]]

    public enum Field: UInt8, CaseIterable, StandardMessageField, FieldDefinitionProviding {
        case totalTimerTime = 0
        case numSessions = 1
        case type = 2
        case event = 3
        case eventType = 4
        case localTimestamp = 5
        case eventGroup = 6
        case timestamp = 253

        public var fieldDefinition: any FieldDefinition {
            switch self {
            case .totalTimerTime:
                DurationField(name: "Total Timer Time", baseType: .uint32, unit: .seconds, scale: 1000, offset: 0)
            case .numSessions:
                IntegerField(name: "Number of Sessions", baseType: .uint16)
            case .type:
                EnumField<Activity>(name: "Type", baseType: .uint8, enumType: .manual)
            case .event:
                EnumField<Event>(name: "Event", baseType: .uint8, enumType: .timer)
            case .eventType:
                EnumField<EventType>(name: "Event Type", baseType: .uint8, enumType: .start)
            case .localTimestamp:
                DateField(name: "Local Timestamp")
            case .eventGroup:
                IntegerField(name: "Event Group", baseType: .uint8)
            case .timestamp:
                DateField(name: "Timestamp")
            }
        }
    }
}
