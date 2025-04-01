//
//  SpeedField.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

import Foundation

struct SpeedField: FieldDefinition, DimensionalFieldDefinition, MeasurableFieldDefinition {
    struct Value: FieldValue, MeasurementValue {
        let measurement: Measurement<UnitSpeed>
    }

    let name: String
    let baseType: FITBaseType
    let unit: UnitSpeed
    let scale: Double
    let offset: Double

    func parse(values: [FITValue]) -> Value? {
        guard let value = values.first, let measurement = measurement(value) else { return nil }
        return Value(measurement: measurement)
    }
}
