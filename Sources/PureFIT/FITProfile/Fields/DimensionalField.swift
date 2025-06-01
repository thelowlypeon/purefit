//
//  DimensionalField.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

protocol DimensionalFieldDefinition {
    var scale: Double { get }
    var offset: Double { get }
}

extension DimensionalFieldDefinition {
    func scaledValue(_ doubleValue: Double?) -> Double? {
        guard let doubleValue else { return nil }
        return (doubleValue / scale) - offset
    }
}

extension DimensionalFieldDefinition where Self: NamedFieldDefinition {
    func scaledValue(_ value: FITValue) -> Double? {
        return scaledValue(value.doubleValue(from: baseType))
    }
}
