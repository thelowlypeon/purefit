//
//  StringField.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

import Foundation

struct StringField: NamedFieldDefinition {
    struct Value: FieldValue {
        let string: String

        func format(locale: Locale = .current) -> String {
            return string
        }
    }
    let name: String
    var baseType: FITBaseType { .string }

    func parse(values: [FITValue]) -> Value? {
        if case .string(let str) = values.first {
            return Value(string: str)
        }
        return nil
    }
}
