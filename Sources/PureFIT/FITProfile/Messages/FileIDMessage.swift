//
//  FileIDMessage.swift
//  PureFIT
//
//  Created by Peter Compernolle on 5/29/25.
//

struct FileIDMessage: ProfiledMessage {
    let globalMessageType: GlobalMessageType = .fileID
    let fields: [FieldDefinitionNumber : [FITValue]]

    enum Field: UInt8, CaseIterable, StandardMessageField, FieldDefinitionProviding {
        case timeCreated = 4

        var fieldDefinition: any FieldDefinition {
            switch self {
            case .timeCreated: DateField(name: "Time Created")
            }
        }
    }
}
