//
//  FieldDescriptionMessage.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

struct FieldDescriptionMessage: ProfiledMessage {
    let globalMessageType: GlobalMessageType = .fieldDescription
    let fields: [FieldDefinitionNumber : [FITValue]]

    public var developerDataIndex: Int? {
        return (standardFieldValue(for: .developerDataIndex) as? IndexField.Value)?.value
    }

    public var fieldDefinitionNumber: Int? {
        return (standardFieldValue(for: .fieldDefinitionNumber) as? IndexField.Value)?.value
    }

    public var fitBaseType: FITBaseType? {
        return (standardFieldValue(for: .fitBaseType) as? EnumField<FITBaseType>.Value)?.enumValue
    }

    public var fieldName: String? {
        return (standardFieldValue(for: .fieldName) as? StringField.Value)?.string
    }

    public var scale: Int? {
        return (standardFieldValue(for: .scale) as? IntegerField.Value)?.value
    }

    public var offset: Int? {
        return (standardFieldValue(for: .offset) as? IntegerField.Value)?.value
    }

    public var units: String? {
        return (standardFieldValue(for: .units) as? StringField.Value)?.string
    }

    public var nativeMessageNumber: Int? {
        return (standardFieldValue(for: .nativeMessageNumber) as? IndexField.Value)?.value
    }

    public var nativeFieldNumber: Int? {
        return (standardFieldValue(for: .nativeFieldNumber) as? IndexField.Value)?.value
    }

    enum Field: UInt8, CaseIterable, StandardMessageField, FieldDefinitionProviding {
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
            case .fieldName: StringField(name: "Field Name") // this is officially an array
            case .scale: IntegerField(name: "Scale", baseType: .uint8)
            case .offset: IntegerField(name: "Offset", baseType: .sint8)
            case .units: StringField(name: "Units") // this is officially an array
            case .nativeMessageNumber: IndexField(name: "Native Message Number", baseType: .uint16)
            case .nativeFieldNumber: IndexField(name: "Native Field Number", baseType: .uint8)
            }
        }
    }
}
