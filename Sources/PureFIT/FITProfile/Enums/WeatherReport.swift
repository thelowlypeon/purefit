//
//  WeatherReport.swift
//  PureFIT
//

public enum WeatherReport: UInt8, FITEnum, Sendable {
    case current = 0
    case forecast = 1
    case dailyForecast = 2

    public static let hourlyForecast = WeatherReport.forecast
}
