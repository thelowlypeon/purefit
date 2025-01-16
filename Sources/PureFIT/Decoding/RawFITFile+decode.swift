//
//  FITFile+decode.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/11/25.
//

import Foundation

extension RawFITFile {
    enum DecodeError: Error {
        case invalidHeaderCRC, invalidCRC
    }

    public init(url: URL, validationMethod: FITCRC.ValidationMethod = .validateCRCIfPresent) throws {
        let data = try Data(contentsOf: url)
        try self.init(data: data, validationMethod: validationMethod)
    }

    public init(data: Data, validationMethod: FITCRC.ValidationMethod = .validateCRCIfPresent) throws {
        var offset = 0

        let header = try FITHeader(data: data, offset: &offset)

        // Parse records
        var records: [RawFITRecord] = []
        var definitionsByLocalMessageNumber: [UInt16: RawFITDefinitionRecord] = [:]

        while offset < data.count - (header.crc != nil ? 2 : 0) {
            let record = try RawFITRecord(data: data, offset: &offset, definitions: &definitionsByLocalMessageNumber)
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
                throw DecodeError.invalidCRC
            }
        case .validateCRCIfPresent:
            if isCRCValid(fileData: data) == false {
                throw DecodeError.invalidCRC
            }
        case .skipCRCValidation:
            break
        }
    }
}
