//
//  FITFieldDefinition.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/11/25.
//

public typealias FITFieldDefinitionNumber = UInt8

public struct FITFieldDefinition {
    let fieldDefinitionNumber: FITFieldDefinitionNumber
    let size: UInt8 // in bytes
    let baseType: FITBaseType
}

public struct FITDeveloperFieldDefinition {
    let developerFieldDefinitionNumber: FITFieldDefinitionNumber // this refers to the field definition number in the field description message
    let size: UInt8 // in bytes
    let developerDataIndex: UInt8
}
