//
//  FITRecord.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/11/25.
//

public enum FITRecord {
    case definition(FITDefinitionRecord)
    case data(FITDataRecord)

    public var globalMessageNumber: UInt16 {
        switch self {
        case .definition(let def):
            return def.globalMessageNumber
        case .data(let data):
            return data.globalMessageNumber
        }
    }
}
