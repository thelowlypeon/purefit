//
//  EventMessage.swift
//  PureFIT
//
//  Created by Peter Compernolle on 5/29/25.
//

struct EventMessage: ProfiledMessage {
    let globalMessageType: GlobalMessageType = .event
    let fields: [FieldDefinitionNumber : [FITValue]]

    enum Field: UInt8, CaseIterable, StandardMessageField, FieldDefinitionProviding {
        case event = 0
        case eventType = 1
        case timestamp = 253

        var fieldDefinition: any FieldDefinition {
            switch self {
            case .event: IntegerField(name: "Event", baseType: .enum) // TODO: Enum field
            case .eventType: IntegerField(name: "Event Type", baseType: .enum) // TODO: Enum field
            case .timestamp: DateField(name: "Timestamp", style: .time)
            }
        }
    }
}
