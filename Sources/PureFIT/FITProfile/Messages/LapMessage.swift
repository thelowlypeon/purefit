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
        case messageIndex = 254
        case timestamp = 253
        case event = 0
        case eventType = 1
        case startTime = 2
        case startPositionLat = 3
        case startPositionLong = 4
        case endPositionLat = 5
        case endPositionLong = 6
        case totalElapsedTime = 7
        case totalTimerTime = 8
        case totalDistance = 9
        // case totalCycles = 10
        case totalCalories = 11
        case totalFatCalories = 12
        case avgSpeed = 13
        case maxSpeed = 14
        case avgHeartRate = 15
        case maxHeartRate = 16
        case avgCadence = 17
        case maxCadence = 18
        case avgPower = 19
        case maxPower = 20
        case totalAscent = 21
        case totalDescent = 22
        case intensity = 23
        case lapTrigger = 24
        case sport = 25
        case eventGroup = 26
        case numLengths = 32
        case normalizedPower = 33
        case leftRightBalance = 34
        case firstLengthIndex = 35
        case avgStrokeDistance = 37
        // case swimStroke = 38
        case subSport = 39
        case numActiveLengths = 40
        case totalWork = 41
        case avgAltitude = 42
        case maxAltitude = 43
        case gpsAccuracy = 44
        case avgGrade = 45
        case avgPosGrade = 46
        case avgNegGrade = 47
        case maxPosGrade = 48
        case maxNegGrade = 49
        case avgTemperature = 50
        case maxTemperature = 51
        case totalMovingTime = 52
        case avgPosVerticalSpeed = 53
        case avgNegVerticalSpeed = 54
        case maxPosVerticalSpeed = 55
        case maxNegVerticalSpeed = 56
        case timeInHrZone = 57
        case timeInSpeedZone = 58
        case timeInCadenceZone = 59
        case timeInPowerZone = 60
        case repetitionNum = 61
        case minAltitude = 62
        case minHeartRate = 63
        case workoutStepIndex = 71
        case opponentScore = 74
        case strokeCount = 75
        case zoneCount = 76
        case avgVerticalOscillation = 77
        case avgStanceTimePercent = 78
        case avgStanceTime = 79
        case avgFractionalCadence = 80
        case maxFractionalCadence = 81
        case totalFractionalCycles = 82
        case playerScore = 83
        // case avgTotalHemoglobinConc = 84
        // case minTotalHemoglobinConc = 85
        // case maxTotalHemoglobinConc = 86
        // case avgSaturatedHemoglobinPercent = 87
        // case minSaturatedHemoglobinPercent = 88
        // case maxSaturatedHemoglobinPercent = 89
        case avgLeftTorqueEffectiveness = 91
        case avgRightTorqueEffectiveness = 92
        case avgLeftPedalSmoothness = 93
        case avgRightPedalSmoothness = 94
        case avgCombinedPedalSmoothness = 95
        case timeStanding = 98
        // case standCount = 99
        // case avgLeftPco = 100
        // case avgRightPco = 101
        // case avgLeftPowerPhase = 102
        // case avgLeftPowerPhasePeak = 103
        // case avgRightPowerPhase = 104
        // case avgRightPowerPhasePeak = 105
        // case avgPowerPosition = 106
        // case maxPowerPosition = 107
        // case avgCadencePosition = 108
        // case maxCadencePosition = 109
        case enhancedAvgSpeed = 110
        case enhancedMaxSpeed = 111
        case enhancedAvgAltitude = 112
        case enhancedMinAltitude = 113
        case enhancedMaxAltitude = 114
        // case avgLevMotorPower = 115
        // case maxLevMotorPower = 116
        // case levBatteryConsumption = 117
        // case avgVerticalRatio = 118
        // case avgStanceTimeBalance = 119
        // case avgStepLength = 120
        // case avgVam = 121
        // case avgDepth = 122
        // case maxDepth = 123
        // case minTemperature = 124
        // case enhancedAvgRespirationRate = 136
        // case enhancedMaxRespirationRate = 137
        // case avgRespirationRate = 147
        // case maxRespirationRate = 148
        // case totalGrit = 149
        // case totalFlow = 150
        // case jumpCount = 151
        // case avgGrit = 153
        // case avgFlow = 154
        // case totalFractionalAscent = 156
        // case totalFractionalDescent = 157
        // case avgCoreTemperature = 158
        // case minCoreTemperature = 159
        // case maxCoreTemperature = 160

        public var fieldDefinition: any FieldDefinition {
            switch self {
            case .messageIndex: IndexField(name: "Message Index", baseType: .uint16)
            case .timestamp: DateField(name: "Timestamp")
            case .event: EnumField<Event>(name: "Event", baseType: .enum, enumType: .activity)
            case .eventType: EnumField<EventType>(name: "Event Type", baseType: .enum, enumType: .start)
            case .startTime: DateField(name: "Start Time")
            case .startPositionLat: AngleField(name: "Start Position Latitude", baseType: .sint32, scale: 1, offset: 0)
            case .startPositionLong: AngleField(name: "Start Position Longitude", baseType: .sint32, scale: 1, offset: 0)
            case .endPositionLat: AngleField(name: "End Position Latitude", baseType: .sint32, scale: 1, offset: 0)
            case .endPositionLong: AngleField(name: "End Position Longitude", baseType: .sint32, scale: 1, offset: 0)
            case .totalElapsedTime: DurationField(name: "Total Elapsed Time", baseType: .uint32, unit: .seconds, scale: 1000, offset: 0)
            case .totalTimerTime: DurationField(name: "Total Timer Time", baseType: .uint32, unit: .seconds, scale: 1000, offset: 0)
            case .totalDistance: DistanceField(name: "Total Distance", baseType: .uint32, unit: .meters, scale: 100, offset: 0)
            //case .totalCycles:
            case .totalCalories: EnergyField(name: "Total Calories", baseType: .uint16, unit: .kilocalories, scale: 1, offset: 0)
            case .totalFatCalories: EnergyField(name: "Total Fat Calories", baseType: .uint16, unit: .kilocalories, scale: 1, offset: 0)
            case .avgSpeed: SpeedField(name: "Average Speed", baseType: .uint16, unit: .metersPerSecond, scale: 1000, offset: 0)
            case .maxSpeed: SpeedField(name: "Max Speed", baseType: .uint16, unit: .metersPerSecond, scale: 1000, offset: 0)
            case .avgHeartRate: IntegerField(name: "Average Heart Rate", baseType: .uint8, unitSymbol: "bpm")
            case .maxHeartRate: IntegerField(name: "Max Heart Rate", baseType: .uint8, unitSymbol: "bpm")
            case .avgCadence: IntegerField(name: "Average Cadence", baseType: .uint8, unitSymbol: "bpm")
            case .maxCadence: IntegerField(name: "Max Cadence", baseType: .uint8, unitSymbol: "bpm")
            case .avgPower: PowerField(name: "Average Power", baseType: .uint16, scale: 1, offset: 0)
            case .maxPower: PowerField(name: "Max Power", baseType: .uint16, scale: 1, offset: 0)
            case .totalAscent: DistanceField(name: "Total Ascent", baseType: .uint16, unit: .meters, scale: 1, offset: 0)
            case .totalDescent: DistanceField(name: "Total Descent", baseType: .uint16, unit: .meters, scale: 1, offset: 0)
            case .intensity: EnumField<Intensity>(name: "Intensity", baseType: .enum, enumType: .active)
            case .lapTrigger: EnumField<LapTrigger>(name: "Lap Trigger", baseType: .enum, enumType: .manual)
            case .sport: EnumField<Sport>(name: "Sport", baseType: .enum, enumType: .all)
            case .eventGroup: IntegerField(name: "Event Group", baseType: .uint8)
            case .numLengths: IntegerField(name: "Num Lengths", baseType: .uint16, unitSymbol: nil)
            case .normalizedPower: PowerField(name: "Normalized Power", baseType: .uint16, scale: 1, offset: 0)
            case .leftRightBalance: IntegerField(name: "Left/Right Balance", baseType: .uint8, unitSymbol: "%")
            case .firstLengthIndex: IndexField(name: "First Length Index", baseType: .uint16)
            case .avgStrokeDistance: DistanceField(name: "Average Stroke Distance", baseType: .uint16, unit: .meters, scale: 100, offset: 0)
            // case .swimStroke:
            case .subSport: EnumField<SubSport>(name: "Sub Sport", baseType: .enum, enumType: .all)
            case .numActiveLengths: IntegerField(name: "Number of Active Lengths", baseType: .uint16, unitSymbol: "lengths")
            case .totalWork: EnergyField(name: "Total Work", baseType: .uint32, unit: .joules, scale: 1, offset: 0)
            case .avgAltitude: DistanceField(name: "Average Altitude", baseType: .uint16, unit: .meters, scale: 5, offset: 500)
            case .maxAltitude: DistanceField(name: "Max Altitude", baseType: .uint16, unit: .meters, scale: 5, offset: 500)
            case .gpsAccuracy: DistanceField(name: "GPS Accuracy", baseType: .uint16, unit: .meters, scale: 1, offset: 0)
            case .avgGrade: IntegerField(name: "Average Grade", baseType: .sint16, unitSymbol: "%", scale: 100)
            case .avgPosGrade: IntegerField(name: "Average Positive Grade", baseType: .sint16, unitSymbol: "%", scale: 100)
            case .avgNegGrade: IntegerField(name: "Average Negative Grade", baseType: .sint16, unitSymbol: "%", scale: 100)
            case .maxPosGrade: IntegerField(name: "Max Positive Grade", baseType: .sint16, unitSymbol: "%", scale: 100)
            case .maxNegGrade: IntegerField(name: "Max Negative Grade", baseType: .sint16, unitSymbol: "%", scale: 100)
            case .avgTemperature: TemperatureField(name: "Average Temperature", baseType: .sint8, unit: .celsius, scale: 1, offset: 0)
            case .maxTemperature: TemperatureField(name: "Max Temperature", baseType: .sint8, unit: .celsius, scale: 1, offset: 0)
            case .totalMovingTime: DurationField(name: "Total Moving Time", baseType: .uint32, unit: .seconds, scale: 1000, offset: 0)
            case .avgPosVerticalSpeed: SpeedField(name: "Average Positive Vertical Speed", baseType: .sint16, unit: .metersPerSecond, scale: 1000, offset: 0)
            case .avgNegVerticalSpeed: SpeedField(name: "Average Negative Vertical Speed", baseType: .sint16, unit: .metersPerSecond, scale: 1000, offset: 0)
            case .maxPosVerticalSpeed: SpeedField(name: "Max Positive Vertical Speed", baseType: .sint16, unit: .metersPerSecond, scale: 1000, offset: 0)
            case .maxNegVerticalSpeed: SpeedField(name: "Max Negative Vertical Speed", baseType: .sint16, unit: .metersPerSecond, scale: 1000, offset: 0)
            case .timeInHrZone: MultipleValueField(singleFieldDefinition: DurationField(name: "Time in HR Zone", baseType: .uint32, unit: .seconds, scale: 1000, offset: 0))
            case .timeInSpeedZone: MultipleValueField(singleFieldDefinition: DurationField(name: "Time in Speed Zone", baseType: .uint32, unit: .seconds, scale: 1000, offset: 0))
            case .timeInCadenceZone: MultipleValueField(singleFieldDefinition: DurationField(name: "Time in Cadence Zone", baseType: .uint32, unit: .seconds, scale: 1000, offset: 0))
            case .timeInPowerZone: MultipleValueField(singleFieldDefinition: DurationField(name: "Time in Power Zone", baseType: .uint32, unit: .seconds, scale: 1000, offset: 0))
            case .repetitionNum: IndexField(name: "Repetition Number", baseType: .uint16)
            case .minAltitude: DistanceField(name: "Min Altitude", baseType: .uint16, unit: .meters, scale: 5, offset: 500)
            case .minHeartRate: IntegerField(name: "Min Heart Rate", baseType: .uint8, unitSymbol: "bpm")
            case .workoutStepIndex: CompositeField<MessageIndex>(name: "Workout Step Index", baseType: .uint16)
            case .opponentScore: IntegerField(name: "Opponent Score", baseType: .uint16)
            case .strokeCount: MultipleValueField(singleFieldDefinition: IntegerField(name: "Stroke Count", baseType: .uint16))
            case .zoneCount: MultipleValueField(singleFieldDefinition: IntegerField(name: "Zone Count", baseType: .uint16))
            case .avgVerticalOscillation: DistanceField(name: "Average Vertical Oscillation", baseType: .uint16, unit: .millimeters, scale: 10, offset: 0)
            case .avgStanceTimePercent: IntegerField(name: "Average Stance Time Percent", baseType: .uint16, unitSymbol: "%", scale: 100)
            case .avgStanceTime: if #available(iOS 13.0, *) {
                DurationField(name: "Average Stance Time", baseType: .uint16, unit: .milliseconds, scale: 10, offset: 0)
            } else {
                DurationField(name: "Average Stance Time", baseType: .uint16, unit: .seconds, scale: 0.01, offset: 0)
            }
            case .avgFractionalCadence: IntegerField(name: "Average Fractional Cadence", baseType: .uint8, unitSymbol: "rpm", scale: 128)
            case .maxFractionalCadence: IntegerField(name: "Max Fractional Cadence", baseType: .uint8, unitSymbol: "rpm", scale: 128)
            case .totalFractionalCycles: IntegerField(name: "Total Fractional Cycles", baseType: .uint8, scale: 128)
            case .playerScore: IntegerField(name: "Player Score", baseType: .uint16)
            // case .avgTotalHemoglobinConc:
            // case .minTotalHemoglobinConc:
            // case .maxTotalHemoglobinConc:
            // case .avgSaturatedHemoglobinPercent:
            // case .minSaturatedHemoglobinPercent:
            // case .maxSaturatedHemoglobinPercent:
            case .avgLeftTorqueEffectiveness: IntegerField(name: "Average Left Torque Effectiveness", baseType: .uint8, unitSymbol: "%", scale: 2)
            case .avgRightTorqueEffectiveness: IntegerField(name: "Average Right Torque Effectiveness", baseType: .uint8, unitSymbol: "%", scale: 2)
            case .avgLeftPedalSmoothness: IntegerField(name: "Average Left Pedal Smoothness", baseType: .uint8, unitSymbol: "%", scale: 2)
            case .avgRightPedalSmoothness: IntegerField(name: "Average Right Pedal Smoothness", baseType: .uint8, unitSymbol: "%", scale: 2)
            case .avgCombinedPedalSmoothness: IntegerField(name: "Average Combined Pedal Smoothness", baseType: .uint8, unitSymbol: "%", scale: 2)
            case .timeStanding: DurationField(name: "Time Standing", baseType: .uint32, unit: .seconds, scale: 1000, offset: 0)
            // case .standCount:
            // case .avgLeftPco:
            // case .avgRightPco:
            // case .avgLeftPowerPhase:
            // case .avgLeftPowerPhasePeak:
            // case .avgRightPowerPhase:
            // case .avgRightPowerPhasePeak:
            // case .avgPowerPosition:
            // case .maxPowerPosition:
            // case .avgCadencePosition:
            // case .maxCadencePosition:
            case .enhancedAvgSpeed: SpeedField(name: "Enhanced Average Speed", baseType: .uint32, unit: .metersPerSecond, scale: 1000, offset: 0)
            case .enhancedMaxSpeed: SpeedField(name: "Enhanced Max Speed", baseType: .uint32, unit: .metersPerSecond, scale: 1000, offset: 0)
            case .enhancedAvgAltitude: DistanceField(name: "Enhanced Average Altitude", baseType: .uint32, unit: .meters, scale: 5, offset: 0)
            case .enhancedMinAltitude: DistanceField(name: "Enhanced Min Altitude", baseType: .uint32, unit: .meters, scale: 5, offset: 0)
            case .enhancedMaxAltitude: DistanceField(name: "Enhanced Max Altitude", baseType: .uint32, unit: .meters, scale: 5, offset: 0)
            // case .avgLevMotorPower: IntegerField(name: "avg_lev_motor_power", baseType: .uint16, scale: 1, unitSymbol: "watts")
            // case .maxLevMotorPower: IntegerField(name: "max_lev_motor_power", baseType: .uint16, scale: 1, unitSymbol: "watts")
            // case .levBatteryConsumption: UndefinedField(globalMessageNumber: .lap, fieldDefinitionNumber: .standard(117))
            // case .avgVerticalRatio: IntegerField(name: "avg_vertical_ratio", baseType: .uint16, scale: 100, unitSymbol: "percent")
            // case .avgStanceTimeBalance: IntegerField(name: "avg_stance_time_balance", baseType: .uint16, scale: 100, unitSymbol: "percent")
            // case .avgStepLength: IntegerField(name: "avg_step_length", baseType: .uint16, scale: 10, unitSymbol: "mm")
            // case .avgVam: IntegerField(name: "avg_vam", baseType: .uint16, scale: 1000, unitSymbol: "m/s")
            // case .avgDepth: IntegerField(name: "avg_depth", baseType: .uint32, scale: 1000, unitSymbol: "m")
            // case .maxDepth: IntegerField(name: "max_depth", baseType: .uint32, scale: 1000, unitSymbol: "m")
            // case .minTemperature: TemperatureField(name: "min_temperature", baseType: .sint8, unit: .celsius, scale: 1, offset: 0)
            // case .enhancedAvgRespirationRate: IntegerField(name: "enhanced_avg_respiration_rate", baseType: .uint16, scale: 100, unitSymbol: "Breaths/min")
            // case .enhancedMaxRespirationRate: IntegerField(name: "enhanced_max_respiration_rate", baseType: .uint16, scale: 100, unitSymbol: "Breaths/min")
            // case .avgRespirationRate: UndefinedField(globalMessageNumber: .lap, fieldDefinitionNumber: .standard(147))
            // case .maxRespirationRate: UndefinedField(globalMessageNumber: .lap, fieldDefinitionNumber: .standard(148))
            // case .totalGrit: UndefinedField(globalMessageNumber: .lap, fieldDefinitionNumber: .standard(149))
            // case .totalFlow: UndefinedField(globalMessageNumber: .lap, fieldDefinitionNumber: .standard(150))
            // case .jumpCount: IntegerField(name: "jump_count", baseType: .uint16, scale: 1)
            // case .avgGrit: UndefinedField(globalMessageNumber: .lap, fieldDefinitionNumber: .standard(153))
            // case .avgFlow: UndefinedField(globalMessageNumber: .lap, fieldDefinitionNumber: .standard(154))
            // case .totalFractionalAscent: UndefinedField(globalMessageNumber: .lap, fieldDefinitionNumber: .standard(156))
            // case .totalFractionalDescent: UndefinedField(globalMessageNumber: .lap, fieldDefinitionNumber: .standard(157))
            // case .avgCoreTemperature: IntegerField(name: "avg_core_temperature", baseType: .uint16, scale: 100, unitSymbol: "C")
            // case .minCoreTemperature: IntegerField(name: "min_core_temperature", baseType: .uint16, scale: 100, unitSymbol: "C")
            // case .maxCoreTemperature: IntegerField(name: "max_core_temperature", baseType: .uint16, scale: 100, unitSymbol: "C")
            }
        }
    }
}
