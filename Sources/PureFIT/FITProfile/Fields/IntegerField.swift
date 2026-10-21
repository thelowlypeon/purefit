//
//  IntegerField.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

import Foundation

/// An unscaled integer. Fields with a profile scale other than 1 are `DoubleField`s.
public struct IntegerField: NamedFieldDefinition {
    public struct Value: FieldValue {
        public let value: Int
        public let unitSymbol: String?

        public func format(locale: Locale) -> String {
            let unitString = unitSymbol == nil ? "" : " \(unitSymbol!)"
            return "\(value)\(unitString)"
        }
    }

    public let name: String
    public let baseType: FITBaseType
    public let unitSymbol: String?

    public init(name: String, baseType: FITBaseType, unitSymbol: String? = nil) {
        self.name = name
        self.baseType = baseType
        self.unitSymbol = unitSymbol
    }

    public func parse(values: [FITValue]) -> Value? {
        guard let integerValue = values.first?.integerValue else { return nil }
        return Value(value: integerValue, unitSymbol: unitSymbol)
    }
}
