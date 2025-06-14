//
//  Intensity.swift
//  PureFIT
//
//  Created by Peter Compernolle on 6/14/25.
//

public enum Intensity: UInt8, FITEnum, Sendable {
    case active = 0
    case rest = 1
    case warmup = 2
    case cooldown = 3
    case recovery = 4
    case interval = 5
    case other = 6
}
