//
//  AutoSyncFrequency.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/3/26.
//


public enum AutoSyncFrequency: UInt8, FITEnum, Sendable {
    case never = 0
    case occasionally = 1
    case frequent = 2
    case once_a_day = 3
    case remote = 4
}
