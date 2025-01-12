//
//  FITDefinitionRecord.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/11/25.
//

public typealias FITGlobalMessageNumber = UInt16

public struct FITDefinitionRecord {
    let architecture: FITArchitecture
    let globalMessageNumber: FITGlobalMessageNumber
    let fieldCount: UInt8
    let fields: [FITFieldDefinition]
    let developerFields: [FITDeveloperFieldDefinition]
}
