//
//  DeviceInfoMessage.swift
//  PureFIT
//
//  Created by Peter Compernolle on 5/29/25.
//

struct DeviceInfoMessage: ProfiledMessage {
    let globalMessageType: GlobalMessageType = .deviceInfo
    let fields: [FieldDefinitionNumber : [FITValue]]

    enum Field: UInt8, CaseIterable, StandardMessageField, FieldDefinitionProviding {
        case productName = 27
        case timestamp = 253

        var fieldDefinition: any FieldDefinition {
            switch self {
            case .productName: StringField(name: "Product Name")
            case .timestamp: DateField(name: "Timestamp", style: .time)
            }
        }
    }
}
