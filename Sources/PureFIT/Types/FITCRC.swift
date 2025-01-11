//
//  FITCRC.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/11/25.
//

import Foundation

public struct FITCRC {
    public enum ValidationMethod {
        case requireValidCRC, validateCRCIfPresent, skipCRCValidation
    }

    public let checksum: UInt16

    static private let crc_table: [UInt16] = [
        0x0000, 0xCC01, 0xD801, 0x1400, 0xF001, 0x3C00, 0x2800, 0xE401,
        0xA001, 0x6C00, 0x7800, 0xB401, 0x5000, 0x9C01, 0x8801, 0x4400
    ]

    internal init(checksum: UInt16) {
        self.checksum = checksum
    }

    public func isValid(data: Data) -> Bool {
        var tmp: UInt16 = 0
        var crc: UInt16 = 0
        
        for byte in data {
            // compute checksum of lower four bits of byte
            tmp = FITCRC.crc_table[Int(crc & 0xF)]
            crc = (crc >> 4) & 0x0FFF
            crc = crc ^ tmp ^ FITCRC.crc_table[Int(byte & 0xF)]

            // now compute checksum of upper four bits of byte
            tmp = FITCRC.crc_table[Int(crc & 0xF)];
            crc = (crc >> 4) & 0x0FFF;
            crc = crc ^ tmp ^ FITCRC.crc_table[Int((byte >> 4) & 0xF)]
        }
        
        return checksum == crc
    }
}

extension FITHeader {
    public func isCRCValid(headerData: Data) -> Bool? {
        guard let crc else { return nil }
        return crc.isValid(data: headerData)
    }
}

extension FITFile {
    public func isHeaderCRCValid(fileData: Data) -> Bool? {
        guard header.crc != nil else { return nil }
        let headerSizeWithoutCRC = Int(header.headerSize) - 2
        return header.isCRCValid(headerData: fileData.subdata(in: 0..<headerSizeWithoutCRC))
    }

    public func isCRCValid(fileData: Data) -> Bool? {
        guard let crc = crc else { return nil }
        let messageDataStartOffset = Int(header.headerSize)
        let messageDataEndOffset = fileData.count - 2
        return crc.isValid(data: fileData.subdata(in: messageDataStartOffset..<messageDataEndOffset))
    }
}
