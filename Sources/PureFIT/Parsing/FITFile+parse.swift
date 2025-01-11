//
//  FITFile+parse.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/11/25.
//

import Foundation

extension FITFile {
    enum ParserError: Error {
        case invalidHeaderCRC, invalidCRC
    }

    public init(data: Data, validationMethod: FITCRC.ValidationMethod = .validateCRCIfPresent) throws {
        var offset = 0

        let header = try FITHeader(data: data, offset: &offset)

        // Parse records
        var records: [FITRecord] = []
        var definitions: [UInt16: FITDefinitionRecord] = [:]

        while offset < data.count - (header.crc != nil ? 2 : 0) {
            let record = try FITRecord(data: data, offset: &offset, definitions: &definitions)
            records.append(record)
        }

        // Parse CRC if present
        let crc: FITCRC?
        if offset + 2 <= data.count {
            let checksum = UInt16(data[offset]) | (UInt16(data[offset + 1]) << 8)
            crc = FITCRC(checksum: checksum)
            offset += 2
        } else {
            crc = nil
        }

        self.header = header
        self.records = records
        self.crc = crc

        switch validationMethod {
        case .requireValidCRC:
            if isCRCValid(fileData: data) != true {
                throw ParserError.invalidCRC
            }
        case .validateCRCIfPresent:
            if isCRCValid(fileData: data) == false {
                throw ParserError.invalidCRC
            }
        case .skipCRCValidation:
            break
        }
    }
}
