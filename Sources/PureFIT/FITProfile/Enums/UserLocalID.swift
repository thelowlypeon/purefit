//
//  UserLocalID.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/3/26.
//

enum UserLocalID: UInt16, FITEnum, Sendable {
    case localMin = 0x0000
    case localMax = 0x000F
    case stationaryMin = 0x0010
    case stationaryMax = 0x00FF
    case portableMin = 0x0100
    case portableMax = 0xFFFE
}
