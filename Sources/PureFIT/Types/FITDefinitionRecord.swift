//
//  FITDefinitionRecord.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/11/25.
//

public typealias FITGlobalMessageNumber = UInt16

public struct FITDefinitionRecord {
    public let architecture: FITArchitecture
    public let globalMessageNumber: FITGlobalMessageNumber
    public let fieldCount: UInt8
    public let fields: [FITFieldDefinition]
    public let developerFields: [FITDeveloperFieldDefinition]
}
