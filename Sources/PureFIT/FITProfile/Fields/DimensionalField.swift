//
//  DimensionalField.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

public protocol DimensionalFieldDefinition {
    var scale: Double { get }
    var offset: Double { get }
}

public extension DimensionalFieldDefinition {
    func scaledValue(_ doubleValue: Double?) -> Double? {
        guard let doubleValue else { return nil }
        return (doubleValue / scale) - offset
    }
}

public extension DimensionalFieldDefinition where Self: NamedFieldDefinition {
    func scaledValue(_ value: FITValue) -> Double? {
        return scaledValue(value.doubleValue(from: baseType))
    }
}
