//
//  FITFieldDefinition.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/11/25.
//

public enum FieldDefinitionNumber: Hashable, Equatable {
    case standard(UInt8)
    case developer(_ developerIndex: UInt8, _ fieldNumber: UInt8)
}

extension FieldDefinitionNumber: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        switch lhs {
        case .standard(let leftField):
            switch rhs {
            case .standard(let rightField): return leftField < rightField
            case .developer(_, _): return true
            }
        case .developer(let leftDev, let leftField):
            switch rhs {
            case .standard(_): return false
            case .developer(let rightDev, let rightField): return leftDev < rightDev || leftField < rightField
            }
        }
    }
}

public struct FITFieldDefinition {
    public let fieldDefinitionNumber: UInt8
    public let size: UInt8 // in bytes
    public let baseType: FITBaseType

    public var fieldDefinition: FieldDefinitionNumber {
        .standard(fieldDefinitionNumber)
    }
}

public struct FITDeveloperFieldDefinition {
    public let developerFieldDefinitionNumber: UInt8 // this refers to the field definition number in the field description message
    public let size: UInt8 // in bytes
    public let developerDataIndex: UInt8

    public var fieldDefinition: FieldDefinitionNumber {
        .developer(developerDataIndex, developerFieldDefinitionNumber)
    }
}
