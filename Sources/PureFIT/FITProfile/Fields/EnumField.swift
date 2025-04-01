//
//  EnumField.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

import Foundation

struct EnumField<T>: FieldDefinition where T: RawRepresentable, T.RawValue == UInt8, T: Sendable {
    struct Value: FieldValue {
        let rawValue: T.RawValue

        func format(locale: Locale = .current) -> String {
            if let enumVal = T(rawValue: rawValue) {
                return String(describing: enumVal)
            } else {
                return "\(rawValue)"
            }
        }
    }

    let name: String
    let baseType: FITBaseType
    let enumType: T

    func parse(values: [FITValue]) -> Value? {
        switch baseType {
        case .uint8:
            if case .uint8(let rawValue) = values.first {
                return Value(rawValue: rawValue)
            }
        case .enum:
            if case .enum(let rawValue) = values.first {
                return Value(rawValue: rawValue)
            }
        default:
            break
        }
        return nil

    }
}
