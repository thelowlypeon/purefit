//
//  RecordMessage.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

struct RecordMessage: ProfiledMessage {
    let fitMessage: FITMessage

    init(fitMessage: FITMessage) {
        self.fitMessage = fitMessage
    }

    enum Field: UInt8, CaseIterable, StandardMessageField {
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
        case verticalOscillation = 39
        case stanceTime = 41
        case fractionalCadence = 53
        case enhancedSpeed = 73
        case enhancedAltitude = 78
        case timestamp = 253

        var fieldDefinition: any FieldDefinition {
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
            case .verticalOscillation: DistanceField(name: "Vertical Oscillation", baseType: .uint16, unit: .millimeters, scale: 10, offset: 0)
            case .stanceTime: DurationField(name: "Stance Time", baseType: .uint16, unit: .milliseconds, scale: 10, offset: 0)
            case .fractionalCadence: IntegerField(name: "Fractional Cadence", baseType: .uint8, unitSymbol: "rpm", scale: 128)
            case .enhancedSpeed: SpeedField(name: "Enhanced Speed", baseType: .uint32, unit: .metersPerSecond, scale: 1000, offset: 0)
            case .enhancedAltitude: DistanceField(name: "Enhanced Altitude", baseType: .uint32, unit: .meters, scale: 5, offset: 500)
            case .timestamp: DateField(name: "Timestamp")
            }
        }
    }

    func value(at field: Field) -> FieldValue? {
        //...
        return nil
    }
}
