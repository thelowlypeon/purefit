//
//  SessionMessage.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

public struct SessionMessage: ProfiledMessage {
    public let globalMessageType: GlobalMessageType = .session
    public let fields: [FieldDefinitionNumber : [FITValue]]

    public enum Field: UInt8, CaseIterable, StandardMessageField, FieldDefinitionProviding {
        case event = 0
        case eventType = 1
        case startTime = 2
        case startPositionLatitude = 3
        case startPositionLongitude = 4
        case sport = 5
        case subSport = 6
        case totalElapsedTime = 7
        case totalTimerTime = 8
        case totalDistance = 9
        case totalCycles = 10
        case totalCalories = 11
        case avgSpeed = 14
        case maxSpeed = 15
        case avgHeartRate = 16
        case maxHeartRate = 17
        case avgCadence = 18
        case maxCadence = 19
        case avgPower = 20
        case maxPower = 21
        case totalAscent = 22
        case totalDescent = 23
        case totalTrainingEffect = 24
        case firstLapIndex = 25
        case numLaps = 26
        case normalizedPower = 34
        case timestamp = 253
        case messageIndex = 254

        public var fieldDefinition: any FieldDefinition {
            switch self {
            case .event: EnumField<Event>(name: "Event", baseType: .uint8, enumType: .timer)
            case .eventType: EnumField<EventType>(name: "Event Type", baseType: .uint8, enumType: .start)
            case .startTime: DateField(name: "Start Time")
            case .startPositionLatitude: AngleField(name: "Starting Latitude", baseType: .sint32, scale: 1, offset: 0)
            case .startPositionLongitude: AngleField(name: "Starting Longitude", baseType: .sint32, scale: 1, offset: 0)
            case .sport: EnumField<Sport>(name: "Sport", baseType: .enum, enumType: .all)
            case .subSport: EnumField<SubSport>(name: "Sub-sport", baseType: .enum, enumType: .generic)
            case .totalElapsedTime: DurationField(name: "Total Elapsed Time", baseType: .uint32, unit: .seconds, scale: 1000, offset: 0)
            case .totalTimerTime: DurationField(name: "Total Timer Time", baseType: .uint32, unit: .seconds, scale: 1000, offset: 0)
            case .totalDistance: DistanceField(name: "Total Distance", baseType: .uint32, unit: .meters, scale: 100, offset: 0)
            case .totalCycles: IntegerField(name: "Total Cycles", baseType: .uint32)
            case .totalCalories: EnergyField(name: "Total Calories", baseType: .uint16, unit: .kilocalories, scale: 1, offset: 0)
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
            case .totalTrainingEffect: IntegerField(name: "Total Training Effect", baseType: .uint8, scale: 10)
            case .firstLapIndex: IntegerField(name: "First Lap Index", baseType: .uint16)
            case .numLaps: IntegerField(name: "Num Laps", baseType: .uint16)
            case .normalizedPower: PowerField(name: "Normalized Power", baseType: .uint16, scale: 1, offset: 0)
            case .timestamp: DateField(name: "Timestamp")
            case .messageIndex: CompositeField<MessageIndex>(name: "Message Index", baseType: .uint16)
            }
        }
    }
}
