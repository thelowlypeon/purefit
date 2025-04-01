//
//  AngleField.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

import Foundation

struct AngleField: FieldDefinition, DimensionalFieldDefinition, MeasurableFieldDefinition, Sendable {
    struct Value: FieldValue, MeasurementValue {
        let measurement: Measurement<UnitAngle>
        // TODO: convert to degrees?
    }

    let name: String
    let baseType: FITBaseType
    let scale: Double
    let offset: Double
    var unit: UnitAngle { .garminSemicircle } // TODO: this should probably be configurable. TBD.

    func parse(values: [FITValue]) -> Value? {
        guard let value = values.first, let measurement = measurement(value) else { return nil }
        return Value(measurement: measurement)
    }
}
