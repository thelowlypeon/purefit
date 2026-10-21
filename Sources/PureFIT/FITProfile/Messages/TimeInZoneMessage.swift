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
        case hrZoneHighBoundary = 6
        case speedZoneHighBoundary = 7
        case cadenceZoneHighBoundary = 8
        case powerZoneHighBoundary = 9
        case hrCalcType = 10
        case maxHeartRate = 11
        case restingHeartRate = 12
        case thresholdHeartRate = 13
        case pwrCalcType = 14
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
            case .hrZoneHighBoundary: MultipleValueField(singleFieldDefinition: IntegerField(name: "HR Zone High Boundary", baseType: .uint8, unitSymbol: "bpm"))
            case .speedZoneHighBoundary: MultipleValueField(singleFieldDefinition: SpeedField(name: "Speed Zone High Boundary", baseType: .uint16, unit: .metersPerSecond, scale: 1000, offset: 0))
            case .cadenceZoneHighBoundary: MultipleValueField(singleFieldDefinition: IntegerField(name: "Cadence Zone High Boundary", baseType: .uint8, unitSymbol: "rpm"))
            case .powerZoneHighBoundary: MultipleValueField(singleFieldDefinition: PowerField(name: "Power Zone High Boundary", baseType: .uint16, scale: 1, offset: 0))
            case .hrCalcType: EnumField<HrZoneCalc>(name: "HR Calc Type", baseType: .enum, enumType: .custom)
            case .maxHeartRate: IntegerField(name: "Max Heart Rate", baseType: .uint8, unitSymbol: "bpm")
            case .restingHeartRate: IntegerField(name: "Resting Heart Rate", baseType: .uint8, unitSymbol: "bpm")
            case .thresholdHeartRate: IntegerField(name: "Threshold Heart Rate", baseType: .uint8, unitSymbol: "bpm")
            case .pwrCalcType: EnumField<PwrZoneCalc>(name: "Power Calc Type", baseType: .enum, enumType: .custom)
            case .funtionalThresholdPower: PowerField(name: "Functional Threshold Power", baseType: .uint16, scale: 1, offset: 0)
            case .timestamp: DateField(name: "Timestamp")
            }
        }
    }
}
