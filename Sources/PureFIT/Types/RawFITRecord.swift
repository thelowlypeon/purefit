//
//  FITRecord.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/11/25.
//

public enum RawFITRecord {
    case definition(RawFITDefinitionRecord)
    case data(RawFITDataRecord)

    public var globalMessageNumber: UInt16 {
        switch self {
        case .definition(let def):
            return def.globalMessageNumber
        case .data(let data):
            return data.globalMessageNumber
        }
    }
}
