//
//  ActivityClass.swift
//  PureFIT
//
//  Created by Peter Compernolle on 6/8/25.
//

public enum ActivityClass: UInt8, FITEnum, Sendable {
    case level = 0x7F // 0 to 100
    case levelMax = 100
    case athlete = 0x80
}
