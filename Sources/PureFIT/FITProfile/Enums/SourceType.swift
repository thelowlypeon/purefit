//
//  SourceType.swift
//  PureFIT
//
//  Created by Peter Compernolle on 6/8/25.
//

public enum SourceType: UInt8, FITEnum, CaseIterable, Sendable {
    case ant = 0
    case antplus = 1
    case bluetooth = 2
    case bluetoothLowEnergy = 3
    case wifi = 4
    case usb = 5
    case file = 6
    case paired = 7
    case other = 8
}
