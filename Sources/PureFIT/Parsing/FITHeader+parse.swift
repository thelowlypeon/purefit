//
//  FITHeader+parse.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/11/25.
//

import Foundation

extension FITHeader {
    internal init?(data: Data, offset: inout Int) {
        guard data.count >= 12 else { return nil }

        let headerSize = data[offset]
        guard headerSize == 12 || headerSize == 14 else { return nil } // FIT headers are 12 or 14 bytes
        offset += 1

        let protocolVersion = data[offset]
        offset += 1

        let profileVersion = UInt16(data[offset]) | (UInt16(data[offset + 1]) << 8)
        offset += 2

        let dataSize = UInt32(data[offset]) | (UInt32(data[offset + 1]) << 8) | (UInt32(data[offset + 2]) << 16) | (UInt32(data[offset + 3]) << 24)
        offset += 4

        let dataType = String(bytes: data[offset..<offset + 4], encoding: .ascii) ?? ""
        offset += 4

        let crc: FITCRC?
        if headerSize == 14 {
            let checksum = UInt16(data[offset]) | (UInt16(data[offset + 1]) << 8)
            crc = FITCRC(checksum: checksum)
            offset += 2
        } else {
            crc = nil
        }

        self.headerSize = headerSize
        self.protocolVersion = protocolVersion
        self.profileVersion = profileVersion
        self.dataSize = dataSize
        self.dataType = dataType
        self.crc = crc
    }

}
