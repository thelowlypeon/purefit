//
//  FieldDescriptionMessage.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

struct FieldDescriptionMessage: ProfiledMessage {
    enum Field: UInt8, CaseIterable, StandardMessageField {
        case developerDataIndex = 0
        case fieldDefinitionNumber = 1
        case fitBaseType = 2
        case fieldName = 3
        case scale = 6
        case offset = 7
        case units = 8
        case nativeMessageNumber = 14
        case nativeFieldNumber = 15

        var fieldDefinition: any FieldDefinition {
            switch self {
            case .developerDataIndex: IndexField(name: "Developer Data Index", baseType: .uint8)
            case .fieldDefinitionNumber: IndexField(name: "Field Definition Number", baseType: .uint8)
            case .fitBaseType: EnumField(name: "FIT Base Type", baseType: .uint8, enumType: FITBaseType.uint8)
            case .fieldName: StringField(name: "Field Name")
            case .scale: IntegerField(name: "Scale", baseType: .uint8)
            case .offset: IntegerField(name: "Offset", baseType: .sint8)
            case .units: StringField(name: "Units")
            case .nativeMessageNumber: IndexField(name: "Native Message Number", baseType: .uint16)
            case .nativeFieldNumber: IndexField(name: "Native Field Number", baseType: .uint8)
            }
        }
    }
}
