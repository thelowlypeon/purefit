//
//  Gender.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/3/26.
//

// NOTE: This is, unfortunately, all Garmin-defined gender options as of FIT 21.188.00
enum Gender: UInt8, FITEnum {
    case female = 0
    case male = 1
}
