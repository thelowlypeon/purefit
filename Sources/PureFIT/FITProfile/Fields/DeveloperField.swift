//
//  DeveloperField.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

import Foundation

struct DeveloperField: FieldDefinition, DimensionalFieldDefinition {
    struct Value: FieldValue {
        let stringValue: String // TODO we can do better than this, right?

        func format(locale: Locale) -> String {
            return stringValue
        }
    }

    let name: String
    let fieldDefinitionNumber: FieldDefinitionNumber // always developer... should this instead have a developerDataIndex and a developerFieldNumber?
    let baseType: FITBaseType
    let scale: Double
    let offset: Double
    let units: String?
    let nativeMessageNumber: UInt16?

    func parse(values: [FITValue]) -> Value? {
        // developer fields can only have one per message
        guard let value = values.first else { return nil }
        let unitString = units == nil ? "" : " \(units!)"
        if baseType == .string, case .string(let str) = value {
            return Value(stringValue: str)
        }
        if let int = value.integerValue(from: baseType) {
            return Value(stringValue: "\(int)\(unitString)")
        }
        if let double = value.doubleValue(from: baseType) {
            return Value(stringValue: "\(double)\(unitString)")
        }
        return nil
    }

    init?(fieldDescriptionMessage message: FITMessage) {
        // TODO: Profile this!
        guard case .uint8(let developerDataIndex) = message.value(at: 0),
              case .uint8(let developerFieldNumber) = message.value(at: 1),
              case .uint8(let fitBaseTypeRawValue) = message.value(at: 2),
              let baseType = FITBaseType(rawValue: fitBaseTypeRawValue)
        else { return nil }
        if case .string(let name) = message.value(at: 3) {
            self.name = name
        } else {
            self.name = "\(developerDataIndex)-\(developerFieldNumber)"
        }
        self.fieldDefinitionNumber = .developer(developerDataIndex, developerFieldNumber)
        self.scale = message.value(at: 6)?.doubleValue(from: .uint8) ?? 1
        self.offset = message.value(at: 7)?.doubleValue(from: .sint8) ?? 0
        if case .string(let unitString) = message.value(at: 8) {
            self.units = unitString
        } else {
            self.units = nil
        }
        self.baseType = baseType
        if case .uint16(let num) = message.value(at: 14) {
            self.nativeMessageNumber = num
        } else {
            self.nativeMessageNumber = nil
        }
    }
}

