//
//  GlobalMessageType.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

enum GlobalMessageType: UInt16, CaseIterable {
    case session = 18
    case record = 20
    case activity = 34
    case hrv = 78
    case fieldDescription = 206

    var name: String {
        switch self {
        case .session: "Session"
        case .record: "Record"
        case .activity: "Activity"
        case .hrv: "HRV"
        case .fieldDescription: "Field Description"
        }
    }

    var fieldType: any StandardMessageField.Type {
        switch self {
        case .session: SessionMessage.Field.self
        case .record: RecordMessage.Field.self
        case .activity: ActivityMessage.Field.self
        case .hrv: HRVMessage.Field.self
        case .fieldDescription: FieldDescriptionMessage.Field.self
        }
    }

    var standardFields: [FieldDefinitionNumber: any FieldDefinition] {
        fieldType.standardFields
    }
}
