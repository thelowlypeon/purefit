//
//  TimeInZoneMessage.swift
//  PureFIT
//
//  Created by Peter Compernolle on 6/1/25.
//

public struct TimeInZoneMessage: ProfiledMessage {
    public let globalMessageType: GlobalMessageType = .timeInZone
    public let fields: [FieldDefinitionNumber : [FITValue]]

    public enum Field: UInt8, CaseIterable, StandardMessageField, FieldDefinitionProviding {
        case referenceMessage = 0
        case referenceIndex = 1
        case timeInHRZone = 2
        case timeInSpeedZone = 3
        case timeInCadenceZone = 4
        case timeInPowerZone = 5
        case maxHeartRate = 11
        case restingHeartRate = 12
        case thresholdHeartRate = 13
        case funtionalThresholdPower = 15
        case timestamp = 253

        public var fieldDefinition: any FieldDefinition {
            switch self {
            case .referenceMessage: EnumField<GlobalMessageType>(name: "Reference Message", baseType: .uint16, enumType: .session)
            case .referenceIndex: IndexField(name: "Reference Index", baseType: .uint16)
            case .timeInHRZone: MultipleValueField(singleFieldDefinition: DurationField(name: "Time in HR Zone", baseType: .uint32, unit: .seconds, scale: 1000, offset: 0))
            case .timeInSpeedZone: MultipleValueField(singleFieldDefinition: DurationField(name: "Time in Speed Zone", baseType: .uint32, unit: .seconds, scale: 1000, offset: 0))
            case .timeInCadenceZone: MultipleValueField(singleFieldDefinition: DurationField(name: "Time in Cadence Zone", baseType: .uint32, unit: .seconds, scale: 1000, offset: 0))
            case .timeInPowerZone: MultipleValueField(singleFieldDefinition: DurationField(name: "Time in Power Zone", baseType: .uint32, unit: .seconds, scale: 1000, offset: 0))
            case .maxHeartRate: IntegerField(name: "Max Heart Rate", baseType: .uint8, unitSymbol: "bpm")
            case .restingHeartRate: IntegerField(name: "Resting Heart Rate", baseType: .uint8, unitSymbol: "bpm")
            case .thresholdHeartRate: IntegerField(name: "Threshold Heart Rate", baseType: .uint8, unitSymbol: "bpm")
            case .funtionalThresholdPower: PowerField(name: "Functional Threshold Power", baseType: .uint16, scale: 1, offset: 0)
            case .timestamp: DateField(name: "Timestamp")
            }
        }
    }
}
