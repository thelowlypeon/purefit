//
//  FITValue.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/15/25.
//

import Foundation // for UUID

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

extension FITValue: CustomStringConvertible {
    public var description: String {
        switch self {
        case .enum(let val):
            return String(val)
        case .sint8(let val):
            return String(val)
        case .uint8(let val):
            return String(val)
        case .sint16(let val):
            return String(val)
        case .uint16(let val):
            return String(val)
        case .sint32(let val):
            return String(val)
        case .uint32(let val):
            return String(val)
        case .string(let val):
            return String(val)
        case .float32(let val):
            return String(val)
        case .float64(let val):
            return String(val)
        case .uint8z(let val):
            return String(val)
        case .uint16z(let val):
            return String(val)
        case .uint32z(let val):
            return String(val)
        case .bytes(let val):
            if val.count == 16 {
                let uuid = UUID(uuid: (
                    val[0], val[1], val[2], val[3],
                    val[4], val[5], val[6], val[7],
                    val[8], val[9], val[10], val[11],
                    val[12], val[13], val[14], val[15]
                ))
                return uuid.uuidString
            } else {
                return val.map { String(format: "%02X", $0) }.joined()
            }
        case .sint64(let val):
            return String(val)
        case .uint64(let val):
            return String(val)
        case .uint64z(let val):
            return String(val)
        }
    }
}

extension FITValue: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .enum: ".enum(\(description))"
        case .sint8: ".sint8(\(description))"
        case .uint8: ".uint8(\(description))"
        case .sint16: ".sint16(\(description))"
        case .uint16: ".uint16(\(description))"
        case .sint32: ".sint32(\(description))"
        case .uint32: ".uint32(\(description))"
        case .string: ".string(\(description))"
        case .float32: ".float32(\(description))"
        case .float64: ".float64(\(description))"
        case .uint8z: ".uint8z(\(description))"
        case .uint16z: ".uint16z(\(description))"
        case .uint32z: ".uint32z(\(description))"
        case .bytes(let val): ".bytes(\(val.map { String(format: "%02X", $0) }.joined(separator: ", ")))"
        case .sint64: ".sint64(\(description))"
        case .uint64: ".uint64(\(description))"
        case .uint64z: ".uint64z(\(description))"
        }
    }
}

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

extension FITValue {
    func doubleValue(from baseType: FITBaseType) -> Double? {
        switch baseType {
        case .sint8:
            if case .sint8(let val) = self {
                return Double(val)
            }
        case .uint8:
            if case .uint8(let val) = self {
                return Double(val)
            }
        case .uint8z:
            if case .uint8z(let val) = self {
                return Double(val)
            }
        case .sint16:
            if case .sint16(let val) = self {
                return Double(val)
            }
        case .uint16:
            if case .uint16(let val) = self {
                return Double(val)
            }
        case .sint32:
            if case .sint32(let val) = self {
                return Double(val)
            }
        case .uint32:
            if case .uint32(let val) = self {
                return Double(val)
            }
        case .float32:
            if case .float32(let val) = self {
                return Double(val)
            }
        case .float64:
            if case .float64(let val) = self {
                return Double(val)
            }
        case .uint16z:
            if case .uint16z(let val) = self {
                return Double(val)
            }
        case .uint32z:
            if case .uint32z(let val) = self {
                return Double(val)
            }
        case .sint64:
            if case .sint64(let val) = self {
                return Double(val)
            }
        case .uint64:
            if case .uint64(let val) = self {
                return Double(val)
            }
        case .uint64z:
            if case .uint64z(let val) = self {
                return Double(val)
            }
        default: break
        }
        return nil
    }

    func integerValue(from baseType: FITBaseType) -> Int? {
        switch baseType {
        case .sint8:
            if case .sint8(let val) = self {
                return Int(val)
            }
        case .uint8:
            if case .uint8(let val) = self {
                return Int(val)
            }
        case .uint8z:
            if case .uint8z(let val) = self {
                return Int(val)
            }
        case .sint16:
            if case .sint16(let val) = self {
                return Int(val)
            }
        case .uint16:
            if case .uint16(let val) = self {
                return Int(val)
            }
        case .sint32:
            if case .sint32(let val) = self {
                return Int(val)
            }
        case .uint32:
            if case .uint32(let val) = self {
                return Int(val)
            }
        case .uint16z:
            if case .uint16z(let val) = self {
                return Int(val)
            }
        case .uint32z:
            if case .uint32z(let val) = self {
                return Int(val)
            }
        case .sint64:
            if case .sint64(let val) = self {
                return Int(val)
            }
        case .uint64:
            if case .uint64(let val) = self {
                return Int(val)
            }
        case .uint64z:
            if case .uint64z(let val) = self {
                return Int(val)
            }
        default: break
        }
        return nil
    }
}
