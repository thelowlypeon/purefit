//
//  Field.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

protocol StandardMessageField: CaseIterable, RawRepresentable {
    var fieldDefinition: any FieldDefinition { get }
    var fieldDefinitionNumber: FieldDefinitionNumber { get }
}

extension StandardMessageField {
    static var standardFields: [FieldDefinitionNumber: any FieldDefinition] {
        return Dictionary(uniqueKeysWithValues: Self.allCases.map { ($0.fieldDefinitionNumber, $0.fieldDefinition )})
    }
}

extension StandardMessageField where Self.RawValue == UInt8 {
    var fieldDefinitionNumber: FieldDefinitionNumber {
        return .standard(rawValue)
    }
}
