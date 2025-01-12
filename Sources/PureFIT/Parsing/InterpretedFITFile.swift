//
//  FITParsedFile.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/11/25.
//

import Foundation

public struct InterpretedFITFile {
    public let header: FITHeader
    public let messages: [FITGlobalMessageNumber: [InterpretedFITMessage]]

    public init(fitFile: FITFile) {
        var messages = [InterpretedFITMessage]()
        var definitionsByMessageNumber = [FITGlobalMessageNumber: FITDefinitionRecord]()
        var developerFieldDefinitions = [FITFieldDefinitionNumber: InterpretedFITMessage]()
        for record in fitFile.records {
            switch record {
            case .definition(let definitionRecord):
                definitionsByMessageNumber[definitionRecord.globalMessageNumber] = definitionRecord
            case .data(let dataRecord):
                guard let definition = definitionsByMessageNumber[dataRecord.globalMessageNumber]
                else {
                    print("No definition record found for \(dataRecord.globalMessageNumber)")
                    continue
                }
                let message = InterpretedFITMessage(
                    dataRecord: dataRecord,
                    definitionRecord: definition,
                    developerFieldDefinitions: developerFieldDefinitions
                )
                if dataRecord.globalMessageNumber == 206,
                   case .uint8(let fieldDefinitionNumber) = message.fields[1] {
                    developerFieldDefinitions[fieldDefinitionNumber] = message
                }
                messages.append(message)
            }
        }

        self.header = fitFile.header
        self.messages = Dictionary(grouping: messages, by: { $0.globalMessageNumber })
    }
}
