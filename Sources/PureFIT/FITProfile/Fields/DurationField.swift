//
//  DurationField.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

import Foundation

public struct DurationField: NamedFieldDefinition, MeasurableFieldDefinition, DimensionalFieldDefinition {
    public struct Value: FieldValue {
        public let measurement: Measurement<UnitDuration>
        public var duration: TimeInterval {
            measurement.converted(to: .seconds).value
        }

        public func format(locale: Locale) -> String {
            let dateComponentsFormatter = DateComponentsFormatter()
            dateComponentsFormatter.allowedUnits = [.hour, .minute, .second]
            dateComponentsFormatter.unitsStyle = .positional
            if measurement.unit == .seconds, let str = dateComponentsFormatter.string(from: measurement.value) {
                return str
            } else {
                let measurementFormatter = MeasurementFormatter()
                measurementFormatter.locale = locale
                measurementFormatter.unitOptions = .providedUnit // durations aren't locale-specific, are they? seconds vs microseconds
                return measurementFormatter.string(from: measurement)
            }
        }
    }
    public let name: String
    public let baseType: FITBaseType
    public let unit: UnitDuration
    public let scale: Double
    public let offset: Double

    public func parse(values: [FITValue]) -> Value? {
        guard let value = values.first, let durationInUnit = scaledValue(value) else { return nil }
        let measurement = Measurement<UnitDuration>(value: durationInUnit, unit: unit)
        return Value(measurement: measurement)
    }
}
