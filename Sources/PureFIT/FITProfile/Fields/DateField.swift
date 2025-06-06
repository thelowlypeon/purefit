//
//  DateField.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

import Foundation

public struct DateField: NamedFieldDefinition {
    public struct Value: FieldValue {
        public let date: Date

        public func format(locale: Locale) -> String {
            let formatter = DateFormatter()
            formatter.locale = locale
            return formatter.string(from: date)
        }
    }

    public let name: String
    public let baseType: FITBaseType

    public init(name: String, baseType: FITBaseType = .uint32) {
        self.name = name
        self.baseType = baseType
    }

    public func parse(values: [FITValue]) -> Value? {
        guard let doubleValue = values.first?.doubleValue(from: baseType) else { return nil }
        return Value(date: Date(garminOffset: doubleValue))
    }
}
