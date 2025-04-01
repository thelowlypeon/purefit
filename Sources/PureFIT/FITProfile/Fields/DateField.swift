//
//  DateField.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

import Foundation

struct DateField: FieldDefinition {
    struct Value: FieldValue {
        let date: Date

        func format() -> String {
            return date.description // TODO
        }
        func format(locale: Locale) -> String {
            let formatter = DateFormatter()
            formatter.locale = locale
            return formatter.string(from: date)
        }
    }

    let name: String
    let baseType: FITBaseType

    init(name: String, baseType: FITBaseType = .uint32) {
        self.name = name
        self.baseType = baseType
    }

    func parse(values: [FITValue]) -> Value? {
        guard let doubleValue = values.first?.doubleValue(from: baseType) else { return nil }
        return Value(date: Date(garminOffset: doubleValue))
    }
}
