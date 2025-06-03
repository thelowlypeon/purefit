//
//  ProfiledMessage.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

public protocol FieldDefinitionProviding: RawRepresentable where RawValue == UInt8 {
    var fieldDefinition: any FieldDefinition { get }
}

public protocol ProfiledMessage: FITMessage {
    var globalMessageType: GlobalMessageType { get }
    associatedtype Field: FieldDefinitionProviding
}

extension ProfiledMessage {
    public var globalMessageNumber: FITGlobalMessageNumber { globalMessageType.rawValue }

    public func standardFieldValue(for field: Field) -> FieldValue? {
        guard let rawValues = values(at: field)
        else { return nil }
        let fieldDefinition = fieldDefinition(for: .standard(field.rawValue), developerFieldDefinitions: [:])
        return fieldDefinition.parse(values: rawValues)
    }

    // TODO: make this fitValue(at field: Field)
    func value(at field: Field) -> FITValue? {
        return value(at: field.rawValue)
    }

    func values(at field: Field) -> [FITValue]? {
        return values(at: field.rawValue)
    }
}

extension ProfiledMessage {
    public func fieldDefinition(for fieldDefinitionNumber: FieldDefinitionNumber, developerFieldDefinitions: [FieldDefinitionNumber: DeveloperField]) -> any FieldDefinition {
        switch fieldDefinitionNumber {
        case .standard(let number):
            return Field(rawValue: number)?.fieldDefinition ?? UndefinedField(globalMessageNumber: globalMessageNumber, fieldDefinitionNumber: fieldDefinitionNumber)
        case .developer(_, _):
            return developerFieldDefinitions[fieldDefinitionNumber] ?? UndefinedField(globalMessageNumber: globalMessageNumber, fieldDefinitionNumber: fieldDefinitionNumber)
        }
    }
}
