//
//  AngleField.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

import Foundation

public struct AngleField: NamedFieldDefinition, DimensionalFieldDefinition, MeasurableFieldDefinition, Sendable {
    public struct Value: FieldValue, MeasurementValue {
        public let measurement: Measurement<UnitAngle>
        // TODO: convert to degrees?
    }

    public let name: String
    public let baseType: FITBaseType
    public let scale: Double
    public let offset: Double
    public var unit: UnitAngle { .garminSemicircle } // TODO: this should probably be configurable. TBD.

    public func parse(values: [FITValue]) -> Value? {
        guard let value = values.first, let measurement = measurement(value) else { return nil }
        return Value(measurement: measurement)
    }
}
