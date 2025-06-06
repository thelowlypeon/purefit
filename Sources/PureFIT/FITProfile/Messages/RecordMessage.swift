//
//  RecordMessage.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

public struct RecordMessage: ProfiledMessage {
    public let globalMessageType: GlobalMessageType = .record
    public let fields: [FieldDefinitionNumber : [FITValue]]

    public enum Field: UInt8, CaseIterable, StandardMessageField, FieldDefinitionProviding {
        case latitude = 0
        case longitude = 1
        case altitude = 2
        case heartRate = 3
        case cadence = 4
        case distance = 5
        case speed = 6
        case power = 7
        case grade = 9
        case resistance = 10
        case timeFromCourse = 11
        case temperature = 13
        //case accumulatedPower = 29
        //case leftRightBalance = 30
        case leftTorqueEffectiveness = 43
        case rightTorqueEffectiveness = 44
        //case leftPedalSmoothness = 45
        //case rightPedalSmoothness = 46
        case verticalOscillation = 39
        case stanceTime = 41
        case fractionalCadence = 53
        //61 not part of profile, looks similar to altitude in value
        //66 not part of profile
        case enhancedSpeed = 73
        case enhancedAltitude = 78
        case performanceCondition = 90
        //case enhancedRespiratoryRate = 108
        case timestamp = 253

        public var fieldDefinition: any FieldDefinition {
            switch self {
            case .latitude: AngleField(name: "Longitude", baseType: .sint32, scale: 1, offset: 0)
            case .longitude: AngleField(name: "Longitude", baseType: .sint32, scale: 1, offset: 0)
            case .altitude: DistanceField(name: "Altitude", baseType: .uint16, unit: .meters, scale: 5, offset: 500)
            case .heartRate: IntegerField(name: "Heart Rate", baseType: .uint8, unitSymbol: "bpm", scale: 1)
            case .cadence: IntegerField(name: "Cadence", baseType: .uint8, unitSymbol: "rpm", scale: 1)
            case .distance: DistanceField(name: "Distance", baseType: .uint32, unit: .meters, scale: 100, offset: 0)
            case .speed: SpeedField(name: "Speed", baseType: .uint16, unit: .metersPerSecond, scale: 1000, offset: 0)
            case .power: PowerField(name: "Power", baseType: .uint16, scale: 1, offset: 0)
            // 8: compressed speed distance. data? bytes? is this a two-value field?
            case .grade: IntegerField(name: "Grade", baseType: .sint16, unitSymbol: "%", scale: 100)
            case .resistance: IntegerField(name: "Resistance", baseType: .uint8, scale: 1)
            case .timeFromCourse: DurationField(name: "Time from course", baseType: .sint32, unit: .seconds, scale: 1000, offset: 0)
            case .temperature: TemperatureField(name: "Temperature", baseType: .sint8, unit: .celsius, scale: 1, offset: 0)
            case .leftTorqueEffectiveness: IntegerField(name: "Left Torque Effectiveness", baseType: .uint8, unitSymbol: "%", scale: 2)
            case .rightTorqueEffectiveness: IntegerField(name: "Right Torque Effectiveness", baseType: .uint8, unitSymbol: "%", scale: 2)
            case .verticalOscillation: DistanceField(name: "Vertical Oscillation", baseType: .uint16, unit: .millimeters, scale: 10, offset: 0)
            case .stanceTime: if #available(iOS 13.0, *) {
                DurationField(name: "Stance Time", baseType: .uint16, unit: .milliseconds, scale: 10, offset: 0)
            } else {
                DurationField(name: "Stance Time", baseType: .uint16, unit: .seconds, scale: 0.01, offset: 0)
            }
            case .fractionalCadence: IntegerField(name: "Fractional Cadence", baseType: .uint8, unitSymbol: "rpm", scale: 128)
            case .enhancedSpeed: SpeedField(name: "Enhanced Speed", baseType: .uint32, unit: .metersPerSecond, scale: 1000, offset: 0)
            case .enhancedAltitude: DistanceField(name: "Enhanced Altitude", baseType: .uint32, unit: .meters, scale: 5, offset: 500)
            // NOTE: performanceCondition is not documented in profile.xlsx
            case .performanceCondition: IntegerField(name: "Performance Condition", baseType: .sint8)
            case .timestamp: DateField(name: "Timestamp")
            }
        }
    }
}
