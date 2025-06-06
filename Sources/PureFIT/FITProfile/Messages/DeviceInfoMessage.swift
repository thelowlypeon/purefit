//
//  DeviceInfoMessage.swift
//  PureFIT
//
//  Created by Peter Compernolle on 5/29/25.
//

public struct DeviceInfoMessage: ProfiledMessage {
    public let globalMessageType: GlobalMessageType = .deviceInfo
    public let fields: [FieldDefinitionNumber : [FITValue]]

    public enum Field: UInt8, CaseIterable, StandardMessageField, FieldDefinitionProviding {
        case productName = 27
        case timestamp = 253

        public var fieldDefinition: any FieldDefinition {
            switch self {
            case .productName: StringField(name: "Product Name")
            case .timestamp: DateField(name: "Timestamp")
            }
        }
    }
}
