//
//  IntegerField.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

import Foundation

struct IntegerField: FieldDefinition {
    struct Value: FieldValue {
        let value: Int
        let unitSymbol: String?

        func format(locale: Locale) -> String {
            let unitString = unitSymbol == nil ? "" : " \(unitSymbol!)"
            return "\(value)\(unitString)"
        }
    }

    let name: String
    let baseType: FITBaseType
    let unitSymbol: String?
    let scale: Int

    init(name: String, baseType: FITBaseType, unitSymbol: String? = nil, scale: Int = 1) {
        self.name = name
        self.baseType = baseType
        self.unitSymbol = unitSymbol
        self.scale = scale
    }

    func parse(values: [FITValue]) -> Value? {
        guard let integerValue = values.first?.integerValue(from: baseType) else { return nil }
        return Value(value: integerValue / scale, unitSymbol: unitSymbol)
    }
}
