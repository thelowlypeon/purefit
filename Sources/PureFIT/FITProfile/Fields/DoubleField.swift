//
//  DoubleField.swift
//  PureFIT
//
//  Created by Peter Compernolle on 10/21/26.
//

import Foundation

public struct DoubleField: NamedFieldDefinition, DimensionalFieldDefinition {
    public struct Value: FieldValue {
        public let value: Double
        public let unitSymbol: String?

        public func format(locale: Locale) -> String {
            let formatter = NumberFormatter()
            formatter.locale = locale
            formatter.numberStyle = .decimal
            formatter.usesGroupingSeparator = false
            // Enough for every power-of-2 and power-of-10 scale in the profile, short enough to hide binary rounding noise.
            formatter.maximumFractionDigits = 10
            let number = formatter.string(from: NSNumber(value: value)) ?? "\(value)"
            let unitString = unitSymbol == nil ? "" : " \(unitSymbol!)"
            return "\(number)\(unitString)"
        }
    }

    public let name: String
    public let baseType: FITBaseType
    public let unitSymbol: String?
    public let scale: Double
    public let offset: Double

    public init(name: String, baseType: FITBaseType, unitSymbol: String? = nil, scale: Double, offset: Double = 0) {
        self.name = name
        self.baseType = baseType
        self.unitSymbol = unitSymbol
        self.scale = scale
        self.offset = offset
    }

    public func parse(values: [FITValue]) -> Value? {
        guard let value = values.first, let scaledValue = scaledValue(value) else { return nil }
        return Value(value: scaledValue, unitSymbol: unitSymbol)
    }
}
