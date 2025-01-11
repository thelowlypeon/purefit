//
//  FITFile.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/11/25.
//

public struct FITFile {
    let header: FITHeader
    let records: [FITRecord]
    let crc: FITCRC?
}
