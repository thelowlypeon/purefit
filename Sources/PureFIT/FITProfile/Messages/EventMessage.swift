//
//  EventMessage.swift
//  PureFIT
//
//  Created by Peter Compernolle on 5/29/25.
//

public struct EventMessage: ProfiledMessage {
    public let globalMessageType: GlobalMessageType = .event
    public let fields: [FieldDefinitionNumber : [FITValue]]

    public enum Field: UInt8, CaseIterable, StandardMessageField, FieldDefinitionProviding {
        case event = 0
        case eventType = 1
        // case data = 3 // this is a UInt32 with lots of possible value types
        case eventGroup = 4
        case timestamp = 253

        public var fieldDefinition: any FieldDefinition {
            switch self {
            case .event: EnumField<Event>(name: "Event", baseType: .enum, enumType: .activity)
            case .eventType: EnumField<EventType>(name: "Event Type", baseType: .enum, enumType: .start)
            case .eventGroup: IntegerField(name: "Event Type", baseType: .uint8)
            case .timestamp: DateField(name: "Timestamp")
            }
        }
    }
}
