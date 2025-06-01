//
//  TimeInZoneMessage.swift
//  PureFIT
//
//  Created by Peter Compernolle on 6/1/25.
//

struct TimeInZoneMessage: ProfiledMessage {
    let globalMessageType: GlobalMessageType = .timeInZone
    let fields: [FieldDefinitionNumber : [FITValue]]

    enum Field: UInt8, CaseIterable, StandardMessageField, FieldDefinitionProviding {
        case timeInHRZone = 2
        case timeInPowerZone = 5
        case timestamp = 253

        var fieldDefinition: any FieldDefinition {
            switch self {
            case .timeInHRZone: MultipleValueField(singleFieldDefinition: DurationField(name: "Time in HR Zone", baseType: .uint32, unit: .seconds, scale: 1000, offset: 0))
            case .timeInPowerZone: MultipleValueField(singleFieldDefinition: DurationField(name: "Time in Power Zone", baseType: .uint32, unit: .seconds, scale: 1000, offset: 0))
            case .timestamp: DateField(name: "Timestamp")
            }
        }
    }
}
