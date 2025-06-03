//
//  FileIDMessage.swift
//  PureFIT
//
//  Created by Peter Compernolle on 5/29/25.
//

public struct FileIDMessage: ProfiledMessage {
    public let globalMessageType: GlobalMessageType = .fileID
    public let fields: [FieldDefinitionNumber : [FITValue]]

    public enum Field: UInt8, CaseIterable, StandardMessageField, FieldDefinitionProviding {
        case timeCreated = 4

        public var fieldDefinition: any FieldDefinition {
            switch self {
            case .timeCreated: DateField(name: "Time Created")
            }
        }
    }
}
