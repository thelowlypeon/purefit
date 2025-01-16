//
//  FITDataRecord.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/11/25.
//

public struct RawFITDataRecord {
    public let localMessageNumber: UInt16
    public let globalMessageNumber: FITGlobalMessageNumber
    public let fieldsData: [UInt8]
    public let developerFieldsData: [UInt8]
}
