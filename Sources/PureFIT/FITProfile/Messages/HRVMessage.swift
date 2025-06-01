//
//  HRVMessage.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

struct HRVMessage: ProfiledMessage {
    let globalMessageType: GlobalMessageType = .hrv
    let fields: [FieldDefinitionNumber : [FITValue]]

    enum Field: UInt8, CaseIterable, StandardMessageField, FieldDefinitionProviding {
        case time = 0

        var fieldDefinition: any FieldDefinition {
            switch self {
            case .time: MultipleValueField(singleFieldDefinition: DurationField(name: "Time", baseType: .uint16, unit: .seconds, scale: 1000, offset: 0))
            }
        }
    }
}
