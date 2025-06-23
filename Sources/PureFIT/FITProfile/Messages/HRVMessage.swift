//
//  HRVMessage.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

public struct HRVMessage: ProfiledMessage {
    public let globalMessageType: GlobalMessageType = .hrv
    public let fields: [FieldDefinitionNumber : [FITValue]]

    public enum Field: UInt8, CaseIterable, StandardMessageField, FieldDefinitionProviding {
        case time = 0

        public var fieldDefinition: any FieldDefinition {
            switch self {
            case .time:
                if #available(iOS 13.0, macOS 10.15, *) {
                    MultipleValueField(singleFieldDefinition: DurationField(name: "Time", baseType: .uint16, unit: .milliseconds, scale: 1, offset: 0))
                } else {
                    MultipleValueField(singleFieldDefinition: DurationField(name: "Time", baseType: .uint16, unit: .seconds, scale: 1000, offset: 0))
                }
            }
        }
    }
}
