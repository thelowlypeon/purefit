//
//  FITDefinitionRecord.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/11/25.
//

public struct FITDefinitionRecord {
    let architecture: FITArchitecture
    let globalMessageNumber: UInt16
    let fieldCount: UInt8
    let fields: [FITFieldDefinition]
    let developerFields: [FITFieldDefinition]
}
