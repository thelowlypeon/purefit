//
//  PureFITFile.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/15/25.
//

import Foundation // only needed for URL-based init

public struct PureFITFile {
    public let header: FITHeader
    public let messages: [FITMessage]
    public let undefinedDataRecords: [RawFITDataRecord]?

    public init(url: URL) throws {
        let rawFITFile = try RawFITFile(url: url)
        try self.init(rawFITFile: rawFITFile)
    }

    public init(data: Data) throws {
        let rawFITFile = try RawFITFile(data: data)
        try self.init(rawFITFile: rawFITFile)
    }

    public init(rawFITFile: RawFITFile) throws {
        var messages = [FITMessage]()
        var definitionsByLocalMessageNumber = [UInt16: RawFITDefinitionRecord]()
        var developerFieldDefinitions = [FieldDescriptionMessage]() // TODO: index by developerDataIndex and developerFieldNumber for faster lookup
        var undefinedDataRecords = [RawFITDataRecord]()
        for (index, record) in rawFITFile.records.enumerated() {
            if #available(iOS 13.0, *), index % 100 == 0 {
                try Task.checkCancellation()
            }
            switch record {
            case .definition(let definitionRecord):
                definitionsByLocalMessageNumber[definitionRecord.localMessageNumber] = definitionRecord
            case .data(let dataRecord):
                guard let definition = definitionsByLocalMessageNumber[dataRecord.localMessageNumber]
                else {
                    undefinedDataRecords.append(dataRecord)
                    continue
                }
                let message = try FITMessageBuilder.buildMessage(
                    definitionRecord: definition,
                    dataRecord: dataRecord,
                    developerFieldDefinitions: developerFieldDefinitions
                )
                if let fieldDescriptionMessage = message as? FieldDescriptionMessage {
                    developerFieldDefinitions.append(fieldDescriptionMessage)
                }
                messages.append(message)
            }
        }

        self.header = rawFITFile.header
        self.messages = messages
        self.undefinedDataRecords = undefinedDataRecords.isEmpty ? nil : undefinedDataRecords
    }

    public var fieldDefinitions: [FITGlobalMessageNumber: [FieldDefinitionNumber: any FieldDefinition]] {
        let developerFields = developerFields
        var viewedFields = [FITGlobalMessageNumber: [FieldDefinitionNumber: any FieldDefinition]]()
        for message in messages {
            for fieldDefinitionNumber in message.fields.keys {
                // remember, the value may be nil if we have no definition.
                // and there's no use in checking for a definition for each message if we don't have one for the first
                if viewedFields[message.globalMessageNumber]?.index(forKey: fieldDefinitionNumber) == nil {
                    viewedFields[message.globalMessageNumber, default: [:]][fieldDefinitionNumber] = message.fieldDefinition(for: fieldDefinitionNumber, developerFieldDefinitions: developerFields)
                }
            }
        }
        return viewedFields
    }

    public var developerFields: [FieldDefinitionNumber: DeveloperField] {
        // NOTE: this might need to be scoped by an optional message number. i *think* fields can be defined globally or scoped within a global message number
        var developerFields = [FieldDefinitionNumber: DeveloperField]()
        for message in messages {
            if let fieldDescriptionMessage = message as? FieldDescriptionMessage, let field = DeveloperField(fieldDescriptionMessage: fieldDescriptionMessage) {
                developerFields[field.fieldDefinitionNumber] = field
            }
        }
        return developerFields
    }
}
extension PureFITFile: Sendable {}
