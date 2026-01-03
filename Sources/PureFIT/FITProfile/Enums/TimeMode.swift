//
//  TimeMode.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/3/26.
//

public enum TimeMode: UInt8, FITEnum, Sendable {
    case hour12 = 0
    case hour24 = 1
    case military = 2
    case hour12withSeconds = 3
    case hour24withSeconds = 4
    case utc = 5
}
