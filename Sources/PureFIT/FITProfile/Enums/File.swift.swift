//
//  File.swift.swift
//  PureFIT
//
//  Created by Peter Compernolle on 6/8/25.
//

public enum File: UInt8, FITEnum, Sendable {
    case device = 1
    case settings = 2
    case sport = 3
    case activity = 4
    case workout = 5
    case course = 6
    case schedules = 7
    case weight = 9
    case totals = 10
    case goals = 11
    case bloodPressure = 14
    case monitoringA = 15
    case activitySummary = 20
    case monitoringDaily = 28
    case monitoringB = 32
    case segment = 34
    case segmentList = 35
    case exdConfiguration = 40
}
