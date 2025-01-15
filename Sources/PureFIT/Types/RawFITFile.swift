//
//  FITFile.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/11/25.
//

public struct RawFITFile {
    public let header: FITHeader
    public let records: [RawFITRecord]
    public let crc: FITCRC?
}
