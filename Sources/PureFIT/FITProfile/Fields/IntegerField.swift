//
//  IntegerField.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

import Foundation

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
    public let scale: Int

    public init(name: String, baseType: FITBaseType, unitSymbol: String? = nil, scale: Int = 1) {
        self.name = name
        self.baseType = baseType
        self.unitSymbol = unitSymbol
        self.scale = scale
    }

    public func parse(values: [FITValue]) -> Value? {
        guard let integerValue = values.first?.integerValue(from: baseType) else { return nil }
        return Value(value: integerValue / scale, unitSymbol: unitSymbol)
    }
}
