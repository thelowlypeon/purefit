//
//  GarminBoolean.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/3/26.
//

// NOTE: A garmin boolean is actually a two-case UInt8 enum
enum GarminBoolean: UInt8, FITEnum {
    case `false` = 0
    case `true` = 1
}
