//
//  WeatherConditionsMessageTests.swift
//  PureFIT
//

import Foundation
import Testing
@testable import PureFIT

// No fixture has weather_conditions messages, so these build the message from raw values.
struct WeatherConditionsMessageTests {
    @Test func weatherConditions() throws {
        let weather = WeatherConditionsMessage(fields: [
            .standard(WeatherConditionsMessage.Field.weatherReport.rawValue): [.enum(1)],
            .standard(WeatherConditionsMessage.Field.temperature.rawValue): [.sint8(-4)],
            .standard(WeatherConditionsMessage.Field.condition.rawValue): [.enum(13)],
            .standard(WeatherConditionsMessage.Field.windSpeed.rawValue): [.uint16(4200)],
            .standard(WeatherConditionsMessage.Field.dayOfWeek.rawValue): [.enum(6)],
            .standard(WeatherConditionsMessage.Field.location.rawValue): [.string("Chicago")],
        ])
        let report = (weather.standardFieldValue(for: .weatherReport) as? EnumField<WeatherReport>.Value)?.enumValue
        #expect(report == .forecast)
        #expect(report == .hourlyForecast)
        #expect((weather.standardFieldValue(for: .temperature) as? TemperatureField.Value)?.measurement.converted(to: .celsius).value == -4)
        #expect((weather.standardFieldValue(for: .condition) as? EnumField<WeatherStatus>.Value)?.enumValue == .scatteredShowers)
        #expect((weather.standardFieldValue(for: .windSpeed) as? SpeedField.Value)?.measurement.converted(to: .metersPerSecond).value == 4.2)
        #expect((weather.standardFieldValue(for: .dayOfWeek) as? EnumField<DayOfWeek>.Value)?.enumValue == .saturday)
        #expect(weather.standardFieldValue(for: .location)?.format() == "Chicago")
    }
}
