//
//  FITDataRecord.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/11/25.
//

public struct FITDataRecord {
    let globalMessageNumber: UInt16
    let fieldsData: FITFieldsData
    let developerFieldsData: FITFieldsData
}
