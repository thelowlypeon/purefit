//
//  PowerField.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

import Foundation

struct PowerField: NamedFieldDefinition, DimensionalFieldDefinition, MeasurableFieldDefinition {
    struct Value: FieldValue, MeasurementValue {
        let measurement: Measurement<UnitPower>
    }

    let name: String
    let baseType: FITBaseType
    let scale: Double
    let offset: Double
    var unit: UnitPower { .watts }

    func parse(values: [FITValue]) -> Value? {
        guard let value = values.first, let measurement = measurement(value) else { return nil }
        return Value(measurement: measurement)
    }
}
