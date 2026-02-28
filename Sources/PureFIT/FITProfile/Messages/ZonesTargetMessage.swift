//
//  ZonesTargetMessage.swift
//  PureFIT
//
//  Created by Peter Compernolle on 2/28/26.
//

public struct ZonesTargetMessage: ProfiledMessage {
    public let globalMessageType: GlobalMessageType = .zonesTarget
    public let fields: [FieldDefinitionNumber : [FITValue]]

    public enum Field: UInt8, CaseIterable, StandardMessageField, FieldDefinitionProviding {
        case maxHeartRate = 1
        case thresholdHeartRate = 2
        case functionalThresholdPower = 3
        case hrCalcType = 5
        case pwrCalcType = 7

        public var fieldDefinition: any FieldDefinition {
            switch self {
            case .maxHeartRate: IntegerField(name: "Max Heart Rate", baseType: .uint8, unitSymbol: "bpm")
            case .thresholdHeartRate: IntegerField(name: "Threshold Heart Rate", baseType: .uint8, unitSymbol: "bpm")
            case .functionalThresholdPower: PowerField(name: "Functional Threshold Power", baseType: .uint16, scale: 1, offset: 0)
            case .hrCalcType: EnumField<HrZoneCalc>(name: "HR Calc Type", baseType: .enum, enumType: .custom)
            case .pwrCalcType: EnumField<PwrZoneCalc>(name: "Power Calc Type", baseType: .enum, enumType: .custom)
            }
        }
    }
}

