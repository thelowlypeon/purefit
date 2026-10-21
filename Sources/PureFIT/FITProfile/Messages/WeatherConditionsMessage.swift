//
//  WeatherConditionsMessage.swift
//  PureFIT
//

public struct WeatherConditionsMessage: ProfiledMessage {
    public let globalMessageType: GlobalMessageType = .weatherConditions
    public let fields: [FieldDefinitionNumber : [FITValue]]

    public enum Field: UInt8, CaseIterable, StandardMessageField, FieldDefinitionProviding {
        case timestamp = 253
        case weatherReport = 0
        case temperature = 1
        case condition = 2
        case windDirection = 3
        case windSpeed = 4
        case precipitationProbability = 5
        case temperatureFeelsLike = 6
        case relativeHumidity = 7
        case location = 8
        case observedAtTime = 9
        case observedLocationLat = 10
        case observedLocationLong = 11
        case dayOfWeek = 12
        case highTemperature = 13
        case lowTemperature = 14

        public var fieldDefinition: any FieldDefinition {
            switch self {
            case .timestamp: DateField(name: "Timestamp")
            case .weatherReport: EnumField<WeatherReport>(name: "Weather Report", baseType: .enum, enumType: .current)
            case .temperature: TemperatureField(name: "Temperature", baseType: .sint8, unit: .celsius, scale: 1, offset: 0)
            case .condition: EnumField<WeatherStatus>(name: "Condition", baseType: .enum, enumType: .clear)
            case .windDirection: IntegerField(name: "Wind Direction", baseType: .uint16, unitSymbol: "°")
            case .windSpeed: SpeedField(name: "Wind Speed", baseType: .uint16, unit: .metersPerSecond, scale: 1000, offset: 0)
            case .precipitationProbability: IntegerField(name: "Precipitation Probability", baseType: .uint8)
            case .temperatureFeelsLike: TemperatureField(name: "Temperature Feels Like", baseType: .sint8, unit: .celsius, scale: 1, offset: 0)
            case .relativeHumidity: IntegerField(name: "Relative Humidity", baseType: .uint8)
            case .location: StringField(name: "Location")
            case .observedAtTime: DateField(name: "Observed At Time")
            case .observedLocationLat: AngleField(name: "Observed Location Latitude", baseType: .sint32, scale: 1, offset: 0)
            case .observedLocationLong: AngleField(name: "Observed Location Longitude", baseType: .sint32, scale: 1, offset: 0)
            case .dayOfWeek: EnumField<DayOfWeek>(name: "Day of Week", baseType: .enum, enumType: .sunday)
            case .highTemperature: TemperatureField(name: "High Temperature", baseType: .sint8, unit: .celsius, scale: 1, offset: 0)
            case .lowTemperature: TemperatureField(name: "Low Temperature", baseType: .sint8, unit: .celsius, scale: 1, offset: 0)
            }
        }
    }
}
