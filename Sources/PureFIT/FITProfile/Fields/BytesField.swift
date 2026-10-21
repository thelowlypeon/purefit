//
//  BytesField.swift
//  PureFIT
//

import Foundation

public struct BytesField: NamedFieldDefinition {
    public struct Value: FieldValue {
        public let bytes: [UInt8]

        public func format(locale: Locale) -> String {
            return bytes.map { String(format: "%02X", $0) }.joined()
        }
    }

    public let name: String
    public var baseType: FITBaseType { .bytes }

    public func parse(values: [FITValue]) -> Value? {
        guard case .bytes(let bytes) = values.first else { return nil }
        return Value(bytes: bytes)
    }
}
