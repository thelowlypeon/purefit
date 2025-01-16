//
//  FITValue.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/15/25.
//

public enum FITValue: Sendable {
    case `enum`(UInt8)       // Enum type, associated value: UInt8
    case sint8(Int8)         // Signed 8-bit integer, associated value: Int8
    case uint8(UInt8)        // Unsigned 8-bit integer, associated value: UInt8
    case sint16(Int16)       // Signed 16-bit integer, associated value: Int16
    case uint16(UInt16)      // Unsigned 16-bit integer, associated value: UInt16
    case sint32(Int32)       // Signed 32-bit integer, associated value: Int32
    case uint32(UInt32)      // Unsigned 32-bit integer, associated value: UInt32
    case string(String)      // String type, associated value: String
    case float32(Float)      // 32-bit floating point, associated value: Float
    case float64(Double)     // 64-bit floating point, associated value: Double
    case uint8z(UInt8)       // Unsigned 8-bit integer with zero invalid, associated value: UInt8
    case uint16z(UInt16)     // Unsigned 16-bit integer with zero invalid, associated value: UInt16
    case uint32z(UInt32)     // Unsigned 32-bit integer with zero invalid, associated value: UInt32
    case bytes([UInt8])      // Byte array, associated value: Array of UInt8
    case sint64(Int64)       // Signed 64-bit integer, associated value: Int64
    case uint64(UInt64)      // Unsigned 64-bit integer, associated value: UInt64
    case uint64z(UInt64)     // Unsigned 64-bit integer with zero invalid, associated value: UInt64
}

extension FITValue: Equatable {}

extension FITValue {
    static func from(
        bytes: [UInt8],
        baseType: FITBaseType,
        architecture: FITArchitecture
    ) -> FITValue? {
        // Ensure there are enough bytes for the specified type
        guard bytes.count >= (baseType.size ?? 1) else { return nil }

        // Extract the relevant slice of bytes
        let slice = bytes[0..<(baseType.size ?? 1)]

        // Endianness conversion helper
        func convertEndian<T: FixedWidthInteger>(_ value: T) -> T {
            switch architecture {
            case .littleEndian:
                return T(littleEndian: value)
            case .bigEndian:
                return T(bigEndian: value)
            }
        }

        // Parse and immediately check for "invalid" sentinel values.
        switch baseType {
        case .enum:
            // Invalid if 0xFF
            let value = slice.first ?? 0xFF
            guard value != 0xFF else { return nil }
            return .enum(value)

        case .sint8:
            // Invalid if 0x7F
            let value = Int8(bitPattern: slice.first ?? 0x7F)
            guard value != 0x7F else { return nil }
            return .sint8(value)

        case .uint8:
            // Invalid if 0xFF
            let value = slice.first ?? 0xFF
            guard value != 0xFF else { return nil }
            return .uint8(value)

        case .sint16:
            // Invalid if 0x7FFF
            let raw = slice.withUnsafeBytes { $0.load(as: Int16.self) }
            let value = convertEndian(raw)
            guard value != 0x7FFF else { return nil }
            return .sint16(value)

        case .uint16:
            // Invalid if 0xFFFF
            let raw = slice.withUnsafeBytes { $0.load(as: UInt16.self) }
            let value = convertEndian(raw)
            guard value != 0xFFFF else { return nil }
            return .uint16(value)

        case .sint32:
            // Invalid if 0x7FFFFFFF
            let raw = slice.withUnsafeBytes { $0.load(as: Int32.self) }
            let value = convertEndian(raw)
            guard value != 0x7FFFFFFF else { return nil }
            return .sint32(value)

        case .uint32:
            // Invalid if 0xFFFFFFFF
            let raw = slice.withUnsafeBytes { $0.load(as: UInt32.self) }
            let value = convertEndian(raw)
            guard value != 0xFFFFFFFF else { return nil }
            return .uint32(value)

        case .string:
            // Often in FIT, an empty or all-null string is invalid.
            // This logic treats an empty string as invalid.
            if let nullTerminatedString = String(bytes: bytes, encoding: .utf8)?
                .split(separator: "\0", maxSplits: 1, omittingEmptySubsequences: true)
                .first
            {
                let str = String(nullTerminatedString)
                guard !str.isEmpty else { return nil }
                return .string(str)
            }
            return nil

        case .float32:
            // Invalid if bitPattern == 0xFFFFFFFF
            let raw = slice.withUnsafeBytes { $0.load(as: UInt32.self) }
            let converted = convertEndian(raw)
            guard converted != 0xFFFFFFFF else { return nil }
            return .float32(Float(bitPattern: converted))

        case .float64:
            // Invalid if bitPattern == 0xFFFFFFFFFFFFFFFF
            let raw = slice.withUnsafeBytes { $0.load(as: UInt64.self) }
            let converted = convertEndian(raw)
            guard converted != 0xFFFFFFFFFFFFFFFF else { return nil }
            return .float64(Double(bitPattern: converted))

        case .uint8z:
            // Invalid if 0x00
            let value = slice.first ?? 0x00
            guard value != 0x00 else { return nil }
            return .uint8z(value)

        case .uint16z:
            // Invalid if 0xFFFF
            let raw = slice.withUnsafeBytes { $0.load(as: UInt16.self) }
            let value = convertEndian(raw)
            guard value != 0xFFFF else { return nil }
            return .uint16z(value)

        case .uint32z:
            // Invalid if 0xFFFFFFFF
            let raw = slice.withUnsafeBytes { $0.load(as: UInt32.self) }
            let value = convertEndian(raw)
            guard value != 0xFFFFFFFF else { return nil }
            return .uint32z(value)

        case .bytes:
            // Some FIT specs treat an array of 0xFF as invalid
            guard !bytes.allSatisfy({ $0 == 0xFF }) else { return nil }
            return .bytes(bytes)

        case .sint64:
            // Invalid if 0x7FFFFFFFFFFFFFFF
            let raw = slice.withUnsafeBytes { $0.load(as: Int64.self) }
            let value = convertEndian(raw)
            guard value != 0x7FFFFFFFFFFFFFFF else { return nil }
            return .sint64(value)

        case .uint64:
            // Invalid if 0xFFFFFFFFFFFFFFFF
            let raw = slice.withUnsafeBytes { $0.load(as: UInt64.self) }
            let value = convertEndian(raw)
            guard value != 0xFFFFFFFFFFFFFFFF else { return nil }
            return .uint64(value)

        case .uint64z:
            // Invalid if 0x0000000000000000
            let raw = slice.withUnsafeBytes { $0.load(as: UInt64.self) }
            let value = convertEndian(raw)
            guard value != 0x0000000000000000 else { return nil }
            return .uint64z(value)
        }
    }
}
