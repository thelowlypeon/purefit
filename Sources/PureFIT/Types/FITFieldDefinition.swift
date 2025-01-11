//
//  FITFieldDefinition.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/11/25.
//

public struct FITFieldDefinition {
    let fieldDefinitionNumber: UInt8
    let size: UInt8 // in bytes
    let baseType: FITBaseType
}
