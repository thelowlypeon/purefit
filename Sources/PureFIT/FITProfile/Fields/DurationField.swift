//
//  DurationField.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

import Foundation

public struct MultipleValueField<T: NamedFieldDefinition>: FieldDefinition {
    public struct Value: FieldValue {
        public let values: [T.Value]

        public func format(locale: Locale) -> String {
            return values.map { $0.format(locale: locale) }.joined(separator: ", ")
        }
    }
    public let singleFieldDefinition: T
    public var name: String { singleFieldDefinition.name }
    public var baseType: FITBaseType { singleFieldDefinition.baseType }

    public func parse(values: [FITValue]) -> Value? {
        return Value(values: values.compactMap { singleFieldDefinition.parse(values: [$0]) })
    }
}

public struct DurationField: NamedFieldDefinition, DimensionalFieldDefinition {
    public struct Value: FieldValue {
        public let duration: TimeInterval // seconds

        public func format(locale: Locale) -> String {
            let dateComponentsFormatter = DateComponentsFormatter()
            dateComponentsFormatter.allowedUnits = [.hour, .minute, .second]
            dateComponentsFormatter.unitsStyle = .positional
            if let str = dateComponentsFormatter.string(from: duration) {
                return str
            } else {
                let measurementFormatter = MeasurementFormatter()
                measurementFormatter.locale = locale
                return measurementFormatter.string(from: Measurement<UnitDuration>(value: duration, unit: .seconds))
            }
        }
    }
    public let name: String
    public let baseType: FITBaseType
    public let unit: UnitDuration
    public let scale: Double
    public let offset: Double

    public func parse(values: [FITValue]) -> Value? {
        guard let value = values.first, let duration = scaledValue(value) else { return nil }
        return Value(duration: duration)
    }
}
