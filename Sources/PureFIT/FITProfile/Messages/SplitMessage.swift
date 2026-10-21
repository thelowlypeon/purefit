//
//  SplitMessage.swift
//  PureFIT
//

public struct SplitMessage: ProfiledMessage {
    public let globalMessageType: GlobalMessageType = .split
    public let fields: [FieldDefinitionNumber : [FITValue]]

    public enum Field: UInt8, CaseIterable, StandardMessageField, FieldDefinitionProviding {
        case messageIndex = 254
        case timestamp = 253
        case splitType = 0
        case totalElapsedTime = 1
        case totalTimerTime = 2
        case totalDistance = 3
        case avgSpeed = 4
        case startTime = 9
        case sport = 11
        case subSport = 12
        case totalAscent = 13
        case totalDescent = 14
        case avgHeartRate = 15
        case maxHeartRate = 16
        case necLat = 17
        case necLong = 18
        case swcLat = 19
        case swcLong = 20
        case startPositionLat = 21
        case startPositionLong = 22
        case endPositionLat = 23
        case endPositionLong = 24
        case maxSpeed = 25
        case avgVertSpeed = 26
        case endTime = 27
        case totalCalories = 28
        case avgCadence = 29
        case maxCadence = 30
        case totalCycles = 31
        case avgTemperature = 32
        case maxTemperature = 33
        case minTemperature = 34
        case avgVerticalOscillation = 35
        case avgVerticalRatio = 36
        case avgStanceTime = 37
        case avgStanceTimeBalance = 38
        case avgStepLength = 39
        case avgPower = 40
        case maxPower = 41
        case normalizedPower = 42
        case leftRightBalance = 43
        case timeStanding = 44
        case avgLeftPco = 45
        case avgRightPco = 46
        case avgLeftPowerPhase = 47
        case avgLeftPowerPhasePeak = 48
        case avgRightPowerPhase = 49
        case avgRightPowerPhasePeak = 50
        case avgPowerPosition = 51
        case maxPowerPosition = 52
        case avgLeftTorqueEffectiveness = 53
        case avgRightTorqueEffectiveness = 54
        case avgLeftPedalSmoothness = 55
        case avgRightPedalSmoothness = 56
        case avgCombinedPedalSmoothness = 57
        case avgFlow = 58
        case totalGrit = 59
        case swimStroke = 62
        case numActiveLengths = 63
        case avgSwolf = 64
        case avgStrokeDistance = 65
        case avgStrokesPerLength = 66
        case firstLapIndex = 67
        case numLaps = 68
        case climbGradingScale = 69
        case climbGradeValue = 70
        case status = 71
        case numFalls = 72
        case climbSend = 73
        case startElevation = 74
        case activeTime = 78
        case metabolicCalories = 79
        case totalFractionalAscent = 80
        case totalFractionalDescent = 81
        case avgGrade = 88
        case maxGrade = 89
        case minCadence = 90
        case avgGradeAdjustedSpeed = 93
        case avgStress = 94
        case avgVam = 99
        case jumpCount = 104
        case totalMovingTime = 110
        case diveSectionType = 112
        case avgAscentRate = 113
        case maxAscentRate = 114
        case avgDescentRate = 115
        case maxDescentRate = 116
        case totalAscentTime = 117
        case totalDescentTime = 118
        case totalHangTime = 119
        case apneaDiscipline = 120
        case avgDepth = 121
        case maxDepth = 122
        case minHeartRate = 124
        case surfaceInterval = 127
        case totalFractionalCycles = 142
        case avgStanceTimePercent = 144
        case totalAnaerobicTrainingEffect = 168
        case frontGearShiftCount = 169
        case rearGearShiftCount = 170

