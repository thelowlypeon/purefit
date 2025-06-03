//
//  LapMessage.swift
//  PureFIT
//
//  Created by Peter Compernolle on 5/29/25.
//

public struct LapMessage: ProfiledMessage {
    public let globalMessageType: GlobalMessageType = .lap
    public let fields: [FieldDefinitionNumber : [FITValue]]

    public enum Field: UInt8, CaseIterable, StandardMessageField, FieldDefinitionProviding {
        case startTime = 2
        case averageTemperature = 50
        case timestamp = 253
        case messageIndex = 254

        public var fieldDefinition: any FieldDefinition {
            switch self {
            case .startTime: DateField(name: "Start Time", style: .time)
            case .averageTemperature: TemperatureField(name: "Average Temperature", baseType: .sint8, unit: .celsius, scale: 1, offset: 0)
            case .timestamp: DateField(name: "Timestamp", style: .time)
            case .messageIndex: IndexField(name: "Message Index", baseType: .uint16)
            }
        }
    }
}
