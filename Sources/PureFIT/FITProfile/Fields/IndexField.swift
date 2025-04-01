//
//  IndexField.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

import Foundation

struct IndexField: FieldDefinition {
    struct Value: FieldValue {
        let value: Int

        func format(locale: Locale) -> String {
            return "\(value)"
        }
    }

    let name: String
    let baseType: FITBaseType

    func parse(values: [FITValue]) -> Value? {
        guard let integerValue = values.first?.integerValue(from: baseType) else { return nil }
        return Value(value: integerValue)
    }
}
