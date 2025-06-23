//
//  CompositeField.swift
//  PureFIT
//
//  Created by Peter Compernolle on 6/23/25.
//

import Foundation

public protocol CompositeFieldDefinition: FieldValue, Equatable {
    var name: String { get }
}

public protocol CompositeFieldSchema {
    init?(fitValue: FITValue)
    associatedtype SubField: CompositeFieldDefinition
    var values: [SubField] { get }
}

public struct CompositeField<T>: NamedFieldDefinition where T: CompositeFieldSchema {
    public struct Value: FieldValue {
        public let compositeValue: T

        public func format(locale: Locale = .current) -> String {
            if compositeValue.values.count == 1, let onlyValue = compositeValue.values.first {
                return onlyValue.format(locale: locale)
            }
            return compositeValue.values.map { value in
                return "\(value.name): \(value.format(locale: locale))"
            }.joined(separator: ", ")
        }
    }

    public let name: String
    public let baseType: FITBaseType

    public func parse(values: [FITValue]) -> Value? {
        guard let value = values.first, let compositeValue = T(fitValue: value) else { return nil }
        return Value(compositeValue: compositeValue)
    }
}
