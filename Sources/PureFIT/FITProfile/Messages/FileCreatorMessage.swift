//
//  FileCreatorMessage.swift
//  PureFIT
//
//  Created by Peter Compernolle on 6/8/25.
//

public struct FileCreatorMessage: ProfiledMessage {
    public let globalMessageType: GlobalMessageType = .fileCreator
    public let fields: [FieldDefinitionNumber : [FITValue]]

    public enum Field: UInt8, CaseIterable, StandardMessageField, FieldDefinitionProviding {
        case softwareVersion = 0
        case hardwareVersion = 1

        public var fieldDefinition: any FieldDefinition {
            switch self {
            case .softwareVersion: IntegerField(name: "Software Version", baseType: .uint16)
            case .hardwareVersion: IntegerField(name: "Hardward Version", baseType: .uint8)
            }
        }
    }
}
