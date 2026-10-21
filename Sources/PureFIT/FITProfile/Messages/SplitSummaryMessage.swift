//
//  SplitSummaryMessage.swift
//  PureFIT
//

public struct SplitSummaryMessage: ProfiledMessage {
    public let globalMessageType: GlobalMessageType = .splitSummary
    public let fields: [FieldDefinitionNumber : [FITValue]]

    public enum Field: UInt8, CaseIterable, StandardMessageField, FieldDefinitionProviding {
        case messageIndex = 254
        case timestamp = 253
        case splitType = 0
        case sport = 1
        case subSport = 2
        case numSplits = 3
        case totalTimerTime = 4
        case totalDistance = 5
        case avgSpeed = 6
        case maxSpeed = 7
        case totalAscent = 8
        case totalDescent = 9
        case avgHeartRate = 10
        case maxHeartRate = 11
        case avgVertSpeed = 12
        case totalCalories = 13
        case avgCadence = 14
        case maxCadence = 15
        case totalCycles = 16
        case avgTemperature = 17
        case maxTemperature = 18
        case minTemperature = 19
        case avgVerticalOscillation = 20
        case avgVerticalRatio = 21
        case avgStanceTime = 22
        case avgStanceTimeBalance = 23
        case avgStepLength = 24
        case avgPower = 25
        case maxPower = 26
        case normalizedPower = 27
        case leftRightBalance = 28
        case timeStanding = 29
        case avgLeftPco = 30
        case avgRightPco = 31
        case avgLeftPowerPhase = 32
        case avgLeftPowerPhasePeak = 33
        case avgRightPowerPhase = 34
        case avgRightPowerPhasePeak = 35
        case avgPowerPosition = 36
        case maxPowerPosition = 37
        case avgLeftTorqueEffectiveness = 38
        case avgRightTorqueEffectiveness = 39
        case avgLeftPedalSmoothness = 40
        case avgRightPedalSmoothness = 41
        case avgCombinedPedalSmoothness = 42
        case avgFlow = 43
        case totalGrit = 44
        case swimStroke = 47
        case numActiveLengths = 48
        case avgSwolf = 49
        case avgStrokeDistance = 50
        case avgStrokesPerLength = 51
        case avgAscent = 52
        case maxAscent = 53
        case climbGradingScale = 54
        case climbMaxGradeValue = 55
        case numFalls = 56
        case numClimbsAttempted = 58
        case numClimbsCompleted = 59
        case maxDistance = 60
        case metabolicCalories = 64
        case activeTime = 65
        case totalFractionalAscent = 66
        case totalFractionalDescent = 67
        case avgFractionalAscent = 68
        case maxFractionalAscent = 69
        case avgGradeAdjustedSpeed = 71
        case avgStress = 72
        case totalMovingTime = 77
        case startTime = 79
        case minHeartRate = 87
        case avgStanceTimePercent = 91
        case maxTotalTimerTime = 101

