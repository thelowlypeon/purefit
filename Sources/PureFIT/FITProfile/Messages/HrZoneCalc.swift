//
//  HrZoneCalc.swift
//  PureFIT
//
//  Created by Peter Compernolle on 2/28/26.
//

public enum HrZoneCalc: UInt8, FITEnum, Sendable {
    case custom = 0
    case percentMaxHeartRate = 1
    case percentRestingHeartRate = 2
    case percentLactateThreshold = 3
}
