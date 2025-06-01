//
//  DistanceField.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

import Foundation

struct DistanceField: NamedFieldDefinition, DimensionalFieldDefinition, MeasurableFieldDefinition {
    struct Value: FieldValue, MeasurementValue {
        let measurement: Measurement<UnitLength>
    }

    let name: String
    let baseType: FITBaseType
    let unit: UnitLength
    let scale: Double
    let offset: Double
    // TODO: width and usage (for formatting)

    func parse(values: [FITValue]) -> Value? {
        guard let value = values.first, let measurement = measurement(value) else { return nil }
        return Value(measurement: measurement)
    }
}
