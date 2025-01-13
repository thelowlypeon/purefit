//
//  FITDataRecord.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/11/25.
//

public struct FITDataRecord {
    public let globalMessageNumber: FITGlobalMessageNumber
    public let fieldsData: [UInt8]
    public let developerFieldsData: [UInt8]
}
