//
//  SegmentLapMessage.swift
//  PureFIT
//

public struct SegmentLapMessage: ProfiledMessage {
    public let globalMessageType: GlobalMessageType = .segmentLap
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
        case totalCycles = 10
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
        case sport = 23
        case eventGroup = 24
        case necLat = 25
        case necLong = 26
        case swcLat = 27
        case swcLong = 28
        case name = 29
        case normalizedPower = 30
        case leftRightBalance = 31
        case subSport = 32
        case totalWork = 33
        case avgAltitude = 34
        case maxAltitude = 35
        case gpsAccuracy = 36
        case avgGrade = 37
        case avgPosGrade = 38
        case avgNegGrade = 39
        case maxPosGrade = 40
        case maxNegGrade = 41
        case avgTemperature = 42
        case maxTemperature = 43
        case totalMovingTime = 44
        case avgPosVerticalSpeed = 45
        case avgNegVerticalSpeed = 46
        case maxPosVerticalSpeed = 47
        case maxNegVerticalSpeed = 48
        case timeInHrZone = 49
        case timeInSpeedZone = 50
        case timeInCadenceZone = 51
        case timeInPowerZone = 52
        case repetitionNum = 53
        case minAltitude = 54
        case minHeartRate = 55
        case activeTime = 56
        case wktStepIndex = 57
        case sportEvent = 58
        case avgLeftTorqueEffectiveness = 59
        case avgRightTorqueEffectiveness = 60
        case avgLeftPedalSmoothness = 61
        case avgRightPedalSmoothness = 62
        case avgCombinedPedalSmoothness = 63
        case status = 64
        case uuid = 65
        case avgFractionalCadence = 66
        case maxFractionalCadence = 67
        case totalFractionalCycles = 68
        case frontGearShiftCount = 69
        case rearGearShiftCount = 70
        case timeStanding = 71
        case standCount = 72
        case avgLeftPco = 73
        case avgRightPco = 74
        case avgLeftPowerPhase = 75
        case avgLeftPowerPhasePeak = 76
        case avgRightPowerPhase = 77
        case avgRightPowerPhasePeak = 78
        case avgPowerPosition = 79
        case maxPowerPosition = 80
        case avgCadencePosition = 81
        case maxCadencePosition = 82
        case manufacturer = 83
        case totalGrit = 84
        case totalFlow = 85
        case avgGrit = 86
        case avgFlow = 87
        case metabolicCalories = 88
        case totalFractionalAscent = 89
        case totalFractionalDescent = 90
        case enhancedAvgAltitude = 91
        case enhancedMaxAltitude = 92
        case enhancedMinAltitude = 93

