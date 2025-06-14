//
//  LapTrigger.swift
//  PureFIT
//
//  Created by Peter Compernolle on 6/14/25.
//

public enum LapTrigger: UInt8, FITEnum, Sendable {
    case manual = 0
    case time = 1
    case distance = 2
    case positionStart = 3
    case positionLap = 4
    case positionWaypoint = 5
    case positionMarked = 6
    case sessionEnd = 7
    case fitnessEquipment = 8
}
