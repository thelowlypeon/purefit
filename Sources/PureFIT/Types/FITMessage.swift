//
//  FITMessage.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/15/25.
//


public protocol FITMessage: Sendable {
    var globalMessageNumber: FITGlobalMessageNumber { get }
    var fields: [FieldDefinitionNumber: [FITValue]] { get }
    func fieldDefinition(for fieldDefinitionNumber: FieldDefinitionNumber, developerFieldDefinitions: [FieldDefinitionNumber: DeveloperField]) -> any FieldDefinition
}

extension FITMessage {
    // TODO: make all these internal or at least decide whether it should be public API if we already have the values(at: [FieldDefinitionNumber])
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

    public func developerFieldValue(for developerField: DeveloperField) -> DeveloperField.Value? {
        guard developerField.nativeMessageNumber == nil || developerField.nativeMessageNumber == globalMessageNumber
        else { return nil }
        guard let rawValues = values(at: developerField.fieldDefinitionNumber) else { return nil }
        return developerField.parse(values: rawValues)
    }

    public func allValues(developerFields: [FieldDefinitionNumber: DeveloperField]) -> [FieldValue?] {
        return values(at: fields.keys.sorted(), developerFieldDefinitions: developerFields)
    }

    public func values(at fieldDefinitionNumbers: [FieldDefinitionNumber], developerFieldDefinitions: [FieldDefinitionNumber: DeveloperField]) -> [FieldValue?] {
        return fieldDefinitionNumbers.map { definitionNumber in
            let values = fields[definitionNumber]
            let fieldDefinition = fieldDefinition(for: definitionNumber, developerFieldDefinitions: developerFieldDefinitions)
            return values != nil ? fieldDefinition.parse(values: values!) : nil
        }
    }
}

public struct UnprofiledMessage: FITMessage {
    public let globalMessageNumber: FITGlobalMessageNumber
    public let fields: [FieldDefinitionNumber: [FITValue]]

    public func fieldDefinition(for fieldDefinitionNumber: FieldDefinitionNumber, developerFieldDefinitions: [FieldDefinitionNumber: DeveloperField]) -> any FieldDefinition {
        switch fieldDefinitionNumber {
        case .standard(_): return UndefinedField(globalMessageNumber: globalMessageNumber, fieldDefinitionNumber: fieldDefinitionNumber)
        case .developer(_, _):
            return developerFieldDefinitions[fieldDefinitionNumber] ?? UndefinedField(globalMessageNumber: globalMessageNumber, fieldDefinitionNumber: fieldDefinitionNumber)
        }
    }
}

internal struct FITMessageBuilder {
    public enum ParserError: Error {
        case invalidDataSize
    }

    static func buildMessage(definitionRecord: RawFITDefinitionRecord, dataRecord: RawFITDataRecord, developerFieldDefinitions: [FieldDescriptionMessage]) throws -> any FITMessage {
        let globalMessageNumber = dataRecord.globalMessageNumber
        let fields = try extractFieldValues(definitionRecord: definitionRecord, dataRecord: dataRecord, developerFieldDefinitions: developerFieldDefinitions)
        let messageType = GlobalMessageType(rawValue: globalMessageNumber)
        switch messageType {
        case .fileID: return FileIDMessage(fields: fields)
        case .fileCreator: return FileCreatorMessage(fields: fields)
        case .session: return SessionMessage(fields: fields)
        case .lap: return LapMessage(fields: fields)
        case .record: return RecordMessage(fields: fields)
        case .event: return EventMessage(fields: fields)
        case .deviceSettings: return DeviceSettingsMessage(fields: fields)
        case .deviceInfo: return DeviceInfoMessage(fields: fields)
        case .activity: return ActivityMessage(fields: fields)
        case .hrv: return HRVMessage(fields: fields)
        case .fieldDescription: return FieldDescriptionMessage(fields: fields)
        case .timeInZone: return TimeInZoneMessage(fields: fields)
        default: return UnprofiledMessage(globalMessageNumber: globalMessageNumber, fields: fields)
        }
    }

    static func extractFieldValues(definitionRecord: RawFITDefinitionRecord, dataRecord: RawFITDataRecord, developerFieldDefinitions: [FieldDescriptionMessage]) throws -> [FieldDefinitionNumber: [FITValue]] {
        var offset = 0
        let fields: [FITField] = try definitionRecord.fields.compactMap { fieldDefinition in
            let fieldSize = Int(fieldDefinition.size)
            guard dataRecord.fieldsData.count >= offset + fieldSize
            else { throw ParserError.invalidDataSize }
            // use baseType.size to determine how many values there are. eg HRV (message 78) times (field 0) contains an array of 5 values
            let valueLength = (fieldDefinition.baseType.size ?? fieldSize)
            let numValues = fieldSize / valueLength
            var values = [FITValue]()
            for _ in 0..<numValues {
                if let value = FITValue.from(
                    bytes: Array(dataRecord.fieldsData[offset..<(offset + valueLength)]),
                    baseType: fieldDefinition.baseType,
                    architecture: definitionRecord.architecture
                ) {
                    values.append(value)
                }
                offset += valueLength
            }
            guard !values.isEmpty else { return nil }
            return .init(definition: fieldDefinition, values: values)
        }

        offset = 0
        let developerFields: [FITDeveloperField] = definitionRecord.developerFields.compactMap { fieldDefinition in
            let fieldSize = Int(fieldDefinition.size)
            // if we can't find the base type, just get a big value
            //guard dataRecord.developerFieldsData.count >= (offset + fieldSize) else { return nil }
            let bytes = dataRecord.developerFieldsData[offset..<(offset + fieldSize)]

            offset += fieldSize
            let developerFieldDefinition = developerFieldDefinitions.first(where: { definitionMessage in
                guard let fieldDefinitionNumber = (definitionMessage.standardFieldValue(for: .fieldDefinitionNumber) as? IndexField.Value)?.value,
                      let developerDataIndex = (definitionMessage.standardFieldValue(for: .developerDataIndex) as? IndexField.Value)?.value
                else { return false }
                return fieldDefinitionNumber == fieldDefinition.developerFieldDefinitionNumber && developerDataIndex == fieldDefinition.developerDataIndex
            })

            let baseType: FITBaseType? = (developerFieldDefinition?.standardFieldValue(for: .fitBaseType) as? EnumField<FITBaseType>.Value)?.enumValue

            guard let value = FITValue.from(
                bytes: Array(bytes),
                baseType: baseType ?? .bytes,
                architecture: .littleEndian)
            else { return nil }
            return FITDeveloperField(
                definition: fieldDefinition,
                value: value
            )
        }

        let fieldsDict = Dictionary(fields.map { ($0.definition.fieldDefinition, $0.values )}, uniquingKeysWith: { lhs, rhs in
            return lhs + rhs
        })
        let devFieldsDict = Dictionary(developerFields.map { ($0.definition.fieldDefinition, [$0.value] )}, uniquingKeysWith: { lhs, rhs in
            return lhs + rhs
        })
        return fieldsDict.merging(devFieldsDict) { return $0 + $1 }
    }
}
