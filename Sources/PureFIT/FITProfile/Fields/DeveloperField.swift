//
//  DeveloperField.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

import Foundation

public struct DeveloperField: NamedFieldDefinition, DimensionalFieldDefinition {
    public struct Value: FieldValue {
        let stringValue: String
        let fitValue: FITValue

        public func format(locale: Locale) -> String {
            return stringValue
        }
    }

    public let name: String
    public let fieldDefinitionNumber: FieldDefinitionNumber // always developer... should this instead have a developerDataIndex and a developerFieldNumber?
    public let baseType: FITBaseType
    public let scale: Double
    public let offset: Double
    public let units: String?
    public let nativeMessageNumber: UInt16?

    public func parse(values: [FITValue]) -> Value? {
        // developer fields can only have one per message
        guard let value = values.first else { return nil }
        let unitString = units == nil ? "" : " \(units!)"
        if baseType == .string, case .string(let str) = value {
            return Value(stringValue: str, fitValue: value)
        }
        if let int = value.integerValue(from: baseType) {
            return Value(stringValue: "\(int)\(unitString)", fitValue: value)
        }
        if let double = value.doubleValue(from: baseType) {
            return Value(stringValue: "\(double)\(unitString)", fitValue: value)
        }
        return nil
    }

    internal init?(fieldDescriptionMessage message: FieldDescriptionMessage) {
        guard let developerDataIndex = message.developerDataIndex,
              let developerFieldNumber = message.fieldDefinitionNumber,
              let baseType = message.fitBaseType
        else { return nil }
        self.name = message.fieldName ?? "\(developerDataIndex)-\(developerFieldNumber)"
        self.fieldDefinitionNumber = .developer(UInt8(developerDataIndex), UInt8(developerFieldNumber))
        self.baseType = baseType
        self.scale = Double(message.scale ?? 1) // TODO: this should be an int
        self.offset = Double(message.offset ?? 0) // TODO: this should be an int
        self.units = message.units
        self.nativeMessageNumber = message.nativeMessageNumber != nil ? UInt16(message.nativeMessageNumber!) : nil
    }
}

