//
//  BacklightMode.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/3/26.
//

public enum BacklightMode: UInt8, FITEnum, Sendable {
    case off = 0
    case manual = 1
    case keyAndMessages = 2
    case autoBrightness = 3
    case smartNotifications = 4
    case keyAndMessagesNight = 5
    case keyAndMessagesAndSmartNotifications = 6
}
