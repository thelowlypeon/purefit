//
//  DisplayOrientation.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/3/26.
//

public enum DisplayOrientation: UInt8, FITEnum, Sendable {
    case auto = 0 // automatic if the device supports it
    case portrait = 1
    case landscape = 2
    case portrait_flipped = 3 // portrait mode but rotated 180 degrees
    case landscape_flipped = 4 // landscape mode but rotated 180 degrees
}
