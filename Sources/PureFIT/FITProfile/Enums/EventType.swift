//
//  EventType.swift
//  PureFIT
//
//  Created by Peter Compernolle on 6/8/25.
//

public enum EventType: UInt8, FITEnum, Sendable {
    case start = 0
    case stop = 1
    case consecutiveDepreciated = 2
    case marker = 3
    case stopAll = 4
    case beginDepreciated = 5
    case endDepreciated = 6
    case endAllDepreciated = 7
    case stopDisable = 8
    case stopDisableAll = 9
}
