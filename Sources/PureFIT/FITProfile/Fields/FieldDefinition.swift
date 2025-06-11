//
//  FieldDefinition.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

import Foundation

public protocol FieldDefinition: Sendable {
    associatedtype Value: FieldValue
    func parse(values: [FITValue]) -> Value?
}

public protocol NamedFieldDefinition: FieldDefinition {
    var baseType: FITBaseType { get }
    var name: String { get }
}

public struct UndefinedField: FieldDefinition {
    public struct Value: FieldValue {
        let fitValue: FITValue
        public func format(locale: Locale) -> String {
            return fitValue.description // debugDescription will show eg uint16(12), but description shows eg 12
        }
    }

    public let globalMessageNumber: FITGlobalMessageNumber
    public let fieldDefinitionNumber: FieldDefinitionNumber

    public func parse(values: [FITValue]) -> Value? {
        guard let value = values.first else { return nil }
        return Value(fitValue: value)
    }
}
