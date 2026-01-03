//
//  DisplayMeasure.swift
//  PureFIT
//
//  Created by Peter Compernolle on 6/8/25.
//

public enum DisplayMeasure: UInt8, FITEnum, Sendable {
    case metric = 0
    case statute = 1
    case nautical = 2
}