        public var fieldDefinition: any FieldDefinition {
            switch self {
            case .messageIndex: CompositeField<MessageIndex>(name: "Message Index", baseType: .uint16)
            case .timestamp: DateField(name: "Timestamp")
            case .splitType: EnumField<SplitType>(name: "Split Type", baseType: .enum, enumType: .ascentSplit)
            case .sport: EnumField<Sport>(name: "Sport", baseType: .enum, enumType: .all)
            case .subSport: EnumField<SubSport>(name: "Sub Sport", baseType: .enum, enumType: .all)
            case .numSplits: IntegerField(name: "Number of Splits", baseType: .uint16)
            case .totalTimerTime: DurationField(name: "Total Timer Time", baseType: .uint32, unit: .seconds, scale: 1000, offset: 0)
            case .totalDistance: DistanceField(name: "Total Distance", baseType: .uint32, unit: .meters, scale: 100, offset: 0)
            case .avgSpeed: SpeedField(name: "Average Speed", baseType: .uint32, unit: .metersPerSecond, scale: 1000, offset: 0)
            case .maxSpeed: SpeedField(name: "Max Speed", baseType: .uint32, unit: .metersPerSecond, scale: 1000, offset: 0)
            case .totalAscent: DistanceField(name: "Total Ascent", baseType: .uint16, unit: .meters, scale: 1, offset: 0)
            case .totalDescent: DistanceField(name: "Total Descent", baseType: .uint16, unit: .meters, scale: 1, offset: 0)
            case .avgHeartRate: IntegerField(name: "Average Heart Rate", baseType: .uint8, unitSymbol: "bpm")
            case .maxHeartRate: IntegerField(name: "Max Heart Rate", baseType: .uint8, unitSymbol: "bpm")
            case .avgVertSpeed: SpeedField(name: "Average Vertical Speed", baseType: .sint32, unit: .metersPerSecond, scale: 1000, offset: 0)
            case .totalCalories: EnergyField(name: "Total Calories", baseType: .uint32, unit: .kilocalories, scale: 1, offset: 0)
            case .avgCadence: DoubleField(name: "Average Cadence", baseType: .uint16, unitSymbol: "rpm", scale: 128)
            case .maxCadence: DoubleField(name: "Max Cadence", baseType: .uint16, unitSymbol: "rpm", scale: 128)
            case .totalCycles: IntegerField(name: "Total Cycles", baseType: .uint32, unitSymbol: "cycles")
            case .avgTemperature: TemperatureField(name: "Average Temperature", baseType: .sint8, unit: .celsius, scale: 1, offset: 0)
            case .maxTemperature: TemperatureField(name: "Max Temperature", baseType: .sint8, unit: .celsius, scale: 1, offset: 0)
            case .minTemperature: TemperatureField(name: "Min Temperature", baseType: .sint8, unit: .celsius, scale: 1, offset: 0)
            case .avgVerticalOscillation: DistanceField(name: "Average Vertical Oscillation", baseType: .uint16, unit: .millimeters, scale: 10, offset: 0)
            case .avgVerticalRatio: DoubleField(name: "Average Vertical Ratio", baseType: .uint16, unitSymbol: "%", scale: 100)
            case .avgStanceTime: if #available(iOS 13.0, macOS 10.15, *) {
                DurationField(name: "Average Stance Time", baseType: .uint16, unit: .milliseconds, scale: 10, offset: 0)
            } else {
                DurationField(name: "Average Stance Time", baseType: .uint16, unit: .seconds, scale: 10000, offset: 0)
            }
            case .avgStanceTimeBalance: DoubleField(name: "Average Stance Time Balance", baseType: .uint16, unitSymbol: "%", scale: 100)
            case .avgStepLength: DistanceField(name: "Average Step Length", baseType: .uint16, unit: .millimeters, scale: 10, offset: 0)
            case .avgPower: PowerField(name: "Average Power", baseType: .uint16, scale: 1, offset: 0)
            case .maxPower: PowerField(name: "Max Power", baseType: .uint16, scale: 1, offset: 0)
            case .normalizedPower: PowerField(name: "Normalized Power", baseType: .uint16, scale: 1, offset: 0)
            case .leftRightBalance: CompositeField<LeftRightBalance100>(name: "Left/Right Balance", baseType: .uint16)
            case .timeStanding: DurationField(name: "Time Standing", baseType: .uint32, unit: .seconds, scale: 1000, offset: 0)
            case .avgLeftPco: DistanceField(name: "Average Left PCO", baseType: .sint8, unit: .millimeters, scale: 1, offset: 0)
            case .avgRightPco: DistanceField(name: "Average Right PCO", baseType: .sint8, unit: .millimeters, scale: 1, offset: 0)
            case .avgLeftPowerPhase: MultipleValueField(singleFieldDefinition: DoubleField(name: "Average Left Power Phase", baseType: .uint8, unitSymbol: "°", scale: 0.7111111))
            case .avgLeftPowerPhasePeak: MultipleValueField(singleFieldDefinition: DoubleField(name: "Average Left Power Phase Peak", baseType: .uint8, unitSymbol: "°", scale: 0.7111111))
            case .avgRightPowerPhase: MultipleValueField(singleFieldDefinition: DoubleField(name: "Average Right Power Phase", baseType: .uint8, unitSymbol: "°", scale: 0.7111111))
            case .avgRightPowerPhasePeak: MultipleValueField(singleFieldDefinition: DoubleField(name: "Average Right Power Phase Peak", baseType: .uint8, unitSymbol: "°", scale: 0.7111111))
            case .avgPowerPosition: MultipleValueField(singleFieldDefinition: PowerField(name: "Average Power Position", baseType: .uint16, scale: 1, offset: 0))
            case .maxPowerPosition: MultipleValueField(singleFieldDefinition: PowerField(name: "Max Power Position", baseType: .uint16, scale: 1, offset: 0))
            case .avgLeftTorqueEffectiveness: DoubleField(name: "Average Left Torque Effectiveness", baseType: .uint8, unitSymbol: "%", scale: 2)
            case .avgRightTorqueEffectiveness: DoubleField(name: "Average Right Torque Effectiveness", baseType: .uint8, unitSymbol: "%", scale: 2)
            case .avgLeftPedalSmoothness: DoubleField(name: "Average Left Pedal Smoothness", baseType: .uint8, unitSymbol: "%", scale: 2)
            case .avgRightPedalSmoothness: DoubleField(name: "Average Right Pedal Smoothness", baseType: .uint8, unitSymbol: "%", scale: 2)
            case .avgCombinedPedalSmoothness: DoubleField(name: "Average Combined Pedal Smoothness", baseType: .uint8, unitSymbol: "%", scale: 2)
            case .avgFlow: DoubleField(name: "Average Flow", baseType: .float32, scale: 1)
            case .totalGrit: DoubleField(name: "Total Grit", baseType: .float32, unitSymbol: "kGrit", scale: 1)
            case .swimStroke: EnumField<SwimStroke>(name: "Swim Stroke", baseType: .enum, enumType: .freestyle)
            case .numActiveLengths: IntegerField(name: "Number of Active Lengths", baseType: .uint16, unitSymbol: "lengths")
            case .avgSwolf: IntegerField(name: "Average SWOLF", baseType: .uint16)
            case .avgStrokeDistance: DistanceField(name: "Average Stroke Distance", baseType: .uint16, unit: .meters, scale: 100, offset: 0)
            case .avgStrokesPerLength: DoubleField(name: "Average Strokes Per Length", baseType: .uint16, unitSymbol: "strokes / length", scale: 10)
            case .avgAscent: DistanceField(name: "Average Ascent", baseType: .uint16, unit: .meters, scale: 1, offset: 0)
            case .maxAscent: DistanceField(name: "Max Ascent", baseType: .uint16, unit: .meters, scale: 1, offset: 0)
            case .climbGradingScale: EnumField<ClimbGradingScale>(name: "Climb Grading Scale", baseType: .enum, enumType: .yds)
            case .climbMaxGradeValue: IntegerField(name: "Climb Max Grade Value", baseType: .uint32)
            case .numFalls: IntegerField(name: "Number of Falls", baseType: .uint16)
            case .numClimbsAttempted: IntegerField(name: "Number of Climbs Attempted", baseType: .uint16)
            case .numClimbsCompleted: IntegerField(name: "Number of Climbs Completed", baseType: .uint16)
            case .maxDistance: DistanceField(name: "Max Distance", baseType: .uint32, unit: .meters, scale: 100, offset: 0)
            case .metabolicCalories: EnergyField(name: "Metabolic Calories", baseType: .uint16, unit: .kilocalories, scale: 1, offset: 0)
            case .activeTime: DurationField(name: "Active Time", baseType: .uint32, unit: .seconds, scale: 1000, offset: 0)
            case .totalFractionalAscent: DistanceField(name: "Total Fractional Ascent", baseType: .uint8, unit: .meters, scale: 100, offset: 0)
            case .totalFractionalDescent: DistanceField(name: "Total Fractional Descent", baseType: .uint8, unit: .meters, scale: 100, offset: 0)
            case .avgFractionalAscent: DistanceField(name: "Average Fractional Ascent", baseType: .uint8, unit: .meters, scale: 100, offset: 0)
            case .maxFractionalAscent: DistanceField(name: "Max Fractional Ascent", baseType: .uint8, unit: .meters, scale: 100, offset: 0)
            case .avgGradeAdjustedSpeed: SpeedField(name: "Average Grade Adjusted Speed", baseType: .uint32, unit: .metersPerSecond, scale: 1000, offset: 0)
            case .avgStress: IntegerField(name: "Average Stress", baseType: .uint16)
            case .totalMovingTime: DurationField(name: "Total Moving Time", baseType: .uint32, unit: .seconds, scale: 1000, offset: 0)
            case .startTime: DateField(name: "Start Time")
            case .minHeartRate: IntegerField(name: "Min Heart Rate", baseType: .uint8, unitSymbol: "bpm")
            case .avgStanceTimePercent: DoubleField(name: "Average Stance Time Percent", baseType: .uint16, unitSymbol: "%", scale: 100)
            case .maxTotalTimerTime: DurationField(name: "Max Total Timer Time", baseType: .uint32, unit: .seconds, scale: 1000, offset: 0)
            }
        }
    }
}
