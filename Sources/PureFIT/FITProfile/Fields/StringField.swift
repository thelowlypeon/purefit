//
//  StringField.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

import Foundation

public struct StringField: NamedFieldDefinition {
    public struct Value: FieldValue {
        public let string: String

        public func format(locale: Locale = .current) -> String {
            return string
        }
    }
    public let name: String
    public var baseType: FITBaseType { .string }

    public func parse(values: [FITValue]) -> Value? {
        if case .string(let str) = values.first {
            return Value(string: str)
        }
        return nil
    }
}
