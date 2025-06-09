//
//  EnumField.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

import Foundation

public protocol FITEnum: RawRepresentable {
    init?(fitValue: FITValue)
    static func rawValue(from fitValue: FITValue) -> RawValue?
}
extension FITEnum {
    public init?(fitValue: FITValue) {
        guard let rawValue = Self.rawValue(from: fitValue) else { return nil }
        self.init(rawValue: rawValue)
    }
}

extension FITEnum where RawValue == UInt8 {
    public static func rawValue(from fitValue: FITValue) -> UInt8? {
        if case .uint8(let rawValue) = fitValue {
            return rawValue
        } else if case .enum(let rawValue) = fitValue {
            return rawValue
        }
        return nil
    }
}

extension FITEnum where RawValue == UInt16 {
    public static func rawValue(from fitValue: FITValue) -> UInt16? {
        print("rawValue: \(fitValue)")
        if case .uint16(let rawValue) = fitValue {
            return rawValue
        }
        return nil
    }
}

public struct EnumField<T>: NamedFieldDefinition where T: RawRepresentable, T: FITEnum, T: Sendable {
    public struct Value: FieldValue {
        public let rawValue: T.RawValue
        public let enumValue: T?

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
        guard let value = values.first, let rawValue = T.rawValue(from: value) else { return nil }
        let enumValue = T(rawValue: rawValue)
        return Value(rawValue: rawValue, enumValue: enumValue)
    }
}
