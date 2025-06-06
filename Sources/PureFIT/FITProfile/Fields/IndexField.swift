//
//  IndexField.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

import Foundation

public struct IndexField: NamedFieldDefinition {
    public struct Value: FieldValue {
        public let value: Int

        public func format(locale: Locale) -> String {
            return "\(value)"
        }
    }

    public let name: String
    public let baseType: FITBaseType

    public func parse(values: [FITValue]) -> Value? {
        guard let integerValue = values.first?.integerValue(from: baseType) else { return nil }
        return Value(value: integerValue)
    }
}