        public var fieldDefinition: any FieldDefinition {
            switch self {
            case .messageIndex: CompositeField<MessageIndex>(name: "Message Index", baseType: .uint16)
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
            case .totalCycles: IntegerField(name: "Total Cycles", baseType: .uint32, unitSymbol: "cycles")
            case .totalCalories: EnergyField(name: "Total Calories", baseType: .uint16, unit: .kilocalories, scale: 1, offset: 0)
            case .totalFatCalories: EnergyField(name: "Total Fat Calories", baseType: .uint16, unit: .kilocalories, scale: 1, offset: 0)
            case .avgSpeed: SpeedField(name: "Average Speed", baseType: .uint16, unit: .metersPerSecond, scale: 1000, offset: 0)
            case .maxSpeed: SpeedField(name: "Max Speed", baseType: .uint16, unit: .metersPerSecond, scale: 1000, offset: 0)
            case .avgHeartRate: IntegerField(name: "Average Heart Rate", baseType: .uint8, unitSymbol: "bpm")
            case .maxHeartRate: IntegerField(name: "Max Heart Rate", baseType: .uint8, unitSymbol: "bpm")
            case .avgCadence: IntegerField(name: "Average Cadence", baseType: .uint8, unitSymbol: "rpm")
            case .maxCadence: IntegerField(name: "Max Cadence", baseType: .uint8, unitSymbol: "rpm")
            case .avgPower: PowerField(name: "Average Power", baseType: .uint16, scale: 1, offset: 0)
            case .maxPower: PowerField(name: "Max Power", baseType: .uint16, scale: 1, offset: 0)
            case .totalAscent: DistanceField(name: "Total Ascent", baseType: .uint16, unit: .meters, scale: 1, offset: 0)
            case .totalDescent: DistanceField(name: "Total Descent", baseType: .uint16, unit: .meters, scale: 1, offset: 0)
            case .sport: EnumField<Sport>(name: "Sport", baseType: .enum, enumType: .all)
            case .eventGroup: IntegerField(name: "Event Group", baseType: .uint8)
            case .necLat: AngleField(name: "Northeast Corner Latitude", baseType: .sint32, scale: 1, offset: 0)
            case .necLong: AngleField(name: "Northeast Corner Longitude", baseType: .sint32, scale: 1, offset: 0)
            case .swcLat: AngleField(name: "Southwest Corner Latitude", baseType: .sint32, scale: 1, offset: 0)
            case .swcLong: AngleField(name: "Southwest Corner Longitude", baseType: .sint32, scale: 1, offset: 0)
            case .name: StringField(name: "Name")
            case .normalizedPower: PowerField(name: "Normalized Power", baseType: .uint16, scale: 1, offset: 0)
            case .leftRightBalance: CompositeField<LeftRightBalance100>(name: "Left/Right Balance", baseType: .uint16)
            case .subSport: EnumField<SubSport>(name: "Sub Sport", baseType: .enum, enumType: .all)
            case .totalWork: EnergyField(name: "Total Work", baseType: .uint32, unit: .joules, scale: 1, offset: 0)
            case .avgAltitude: DistanceField(name: "Average Altitude", baseType: .uint16, unit: .meters, scale: 5, offset: 500)
            case .maxAltitude: DistanceField(name: "Max Altitude", baseType: .uint16, unit: .meters, scale: 5, offset: 500)
            case .gpsAccuracy: DistanceField(name: "GPS Accuracy", baseType: .uint8, unit: .meters, scale: 1, offset: 0)
            case .avgGrade: DoubleField(name: "Average Grade", baseType: .sint16, unitSymbol: "%", scale: 100)
            case .avgPosGrade: DoubleField(name: "Average Positive Grade", baseType: .sint16, unitSymbol: "%", scale: 100)
            case .avgNegGrade: DoubleField(name: "Average Negative Grade", baseType: .sint16, unitSymbol: "%", scale: 100)
            case .maxPosGrade: DoubleField(name: "Max Positive Grade", baseType: .sint16, unitSymbol: "%", scale: 100)
            case .maxNegGrade: DoubleField(name: "Max Negative Grade", baseType: .sint16, unitSymbol: "%", scale: 100)
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
            case .repetitionNum: IntegerField(name: "Repetition Number", baseType: .uint16)
            case .minAltitude: DistanceField(name: "Min Altitude", baseType: .uint16, unit: .meters, scale: 5, offset: 500)
            case .minHeartRate: IntegerField(name: "Min Heart Rate", baseType: .uint8, unitSymbol: "bpm")
            case .activeTime: DurationField(name: "Active Time", baseType: .uint32, unit: .seconds, scale: 1000, offset: 0)
            case .wktStepIndex: CompositeField<MessageIndex>(name: "Workout Step Index", baseType: .uint16)
            case .sportEvent: EnumField<SportEvent>(name: "Sport Event", baseType: .enum, enumType: .uncategorized)
            case .avgLeftTorqueEffectiveness: DoubleField(name: "Average Left Torque Effectiveness", baseType: .uint8, unitSymbol: "%", scale: 2)
            case .avgRightTorqueEffectiveness: DoubleField(name: "Average Right Torque Effectiveness", baseType: .uint8, unitSymbol: "%", scale: 2)
            case .avgLeftPedalSmoothness: DoubleField(name: "Average Left Pedal Smoothness", baseType: .uint8, unitSymbol: "%", scale: 2)
            case .avgRightPedalSmoothness: DoubleField(name: "Average Right Pedal Smoothness", baseType: .uint8, unitSymbol: "%", scale: 2)
            case .avgCombinedPedalSmoothness: DoubleField(name: "Average Combined Pedal Smoothness", baseType: .uint8, unitSymbol: "%", scale: 2)
            case .status: EnumField<SegmentLapStatus>(name: "Status", baseType: .enum, enumType: .end)
            case .uuid: StringField(name: "UUID")
            case .avgFractionalCadence: DoubleField(name: "Average Fractional Cadence", baseType: .uint8, unitSymbol: "rpm", scale: 128)
            case .maxFractionalCadence: DoubleField(name: "Max Fractional Cadence", baseType: .uint8, unitSymbol: "rpm", scale: 128)
            case .totalFractionalCycles: DoubleField(name: "Total Fractional Cycles", baseType: .uint8, unitSymbol: "cycles", scale: 128)
            case .frontGearShiftCount: IntegerField(name: "Front Gear Shift Count", baseType: .uint16)
            case .rearGearShiftCount: IntegerField(name: "Rear Gear Shift Count", baseType: .uint16)
            case .timeStanding: DurationField(name: "Time Standing", baseType: .uint32, unit: .seconds, scale: 1000, offset: 0)
            case .standCount: IntegerField(name: "Stand Count", baseType: .uint16)
            case .avgLeftPco: DistanceField(name: "Average Left PCO", baseType: .sint8, unit: .millimeters, scale: 1, offset: 0)
            case .avgRightPco: DistanceField(name: "Average Right PCO", baseType: .sint8, unit: .millimeters, scale: 1, offset: 0)
            case .avgLeftPowerPhase: MultipleValueField(singleFieldDefinition: DoubleField(name: "Average Left Power Phase", baseType: .uint8, unitSymbol: "°", scale: 0.7111111))
            case .avgLeftPowerPhasePeak: MultipleValueField(singleFieldDefinition: DoubleField(name: "Average Left Power Phase Peak", baseType: .uint8, unitSymbol: "°", scale: 0.7111111))
            case .avgRightPowerPhase: MultipleValueField(singleFieldDefinition: DoubleField(name: "Average Right Power Phase", baseType: .uint8, unitSymbol: "°", scale: 0.7111111))
            case .avgRightPowerPhasePeak: MultipleValueField(singleFieldDefinition: DoubleField(name: "Average Right Power Phase Peak", baseType: .uint8, unitSymbol: "°", scale: 0.7111111))
            case .avgPowerPosition: MultipleValueField(singleFieldDefinition: PowerField(name: "Average Power Position", baseType: .uint16, scale: 1, offset: 0))
            case .maxPowerPosition: MultipleValueField(singleFieldDefinition: PowerField(name: "Max Power Position", baseType: .uint16, scale: 1, offset: 0))
            case .avgCadencePosition: MultipleValueField(singleFieldDefinition: IntegerField(name: "Average Cadence Position", baseType: .uint8, unitSymbol: "rpm"))
            case .maxCadencePosition: MultipleValueField(singleFieldDefinition: IntegerField(name: "Max Cadence Position", baseType: .uint8, unitSymbol: "rpm"))
            case .manufacturer: EnumField<Manufacturer>(name: "Manufacturer", baseType: .uint16, enumType: .garmin)
            case .totalGrit: DoubleField(name: "Total Grit", baseType: .float32, unitSymbol: "kGrit", scale: 1)
            case .totalFlow: DoubleField(name: "Total Flow", baseType: .float32, scale: 1)
            case .avgGrit: DoubleField(name: "Average Grit", baseType: .float32, unitSymbol: "kGrit", scale: 1)
            case .avgFlow: DoubleField(name: "Average Flow", baseType: .float32, scale: 1)
            case .metabolicCalories: EnergyField(name: "Metabolic Calories", baseType: .uint16, unit: .kilocalories, scale: 1, offset: 0)
            case .totalFractionalAscent: DistanceField(name: "Total Fractional Ascent", baseType: .uint8, unit: .meters, scale: 100, offset: 0)
            case .totalFractionalDescent: DistanceField(name: "Total Fractional Descent", baseType: .uint8, unit: .meters, scale: 100, offset: 0)
            case .enhancedAvgAltitude: DistanceField(name: "Enhanced Average Altitude", baseType: .uint32, unit: .meters, scale: 5, offset: 500)
            case .enhancedMaxAltitude: DistanceField(name: "Enhanced Max Altitude", baseType: .uint32, unit: .meters, scale: 5, offset: 500)
            case .enhancedMinAltitude: DistanceField(name: "Enhanced Min Altitude", baseType: .uint32, unit: .meters, scale: 5, offset: 500)
            }
        }
    }
}
