//
//  SportEvent.swift
//  PureFIT
//

public enum SportEvent: UInt8, FITEnum, Sendable {
    case uncategorized = 0
    case geocaching = 1
    case fitness = 2
    case recreation = 3
    case race = 4
    case specialEvent = 5
    case training = 6
    case transportation = 7
    case touring = 8
}