        public var fieldDefinition: any FieldDefinition {
            switch self {
            case .messageIndex: CompositeField<MessageIndex>(name: "Message Index", baseType: .uint16)
            case .timestamp: DateField(name: "Timestamp")
            case .splitType: EnumField<SplitType>(name: "Split Type", baseType: .enum, enumType: .ascentSplit)
            case .totalElapsedTime: DurationField(name: "Total Elapsed Time", baseType: .uint32, unit: .seconds, scale: 1000, offset: 0)
            case .totalTimerTime: DurationField(name: "Total Timer Time", baseType: .uint32, unit: .seconds, scale: 1000, offset: 0)
            case .totalDistance: DistanceField(name: "Total Distance", baseType: .uint32, unit: .meters, scale: 100, offset: 0)
            case .avgSpeed: SpeedField(name: "Average Speed", baseType: .uint32, unit: .metersPerSecond, scale: 1000, offset: 0)
            case .startTime: DateField(name: "Start Time")
            case .sport: EnumField<Sport>(name: "Sport", baseType: .enum, enumType: .all)
            case .subSport: EnumField<SubSport>(name: "Sub Sport", baseType: .enum, enumType: .all)
            case .totalAscent: DistanceField(name: "Total Ascent", baseType: .uint16, unit: .meters, scale: 1, offset: 0)
            case .totalDescent: DistanceField(name: "Total Descent", baseType: .uint16, unit: .meters, scale: 1, offset: 0)
            case .avgHeartRate: IntegerField(name: "Average Heart Rate", baseType: .uint8, unitSymbol: "bpm")
            case .maxHeartRate: IntegerField(name: "Max Heart Rate", baseType: .uint8, unitSymbol: "bpm")
            case .necLat: AngleField(name: "Northeast Corner Latitude", baseType: .sint32, scale: 1, offset: 0)
            case .necLong: AngleField(name: "Northeast Corner Longitude", baseType: .sint32, scale: 1, offset: 0)
            case .swcLat: AngleField(name: "Southwest Corner Latitude", baseType: .sint32, scale: 1, offset: 0)
            case .swcLong: AngleField(name: "Southwest Corner Longitude", baseType: .sint32, scale: 1, offset: 0)
            case .startPositionLat: AngleField(name: "Start Position Latitude", baseType: .sint32, scale: 1, offset: 0)
            case .startPositionLong: AngleField(name: "Start Position Longitude", baseType: .sint32, scale: 1, offset: 0)
            case .endPositionLat: AngleField(name: "End Position Latitude", baseType: .sint32, scale: 1, offset: 0)
            case .endPositionLong: AngleField(name: "End Position Longitude", baseType: .sint32, scale: 1, offset: 0)
            case .maxSpeed: SpeedField(name: "Max Speed", baseType: .uint32, unit: .metersPerSecond, scale: 1000, offset: 0)
            case .avgVertSpeed: SpeedField(name: "Average Vertical Speed", baseType: .sint32, unit: .metersPerSecond, scale: 1000, offset: 0)
            case .endTime: DateField(name: "End Time")
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
            case .firstLapIndex: IntegerField(name: "First Lap Index", baseType: .uint16)
            case .numLaps: IntegerField(name: "Number of Laps", baseType: .uint16)
            case .climbGradingScale: EnumField<ClimbGradingScale>(name: "Climb Grading Scale", baseType: .enum, enumType: .yds)
            case .climbGradeValue: IntegerField(name: "Climb Grade Value", baseType: .uint32)
            case .status: EnumField<SplitStatus>(name: "Status", baseType: .enum, enumType: .failure)
            case .numFalls: IntegerField(name: "Number of Falls", baseType: .uint16)
            case .climbSend: BooleanField(name: "Climb Send")
            case .startElevation: DistanceField(name: "Start Elevation", baseType: .uint32, unit: .meters, scale: 5, offset: 500)
            case .activeTime: DurationField(name: "Active Time", baseType: .uint32, unit: .seconds, scale: 1000, offset: 0)
            case .metabolicCalories: EnergyField(name: "Metabolic Calories", baseType: .uint16, unit: .kilocalories, scale: 1, offset: 0)
            case .totalFractionalAscent: DistanceField(name: "Total Fractional Ascent", baseType: .uint8, unit: .meters, scale: 100, offset: 0)
            case .totalFractionalDescent: DistanceField(name: "Total Fractional Descent", baseType: .uint8, unit: .meters, scale: 100, offset: 0)
            case .avgGrade: DoubleField(name: "Average Grade", baseType: .sint16, unitSymbol: "%", scale: 100)
            case .maxGrade: DoubleField(name: "Max Grade", baseType: .sint16, unitSymbol: "%", scale: 100)
            case .minCadence: DoubleField(name: "Min Cadence", baseType: .uint16, unitSymbol: "rpm", scale: 128)
            case .avgGradeAdjustedSpeed: SpeedField(name: "Average Grade Adjusted Speed", baseType: .uint32, unit: .metersPerSecond, scale: 1000, offset: 0)
            case .avgStress: IntegerField(name: "Average Stress", baseType: .uint16)
            case .avgVam: SpeedField(name: "Average VAM", baseType: .uint16, unit: .metersPerSecond, scale: 1000, offset: 0)
            case .jumpCount: IntegerField(name: "Jump Count", baseType: .uint8)
            case .totalMovingTime: DurationField(name: "Total Moving Time", baseType: .uint32, unit: .seconds, scale: 1000, offset: 0)
            case .diveSectionType: EnumField<DiveSectionType>(name: "Dive Section Type", baseType: .enum, enumType: .ascent)
            case .avgAscentRate: SpeedField(name: "Average Ascent Rate", baseType: .uint32, unit: .metersPerSecond, scale: 1000, offset: 0)
            case .maxAscentRate: SpeedField(name: "Max Ascent Rate", baseType: .uint32, unit: .metersPerSecond, scale: 1000, offset: 0)
            case .avgDescentRate: SpeedField(name: "Average Descent Rate", baseType: .uint32, unit: .metersPerSecond, scale: 1000, offset: 0)
            case .maxDescentRate: SpeedField(name: "Max Descent Rate", baseType: .uint32, unit: .metersPerSecond, scale: 1000, offset: 0)
            case .totalAscentTime: DurationField(name: "Total Ascent Time", baseType: .uint32, unit: .seconds, scale: 1000, offset: 0)
            case .totalDescentTime: DurationField(name: "Total Descent Time", baseType: .uint32, unit: .seconds, scale: 1000, offset: 0)
            case .totalHangTime: DurationField(name: "Total Hang Time", baseType: .uint32, unit: .seconds, scale: 1000, offset: 0)
            case .apneaDiscipline: EnumField<ApneaDiscipline>(name: "Apnea Discipline", baseType: .enum, enumType: .constantWeightWithFins)
            case .avgDepth: DistanceField(name: "Average Depth", baseType: .uint32, unit: .meters, scale: 1000, offset: 0)
            case .maxDepth: DistanceField(name: "Max Depth", baseType: .uint32, unit: .meters, scale: 1000, offset: 0)
            case .minHeartRate: IntegerField(name: "Min Heart Rate", baseType: .uint8, unitSymbol: "bpm")
            case .surfaceInterval: DurationField(name: "Surface Interval", baseType: .uint32, unit: .seconds, scale: 1, offset: 0)
            case .totalFractionalCycles: DoubleField(name: "Total Fractional Cycles", baseType: .uint8, unitSymbol: "cycles", scale: 128)
            case .avgStanceTimePercent: DoubleField(name: "Average Stance Time Percent", baseType: .uint16, unitSymbol: "%", scale: 100)
            case .totalAnaerobicTrainingEffect: DoubleField(name: "Total Anaerobic Training Effect", baseType: .uint8, scale: 10)
            case .frontGearShiftCount: IntegerField(name: "Front Gear Shift Count", baseType: .uint16)
            case .rearGearShiftCount: IntegerField(name: "Rear Gear Shift Count", baseType: .uint16)
            }
        }
    }
}
