//
//  FITFieldDefinition.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/11/25.
//

public typealias FITFieldDefinitionNumber = UInt8

public struct FITFieldDefinition {
    public let fieldDefinitionNumber: FITFieldDefinitionNumber
    public let size: UInt8 // in bytes
    public let baseType: FITBaseType
}

public struct FITDeveloperFieldDefinition {
    public let developerFieldDefinitionNumber: FITFieldDefinitionNumber // this refers to the field definition number in the field description message
    public let size: UInt8 // in bytes
    public let developerDataIndex: UInt8
}
