//
//  DisplayHeartRate.swift
//  PureFIT
//
//  Created by Peter Compernolle on 6/8/25.
//

public enum DisplayHeartRate: UInt8, FITEnum, Sendable {
    case bpm = 0
    case max = 1
    case reserve = 2
}
