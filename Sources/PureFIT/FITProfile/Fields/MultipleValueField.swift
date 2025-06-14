//
//  MultipleValueField.swift
//  PureFIT
//
//  Created by Peter Compernolle on 6/14/25.
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
