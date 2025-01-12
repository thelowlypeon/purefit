//
//  FITFieldValue.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/11/25.
//

public enum InterpretedFITValue {
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
    case byte([UInt8])       // Byte array, associated value: Array of UInt8
    case sint64(Int64)       // Signed 64-bit integer, associated value: Int64
    case uint64(UInt64)      // Unsigned 64-bit integer, associated value: UInt64
    case uint64z(UInt64)     // Unsigned 64-bit integer with zero invalid, associated value: UInt64

    var baseType: FITBaseType {
        switch self {
        case .enum: return .enum
        case .sint8: return .sint8
        case .uint8: return .uint8
        case .sint16: return .sint16
        case .uint16: return .uint16
        case .sint32: return .sint32
        case .uint32: return .uint32
        case .string: return .string
        case .float32: return .float32
        case .float64: return .float64
        case .uint8z: return .uint8z
        case .uint16z: return .uint16z
        case .uint32z: return .uint32z
        case .byte: return .byte
        case .sint64: return .sint64
        case .uint64: return .uint64
        case .uint64z: return .uint64z
        }
    }
}

extension InterpretedFITValue: Equatable {}

extension InterpretedFITValue {
    var value: Any {
        switch self {
        case .enum(let value): return value
        case .sint8(let value): return value
        case .uint8(let value): return value
        case .sint16(let value): return value
        case .uint16(let value): return value
        case .sint32(let value): return value
        case .uint32(let value): return value
        case .string(let value): return value
        case .float32(let value): return value
        case .float64(let value): return value
        case .uint8z(let value): return value
        case .uint16z(let value): return value
        case .uint32z(let value): return value
        case .byte(let value): return value
        case .sint64(let value): return value
        case .uint64(let value): return value
        case .uint64z(let value): return value
        }
    }
}

extension InterpretedFITValue {
    /// Creates a `FITFieldValue` from `[UInt8]` using a specified `FITBaseType` and architecture.
    /// - Parameters:
    ///   - bytes: The array of bytes from which the value will be extracted.
    ///   - baseType: The `FITBaseType` that specifies the type of the value.
    ///   - offset: The starting offset in the byte array. Default is 0.
    ///   - architecture: The endianness of the data.
    /// - Returns: A `FITFieldValue` instance or `nil` if the data is insufficient.
    static func from(
        bytes: [UInt8],
        baseType: FITBaseType,
        architecture: FITArchitecture
    ) -> InterpretedFITValue? {
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

        // Interpret the bytes based on the base type
        switch baseType {
        case .enum:
            return .enum(slice.first ?? 0xFF)
        case .sint8:
            return .sint8(Int8(bitPattern: slice.first ?? 0x7F))
        case .uint8:
            return .uint8(slice.first ?? 0xFF)
        case .sint16:
            let value = slice.withUnsafeBytes { $0.load(as: Int16.self) }
            return .sint16(convertEndian(value))
        case .uint16:
            let value = slice.withUnsafeBytes { $0.load(as: UInt16.self) }
            return .uint16(convertEndian(value))
        case .sint32:
            let value = slice.withUnsafeBytes { $0.load(as: Int32.self) }
            return .sint32(convertEndian(value))
        case .uint32:
            let value = slice.withUnsafeBytes { $0.load(as: UInt32.self) }
            return .uint32(convertEndian(value))
        case .string:
            if let nullTerminatedString = String(bytes: bytes, encoding: .utf8)?
                .split(separator: "\0", maxSplits: 1, omittingEmptySubsequences: true)
                .first {
                return .string(String(nullTerminatedString))
            }
            return nil
        case .float32:
            let value = slice.withUnsafeBytes { $0.load(as: UInt32.self) }
            return .float32(Float(bitPattern: convertEndian(value)))
        case .float64:
            let value = slice.withUnsafeBytes { $0.load(as: UInt64.self) }
            return .float64(Double(bitPattern: convertEndian(value)))
        case .uint8z:
            return .uint8z(slice.first ?? 0x00)
        case .uint16z:
            let value = slice.withUnsafeBytes { $0.load(as: UInt16.self) }
            return .uint16z(convertEndian(value))
        case .uint32z:
            let value = slice.withUnsafeBytes { $0.load(as: UInt32.self) }
            return .uint32z(convertEndian(value))
        case .byte:
            return .byte(Array(slice))
        case .sint64:
            let value = slice.withUnsafeBytes { $0.load(as: Int64.self) }
            return .sint64(convertEndian(value))
        case .uint64:
            let value = slice.withUnsafeBytes { $0.load(as: UInt64.self) }
            return .uint64(convertEndian(value))
        case .uint64z:
            let value = slice.withUnsafeBytes { $0.load(as: UInt64.self) }
            return .uint64z(convertEndian(value))
        }
    }
}

