//
//  FITMessage.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/11/25.
//

public struct InterpretedFITMessage {
    public let globalMessageNumber: FITGlobalMessageNumber
    public let fields: [FITFieldDefinitionNumber: InterpretedFITValue] // TODO: some fields have multiple values, like cycles
    public let developerFields: [FITFieldDefinitionNumber: InterpretedFITValue]

    internal init(dataRecord: FITDataRecord, definitionRecord: FITDefinitionRecord, developerFieldDefinitions: [FITFieldDefinitionNumber: InterpretedFITMessage]) {
        var offset = 0
        let fields: [FITFieldDefinitionNumber: InterpretedFITValue] = Dictionary(uniqueKeysWithValues: definitionRecord.fields.compactMap { field in
            let fieldSize = Int(field.size)
            let value = InterpretedFITValue.from(
                bytes: Array(dataRecord.fieldsData.bytes[offset..<(offset + fieldSize)]),
                baseType: field.baseType,
                architecture: definitionRecord.architecture
            )
            offset += fieldSize
            guard let value else { return nil }
            return (field.fieldDefinitionNumber, value)
        })

        offset = 0
        let developerFields: [FITFieldDefinitionNumber: InterpretedFITValue] = Dictionary(uniqueKeysWithValues: definitionRecord.developerFields.compactMap { field -> (FITFieldDefinitionNumber, InterpretedFITValue)? in
            let def = developerFieldDefinitions[field.developerFieldDefinitionNumber]
            let baseTypeRawValue: UInt8?
            if case .uint8(let rawValue) = def?.fields[2] {
                baseTypeRawValue = rawValue
            } else {
                baseTypeRawValue = nil
            }

            let fieldSize = Int(field.size)
            // if we can't find the base type, just get a big value
            let baseType = baseTypeRawValue != nil ? (FITBaseType(rawValue: baseTypeRawValue!) ?? .float32) : .float32
            let value = InterpretedFITValue.from(
                bytes: Array(dataRecord.developerFieldsData.bytes[offset..<(offset + fieldSize)]),
                baseType: baseType,
                architecture: definitionRecord.architecture
            )
            offset += fieldSize
            guard let value else { return nil }
            return (field.developerFieldDefinitionNumber, value)
        })

        self.globalMessageNumber = dataRecord.globalMessageNumber
        self.fields = fields
        self.developerFields = developerFields
    }
}
