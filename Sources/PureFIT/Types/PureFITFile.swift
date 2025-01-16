//
//  PureFITFile.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/15/25.
//

public struct PureFITFile {
    public let header: FITHeader
    public let messages: [FITMessage]
    public let undefinedDataRecords: [RawFITDataRecord]?

    public init(rawFITFile: RawFITFile) {
        var messages = [FITMessage]()
        var definitionsByMessageNumber = [FITGlobalMessageNumber: RawFITDefinitionRecord]()
        var developerFieldDefinitions = [FITMessage]() // TODO: index by developerDataIndex and developerFieldNumber for faster lookup
        var undefinedDataRecords = [RawFITDataRecord]()
        for record in rawFITFile.records {
            switch record {
            case .definition(let definitionRecord):
                definitionsByMessageNumber[definitionRecord.globalMessageNumber] = definitionRecord
            case .data(let dataRecord):
                guard let definition = definitionsByMessageNumber[dataRecord.globalMessageNumber]
                else {
                    undefinedDataRecords.append(dataRecord)
                    continue
                }
                let message = FITMessage(
                    definitionRecord: definition,
                    dataRecord: dataRecord,
                    developerFieldDefinitions: developerFieldDefinitions
                )
                if definition.globalMessageNumber == 206 {
                    developerFieldDefinitions.append(message)
                }
                messages.append(message)
            }
        }

        self.header = rawFITFile.header
        self.messages = messages
        self.undefinedDataRecords = undefinedDataRecords.isEmpty ? nil : undefinedDataRecords
    }
}
