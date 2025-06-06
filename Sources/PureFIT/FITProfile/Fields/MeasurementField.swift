//
//  MeasurementField.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

import Foundation

public protocol MeasurementValue {
    associatedtype T: Dimension
    var measurement: Measurement<T> { get }
    var formatter: MeasurementFormatter { get }
}

public extension MeasurementValue {
    var formatter: MeasurementFormatter {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .short
        formatter.unitOptions = .naturalScale
        return formatter
    }
}

public extension MeasurementValue where Self: FieldValue {
    func format(locale: Locale) -> String {
        let formatter = formatter
        formatter.locale = locale
        return formatter.string(from: measurement)
    }
}

public protocol MeasurableFieldDefinition {
    associatedtype UnitType: Dimension
    var unit: UnitType { get }
    func measurement(_ value: FITValue) -> Measurement<UnitType>?
}

public extension MeasurableFieldDefinition where Self: DimensionalFieldDefinition, Self: NamedFieldDefinition {
    func measurement(_ value: FITValue) -> Measurement<UnitType>? {
        guard let doubleValue = scaledValue(value) else { return nil }
        return Measurement<UnitType>(value: doubleValue, unit: unit)
    }
}
