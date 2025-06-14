//
//  EnergyField.swift
//  PureFIT
//
//  Created by Peter Compernolle on 6/14/25.
//

import Foundation

public struct EnergyField: NamedFieldDefinition, MeasurableFieldDefinition, DimensionalFieldDefinition {
    public struct Value: FieldValue, MeasurementValue {
        public let measurement: Measurement<UnitEnergy>
    }
    public let name: String
    public let baseType: FITBaseType
    public let unit: UnitEnergy
    public let scale: Double
    public let offset: Double

    public func parse(values: [FITValue]) -> Value? {
        guard let value = values.first, let energyInUnit = scaledValue(value) else { return nil }
        let measurement = Measurement<UnitEnergy>(value: energyInUnit, unit: unit)
        return Value(measurement: measurement)
    }
}
