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
