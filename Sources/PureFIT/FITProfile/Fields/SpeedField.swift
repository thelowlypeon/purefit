//
//  SpeedField.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

import Foundation

public struct SpeedField: NamedFieldDefinition, DimensionalFieldDefinition, MeasurableFieldDefinition {
    public struct Value: FieldValue, MeasurementValue {
        public let measurement: Measurement<UnitSpeed>
    }

    public let name: String
    public let baseType: FITBaseType
    public let unit: UnitSpeed
    public let scale: Double
    public let offset: Double

    public func parse(values: [FITValue]) -> Value? {
        guard let value = values.first, let measurement = measurement(value) else { return nil }
        return Value(measurement: measurement)
    }
}
