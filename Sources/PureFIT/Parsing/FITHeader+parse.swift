//
//  FITHeader+parse.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/11/25.
//

import Foundation

extension FITHeader {
    public enum ParserError: Error {
        case invalidLength, malformedHeader, invalidCRC
    }

    internal init(data: Data, offset: inout Int, validationMethod: FITCRC.ValidationMethod = .validateCRCIfPresent) throws {
        guard data.count >= 12 else { throw ParserError.invalidLength }

        let headerSize = data[offset]
        guard headerSize == 12 || headerSize == 14 else { throw ParserError.invalidLength } // FIT headers are 12 or 14 bytes
        offset += 1

        let protocolVersion = data[offset]
        offset += 1

        let profileVersion = UInt16(data[offset]) | (UInt16(data[offset + 1]) << 8)
        offset += 2

        let dataSize = UInt32(data[offset]) | (UInt32(data[offset + 1]) << 8) | (UInt32(data[offset + 2]) << 16) | (UInt32(data[offset + 3]) << 24)
        offset += 4

        let dataType = String(bytes: data[offset..<offset + 4], encoding: .ascii) ?? ""
        offset += 4

        guard dataType == ".FIT" else {
            throw ParserError.malformedHeader
        }

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

        // header data has a fixed length of 12, ie, excluding 2 CRC bytes if they exist
        let headerData = data.subdata(in: 0..<12)
        switch validationMethod {
        case .requireValidCRC:
            guard isCRCValid(headerData: headerData) == true else { throw ParserError.invalidCRC }
        case .validateCRCIfPresent:
            if let valid = isCRCValid(headerData: headerData) {
                guard valid else { throw ParserError.invalidCRC }
            }
        case .skipCRCValidation:
            break
        }
    }

}
