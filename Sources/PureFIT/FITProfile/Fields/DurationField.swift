//
//  DurationField.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

import Foundation

struct MultipleValueField<T: NamedFieldDefinition>: FieldDefinition {
    struct Value: FieldValue {
        let values: [T.Value]

        func format(locale: Locale) -> String {
            return values.map { $0.format(locale: locale) }.joined(separator: ", ")
        }
    }
    let singleFieldDefinition: T
    var name: String { singleFieldDefinition.name }
    var baseType: FITBaseType { singleFieldDefinition.baseType }

    func parse(values: [FITValue]) -> Value? {
        return Value(values: values.compactMap { singleFieldDefinition.parse(values: [$0]) })
    }
}

struct DurationField: NamedFieldDefinition, DimensionalFieldDefinition, MeasurableFieldDefinition {
    struct Value: FieldValue, MeasurementValue {
        let measurement: Measurement<UnitDuration>
    }
    let name: String
    let baseType: FITBaseType
    let unit: UnitDuration
    let scale: Double
    let offset: Double

    func parse(values: [FITValue]) -> Value? {
        guard let value = values.first, let measurement = measurement(value) else { return nil }
        return Value(measurement: measurement)
    }
}
