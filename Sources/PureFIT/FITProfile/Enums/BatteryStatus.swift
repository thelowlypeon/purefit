//
//  BatteryStatus.swift
//  PureFIT
//
//  Created by Peter Compernolle on 6/8/25.
//

public enum BatteryStatus: UInt8, FITEnum, CaseIterable, Sendable {
    case `new` = 1
    case good = 2
    case ok = 3
    case low = 4
    case critical = 5
    case charging = 6
    case unknown = 7
}
