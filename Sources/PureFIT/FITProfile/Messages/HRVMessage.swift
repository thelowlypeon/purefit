//
//  HRVMessage.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

struct HRVMessage: ProfiledMessage {
    enum Field: UInt8, CaseIterable, StandardMessageField {
        case time

        var fieldDefinition: any FieldDefinition {
            switch self {
            case .time: DurationField(name: "Time", baseType: .uint16, unit: .seconds, scale: 1000, offset: 0)
            }
        }
    }
}
