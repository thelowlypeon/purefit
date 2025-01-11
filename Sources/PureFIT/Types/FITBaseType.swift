//
//  FITBaseType.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/11/25.
//

public enum FITBaseType: UInt8 {
    case `enum` = 0x00       // Enum type, invalid value: 0xFF, size: 1 byte
    case sint8 = 0x01        // Signed 8-bit integer, 2's complement, invalid value: 0x7F, size: 1 byte
    case uint8 = 0x02        // Unsigned 8-bit integer, invalid value: 0xFF, size: 1 byte
    case sint16 = 0x83       // Signed 16-bit integer, 2's complement, invalid value: 0x7FFF, size: 2 bytes
    case uint16 = 0x84       // Unsigned 16-bit integer, invalid value: 0xFFFF, size: 2 bytes
    case sint32 = 0x85       // Signed 32-bit integer, 2's complement, invalid value: 0x7FFFFFFF, size: 4 bytes
    case uint32 = 0x86       // Unsigned 32-bit integer, invalid value: 0xFFFFFFFF, size: 4 bytes
    case string = 0x07       // Null-terminated string encoded in UTF-8, invalid value: 0x00, size: 1 byte
    case float32 = 0x88      // 32-bit floating point, invalid value: 0xFFFFFFFF, size: 4 bytes
    case float64 = 0x89      // 64-bit floating point, invalid value: 0xFFFFFFFFFFFFFFFF, size: 8 bytes
    case uint8z = 0x0A       // Unsigned 8-bit integer with zero invalid, invalid value: 0x00, size: 1 byte
    case uint16z = 0x8B      // Unsigned 16-bit integer with zero invalid, invalid value: 0x0000, size: 2 bytes
    case uint32z = 0x8C      // Unsigned 32-bit integer with zero invalid, invalid value: 0x00000000, size: 4 bytes
    case byte = 0x0D         // Array of bytes, invalid if all bytes are invalid, invalid value: 0xFF, size: 1 byte
    case sint64 = 0x8E       // Signed 64-bit integer, 2's complement, invalid value: 0x7FFFFFFFFFFFFFFF, size: 8 bytes
    case uint64 = 0x8F       // Unsigned 64-bit integer, invalid value: 0xFFFFFFFFFFFFFFFF, size: 8 bytes
    case uint64z = 0x90      // Unsigned 64-bit integer with zero invalid, invalid value: 0x0000000000000000, size: 8 bytes

    var isEndianCapable: Bool {
        switch self {
        case .sint16, .uint16, .sint32, .uint32, .float32, .float64, .uint16z, .uint32z, .sint64, .uint64, .uint64z:
            return true
        default:
            return false
        }
    }

    var invalidValue: Any {
        switch self {
        case .enum, .uint8, .byte: return 0xFF
        case .sint8: return 0x7F
        case .sint16: return 0x7FFF
        case .uint16, .uint16z: return 0xFFFF
        case .sint32: return 0x7FFFFFFF
        case .uint32, .float32, .uint32z: return 0xFFFFFFFF
        case .string: return 0x00
        case .float64, .uint64: return UInt64(0xFFFFFFFFFFFFFFFF)
        case .uint64z: return 0x0000000000000000
        case .sint64: return 0x7FFFFFFFFFFFFFFF
        case .uint8z: return 0x00
        }
    }

    var size: Int? {
        switch self {
        case .enum, .sint8, .uint8, .uint8z, .byte: return 1
        case .sint16, .uint16, .uint16z: return 2
        case .sint32, .uint32, .float32, .uint32z: return 4
        case .sint64, .uint64, .uint64z, .float64: return 8
        case .string:
            return nil // null terminated
        }
    }
}
