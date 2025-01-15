//
//  FITFieldsData+accessors.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/11/25.
//

@testable import PureFIT

extension Array where Element == UInt8 {
    func string(at index: Int) -> String? {
        guard self.count > index else { return nil }

        // important: strings are terminated with a null byte
        let stringBytes = self[index...].prefix { $0 != 0 }
        return String(bytes: Array(stringBytes), encoding: .ascii)
    }

    func uint32(at index: Int, architecture: FITArchitecture) -> UInt32? {
        guard self.count >= index + 4 else { return nil }

        let byte1 = self[index]
        let byte2 = self[index + 1]
        let byte3 = self[index + 2]
        let byte4 = self[index + 3]

        switch architecture {
        case .littleEndian:
            let uint32 = (UInt32(byte4) << 24) | (UInt32(byte3) << 16) | (UInt32(byte2) << 8) | UInt32(byte1)
            guard uint32 != 0xFFFFFFFF else { return nil }
            return uint32
        case .bigEndian:
            let uint32 = (UInt32(byte1) << 24) | (UInt32(byte2) << 16) | (UInt32(byte3) << 8) | UInt32(byte4)
            guard uint32 != 0xFFFFFFFF else { return nil }
            return uint32
        }
    }

    func uint16(at index: Int, architecture: FITArchitecture) -> UInt16? {
        guard self.count >= index + 2 else { return nil }

        let byte1 = self[index]
        let byte2 = self[index + 1]

        switch architecture {
        case .littleEndian:
            let uint16 = UInt16(byte1) | (UInt16(byte2) << 8)
            guard uint16 != 0xFFFF else { return nil }
            return uint16
        case .bigEndian:
            let uint16 = UInt16(byte2) | (UInt16(byte1) << 8)
            guard uint16 != 0xFFFF else { return nil }
            return uint16
        }
    }

    func float32(at index: Int, architecture: FITArchitecture) -> Float32? {
        // We need at least 4 bytes
        guard self.count >= index + 4 else {
            return nil
        }

        let byte1 = self[index]
        let byte2 = self[index + 1]
        let byte3 = self[index + 2]
        let byte4 = self[index + 3]

        let bitPattern: UInt32

        switch architecture {
        case .littleEndian:
            bitPattern = UInt32(byte1)
                | (UInt32(byte2) << 8)
                | (UInt32(byte3) << 16)
                | (UInt32(byte4) << 24)
        case .bigEndian:
            bitPattern = UInt32(byte4)
                | (UInt32(byte3) << 8)
                | (UInt32(byte2) << 16)
                | (UInt32(byte1) << 24)
        }

        // Check for invalid value
        guard bitPattern != 0xFFFFFFFF else {
            return nil
        }

        return Float32(bitPattern: bitPattern)
    }

}
