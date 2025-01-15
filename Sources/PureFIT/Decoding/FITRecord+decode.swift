//
//  FITRecord+decode.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/11/25.
//

import Foundation

extension FITRecord {
    public enum DecodeError: Error {
        case recordLengthError, definitionLengthError, definitionNotFound, dataLengthError
    }

    internal init(data: Data, offset: inout Int, definitions: inout [UInt16: FITDefinitionRecord]) throws {
        guard offset < data.count else { throw DecodeError.recordLengthError }

        let header = data[offset]
        let localMessageNumber = UInt16(header & 0x0F)
        let isCompressedHeader = (header & 0x80) != 0
        //print("isCompressedHeader ? \(isCompressedHeader)")
        // TODO: compressedHeaders require different parsing
        let hasDeveloperData = header & 0x20 != 0
        offset += 1

        if header & 0x40 == 0x40 {
            // Definition record
            guard offset + 5 <= data.count else { throw DecodeError.definitionLengthError }

            let _ = data[offset] // reserved
            let architecture: FITArchitecture = data[offset + 1] == 0 ? .littleEndian : .bigEndian
            let globalMessageNumber: UInt16
            switch architecture {
            case .littleEndian:
                globalMessageNumber = UInt16(data[offset + 2]) | (UInt16(data[offset + 3]) << 8)
            case .bigEndian:
                globalMessageNumber = (UInt16(data[offset + 2]) << 8) | UInt16(data[offset + 3])
            }
            let fieldCount = data[offset + 4]
            offset += 5

            var fields: [FITFieldDefinition] = []
            for _ in 0..<fieldCount {
                guard offset + 3 <= data.count else { throw DecodeError.definitionLengthError }
                let fieldDefinitionNumber = data[offset]
                let size = data[offset + 1]
                let baseType = data[offset + 2]
                fields.append(.init(
                    fieldDefinitionNumber: fieldDefinitionNumber,
                    size: size,
                    baseType: baseType
                ))
                offset += 3
            }

            var developerFields: [FITDeveloperFieldDefinition] = []
            if hasDeveloperData {
                guard offset < data.count else { throw DecodeError.definitionLengthError }
                let developerFieldCount = data[offset]
                offset += 1

                for _ in 0..<developerFieldCount {
                    guard offset + 3 <= data.count else { throw DecodeError.definitionLengthError }
                    let developerFieldDefinitionNumber = data[offset]
                    let size = data[offset + 1]
                    let developerDataIndex = data[offset + 2]
                    developerFields.append(.init(
                        developerFieldDefinitionNumber: developerFieldDefinitionNumber,
                        size: size,
                        developerDataIndex: developerDataIndex
                    ))
                    offset += 3
                }
            }

            let definition = FITDefinitionRecord(
                architecture: architecture,
                globalMessageNumber: globalMessageNumber,
                fieldCount: fieldCount,
                fields: fields,
                developerFields: developerFields
            )
            // important! this may overwrite past definitions because local message definitions can change
            // for example, it might re-use index 0 for messages it knows will not re-appear, like fileId
            definitions[localMessageNumber] = definition
            self = .definition(definition)
            return
        }

        // Data record
        guard let definition = definitions[localMessageNumber] else { throw DecodeError.definitionNotFound }

        let fieldSize = definition.fields.reduce(0) { $0 + Int($1.size) }
        guard offset + fieldSize <= data.count else { throw DecodeError.dataLengthError }

        let fieldData = Array(data[offset..<(offset + fieldSize)])
        offset += fieldSize

        let developerFieldSize = definition.developerFields.reduce(0) { $0 + Int($1.size) }
        guard offset + developerFieldSize <= data.count else { throw DecodeError.dataLengthError }

        let developerFieldsData = Array(data[offset..<(offset + developerFieldSize)])
        offset += developerFieldSize

        self = .data(FITDataRecord(
            globalMessageNumber: definition.globalMessageNumber,
            fieldsData: fieldData,
            developerFieldsData: developerFieldsData
        ))
    }
}
