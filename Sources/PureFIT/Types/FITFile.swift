//
//  FITFile.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/11/25.
//

public struct FITFile {
    public let header: FITHeader
    public let records: [FITRecord]
    public let crc: FITCRC?
}
