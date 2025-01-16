//
//  FITMessage.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/15/25.
//

public struct FITMessage {
    public let globalMessageNumber: FITGlobalMessageNumber
    public let fields: [FieldDefinitionNumber: [FITValue]]

    public func value(at fieldNumber: UInt8) -> FITValue? {
        return fields[.standard(fieldNumber)]?.first
    }

    public func value(at fieldNumber: FieldDefinitionNumber) -> FITValue? {
        return fields[fieldNumber]?.first
    }

    public func values(at fieldNumber: UInt8) -> [FITValue]? {
        return fields[.standard(fieldNumber)]
    }

    public func values(at fieldNumber: FieldDefinitionNumber) -> [FITValue]? {
        return fields[fieldNumber]
    }

    internal init(definitionRecord: RawFITDefinitionRecord, dataRecord: RawFITDataRecord, developerFieldDefinitions: [FITMessage]) {
        var offset = 0
        let fields: [FITField] = definitionRecord.fields.compactMap { fieldDefinition in
            let fieldSize = Int(fieldDefinition.size)
            let value = FITValue.from(
                bytes: Array(dataRecord.fieldsData[offset..<(offset + fieldSize)]),
                baseType: fieldDefinition.baseType,
                architecture: definitionRecord.architecture
            )
            offset += fieldSize
            guard let value else { return nil }
            return .init(definition: fieldDefinition, value: value)
        }

        offset = 0
        let developerFields: [FITDeveloperField] = definitionRecord.developerFields.compactMap { fieldDefinition in
            let fieldSize = Int(fieldDefinition.size)
            // if we can't find the base type, just get a big value
            //guard dataRecord.developerFieldsData.count >= (offset + fieldSize) else { return nil }
            let bytes = dataRecord.developerFieldsData[offset..<(offset + fieldSize)]

            offset += fieldSize
            let developerFieldDefinition = developerFieldDefinitions.first(where: { definitionMessage in
                guard let fieldDefinitionNumberField = definitionMessage.value(at: .standard(1)),
                        case .uint8(let fieldDefinitionNumber) = fieldDefinitionNumberField,
                      let developerDataIndexField = definitionMessage.value(at: .standard(0)),
                        case .uint8(let developerDataIndex) = developerDataIndexField
                else { return false }
                return fieldDefinitionNumber == fieldDefinition.developerFieldDefinitionNumber && developerDataIndex == fieldDefinition.developerDataIndex
            })

            let baseType: FITBaseType
            if case .uint8(let baseTypeRawValue) = developerFieldDefinition?.value(at: .standard(2)) {
                baseType = FITBaseType(rawValue: baseTypeRawValue) ?? .bytes
            } else {
                baseType = .bytes
            }

            guard let value = FITValue.from(
                bytes: Array(bytes),
                baseType: baseType,
                architecture: .littleEndian)
            else { return nil }
            return FITDeveloperField(
                definition: fieldDefinition,
                value: value
            )
        }

        self.globalMessageNumber = dataRecord.globalMessageNumber
        let fieldsDict = Dictionary(fields.map { ($0.definition.fieldDefinition, [$0.value] )}, uniquingKeysWith: { lhs, rhs in
            return lhs + rhs
        })
        let devFieldsDict = Dictionary(developerFields.map { ($0.definition.fieldDefinition, [$0.value] )}, uniquingKeysWith: { lhs, rhs in
            return lhs + rhs
        })
        self.fields = fieldsDict.merging(devFieldsDict) { return $0 + $1 }
    }
}
