//
//  FITFile+parse.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/11/25.
//

import Foundation

extension FITFile {
    internal init?(data: Data) {
        var offset = 0

        // Parse the header
        guard let header = FITHeader(data: data, offset: &offset) else {
            print("Failed to parse header")
            return nil
        }

        // Verify the data type
        guard header.dataType == ".FIT" else {
            print("Invalid data type in header: \(header.dataType)")
            return nil
        }

        print("parsing records with header \(header)")

        // Parse records
        var records: [FITRecord] = []
        var definitions: [UInt16: FITDefinitionRecord] = [:]

        while offset < data.count - (header.crc != nil ? 2 : 0) {
            guard let record = FITRecord(data: data, offset: &offset, definitions: &definitions) else {
                return nil
            }
            records.append(record)
        }

        // Parse CRC if present
        let crc: FITCRC?
        if header.crc != nil {
            guard offset + 2 <= data.count else {
                //print("Missing CRC data")
                return nil
            }
            let checksum = UInt16(data[offset]) | (UInt16(data[offset + 1]) << 8)
            crc = FITCRC(checksum: checksum)
            offset += 2
        } else {
            crc = nil
        }

        self.header = header
        self.records = records
        self.crc = crc
    }
}
