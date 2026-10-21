//
//  DiveSummaryMessage.swift
//  PureFIT
//

public struct DiveSummaryMessage: ProfiledMessage {
    public let globalMessageType: GlobalMessageType = .diveSummary
    public let fields: [FieldDefinitionNumber : [FITValue]]

    public enum Field: UInt8, CaseIterable, StandardMessageField, FieldDefinitionProviding {
        case timestamp = 253
        case referenceMesg = 0
        case referenceIndex = 1
        case avgDepth = 2
        case maxDepth = 3
        case surfaceInterval = 4
        case startCns = 5
        case endCns = 6
        case startN2 = 7
        case endN2 = 8
        case o2Toxicity = 9
        case diveNumber = 10
        case bottomTime = 11
        case avgPressureSac = 12
        case avgVolumeSac = 13
        case avgRmv = 14
        case descentTime = 15
        case ascentTime = 16
        case avgAscentRate = 17
        case avgDescentRate = 22
        case maxAscentRate = 23
        case maxDescentRate = 24
        case hangTime = 25

        public var fieldDefinition: any FieldDefinition {
            switch self {
            case .timestamp: DateField(name: "Timestamp")
            case .referenceMesg: EnumField<GlobalMessageType>(name: "Reference Message", baseType: .uint16, enumType: .fileID)
            case .referenceIndex: CompositeField<MessageIndex>(name: "Reference Index", baseType: .uint16)
            case .avgDepth: DistanceField(name: "Average Depth", baseType: .uint32, unit: .meters, scale: 1000, offset: 0)
            case .maxDepth: DistanceField(name: "Max Depth", baseType: .uint32, unit: .meters, scale: 1000, offset: 0)
            case .surfaceInterval: DurationField(name: "Surface Interval", baseType: .uint32, unit: .seconds, scale: 1, offset: 0)
            case .startCns: IntegerField(name: "Start CNS", baseType: .uint8, unitSymbol: "%")
            case .endCns: IntegerField(name: "End CNS", baseType: .uint8, unitSymbol: "%")
            case .startN2: IntegerField(name: "Start N2", baseType: .uint16, unitSymbol: "%")
            case .endN2: IntegerField(name: "End N2", baseType: .uint16, unitSymbol: "%")
            case .o2Toxicity: IntegerField(name: "O2 Toxicity", baseType: .uint16, unitSymbol: "OTUs")
            case .diveNumber: IntegerField(name: "Dive Number", baseType: .uint32)
            case .bottomTime: DurationField(name: "Bottom Time", baseType: .uint32, unit: .seconds, scale: 1000, offset: 0)
            case .avgPressureSac: DoubleField(name: "Average Pressure SAC", baseType: .uint16, unitSymbol: "bar/min", scale: 100)
            case .avgVolumeSac: DoubleField(name: "Average Volume SAC", baseType: .uint16, unitSymbol: "L/min", scale: 100)
            case .avgRmv: DoubleField(name: "Average RMV", baseType: .uint16, unitSymbol: "L/min", scale: 100)
            case .descentTime: DurationField(name: "Descent Time", baseType: .uint32, unit: .seconds, scale: 1000, offset: 0)
            case .ascentTime: DurationField(name: "Ascent Time", baseType: .uint32, unit: .seconds, scale: 1000, offset: 0)
            case .avgAscentRate: SpeedField(name: "Average Ascent Rate", baseType: .sint32, unit: .metersPerSecond, scale: 1000, offset: 0)
            case .avgDescentRate: SpeedField(name: "Average Descent Rate", baseType: .uint32, unit: .metersPerSecond, scale: 1000, offset: 0)
            case .maxAscentRate: SpeedField(name: "Max Ascent Rate", baseType: .uint32, unit: .metersPerSecond, scale: 1000, offset: 0)
            case .maxDescentRate: SpeedField(name: "Max Descent Rate", baseType: .uint32, unit: .metersPerSecond, scale: 1000, offset: 0)
            case .hangTime: DurationField(name: "Hang Time", baseType: .uint32, unit: .seconds, scale: 1000, offset: 0)
            }
        }
    }
}
