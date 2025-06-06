//
//  EnumField.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

import Foundation

public struct EnumField<T>: NamedFieldDefinition where T: RawRepresentable, T.RawValue == UInt8, T: Sendable {
    public struct Value: FieldValue {
        public let rawValue: T.RawValue
        public var enumValue: T? {
            T(rawValue: rawValue)
        }

        public func format(locale: Locale = .current) -> String {
            if let enumVal = T(rawValue: rawValue) {
                return String(describing: enumVal)
            } else {
                return "\(rawValue)"
            }
        }
    }

    public let name: String
    public let baseType: FITBaseType
    public let enumType: T

    public func parse(values: [FITValue]) -> Value? {
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
