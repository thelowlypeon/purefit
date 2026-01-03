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
        case type = 0
        case manufacturer = 1
        case product = 2
        case serialNumber = 3
        case timeCreated = 4
        case productName = 8

        public var fieldDefinition: any FieldDefinition {
            switch self {
            case .type: return EnumField<File>(name: "Type", baseType: .enum, enumType: .activity)
            case .product: return EnumField<GarminProduct>(name: "Product", baseType: .enum, enumType: .hrm1)
            case .manufacturer: return EnumField<Manufacturer>(name: "Manufacturer", baseType: .uint16, enumType: .garmin)
            case .serialNumber: return IntegerField(name: "Serial Number", baseType: .uint32z)
            case .timeCreated: return DateField(name: "Time Created")
            case .productName: return StringField(name: "Product Name")
            }
        }
    }
}
