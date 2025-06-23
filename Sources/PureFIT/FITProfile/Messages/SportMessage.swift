//
//  SportMessage.swift
//  PureFIT
//
//  Created by Peter Compernolle on 6/21/25.
//

public struct SportMessage: ProfiledMessage {
    public let globalMessageType: GlobalMessageType = .sport
    public let fields: [FieldDefinitionNumber : [FITValue]]

    public enum Field: UInt8, CaseIterable, StandardMessageField, FieldDefinitionProviding {
        case sport = 0
        case subSport = 1
        case name = 3

        public var fieldDefinition: any FieldDefinition {
            switch self {
            case .sport: EnumField<Sport>(name: "Sport", baseType: .enum, enumType: .all)
            case .subSport: EnumField<SubSport>(name: "Sub-sport", baseType: .enum, enumType: .generic)
            case .name: StringField(name: "Name")
            }
        }
    }
}
