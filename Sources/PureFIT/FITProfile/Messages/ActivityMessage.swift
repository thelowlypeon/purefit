//
//  ActivityMessage.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

struct ActivityMessage: ProfiledMessage {
    enum Field: UInt8, CaseIterable, StandardMessageField {
        case totalTimerTime = 0
        case numSessions = 1
        case localTimestamp = 5
        case timestamp = 253

        var fieldDefinition: any FieldDefinition {
            switch self {
            case .totalTimerTime: DurationField(name: "Total Timer Time", baseType: .uint32, unit: .seconds, scale: 1000, offset: 0)
            case .numSessions: IntegerField(name: "Number of Sessions", baseType: .uint16)
            case .localTimestamp: DateField(name: "Local Timestamp")
            case .timestamp: DateField(name: "Timestamp")
            }
        }
    }

}
