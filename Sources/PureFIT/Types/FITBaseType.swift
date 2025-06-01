//
//  FITBaseType.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/15/25.
//

public enum FITBaseType: UInt8 {
    case `enum` = 0         // Enum type, invalid value: 255, size: 1 byte
    case sint8 = 1          // Signed 8-bit integer, 2's complement, invalid value: 127, size: 1 byte
    case uint8 = 2          // Unsigned 8-bit integer, invalid value: 255, size: 1 byte
    case string = 7         // Null-terminated string encoded in UTF-8, invalid value: 0, size: 1 byte
    case uint8z = 10        // Unsigned 8-bit integer with zero invalid, invalid value: 0, size: 1 byte
    case bytes = 13         // Array of bytes, invalid if all bytes are invalid, invalid value: 255, size: 1 byte
    case sint16 = 131       // Signed 16-bit integer, 2's complement, invalid value: 32767, size: 2 bytes
    case uint16 = 132       // Unsigned 16-bit integer, invalid value: 65535, size: 2 bytes
    case sint32 = 133       // Signed 32-bit integer, 2's complement, invalid value: 2147483647, size: 4 bytes
    case uint32 = 134       // Unsigned 32-bit integer, invalid value: 4294967295, size: 4 bytes
    case float32 = 136      // 32-bit floating point, invalid value: 4294967295, size: 4 bytes
    case float64 = 137      // 64-bit floating point, invalid value: 18446744073709551615, size: 8 bytes
    case uint16z = 139      // Unsigned 16-bit integer with zero invalid, invalid value: 0, size: 2 bytes
    case uint32z = 140      // Unsigned 32-bit integer with zero invalid, invalid value: 0, size: 4 bytes
    case sint64 = 142       // Signed 64-bit integer, 2's complement, invalid value: 9223372036854775807, size: 8 bytes
    case uint64 = 143       // Unsigned 64-bit integer, invalid value: 18446744073709551615, size: 8 bytes
    case uint64z = 144      // Unsigned 64-bit integer with zero invalid, invalid value: 0, size: 8 bytes
}
extension FITBaseType: RawRepresentable {}
extension FITBaseType: Sendable {}

extension FITBaseType {
    public var size: Int? {
        switch self {
        case .enum, .sint8, .uint8, .uint8z: return 1
        case .sint16, .uint16, .uint16z: return 2
        case .sint32, .uint32, .float32, .uint32z: return 4
        case .sint64, .uint64, .uint64z, .float64: return 8
        case .bytes, .string:
            return nil // null terminated
        }
    }
}
