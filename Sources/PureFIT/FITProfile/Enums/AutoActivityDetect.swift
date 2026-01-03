//
//  AutoActivityDetect.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/3/26.
//

public enum AutoActivityDetect: UInt32, FITEnum, Sendable {
    case none = 0x00000000
    case running = 0x00000001
    case cycling = 0x00000002
    case swimming = 0x00000004
    case walking = 0x00000008
    case elliptical = 0x00000020
    case sedentary = 0x00000400
}
