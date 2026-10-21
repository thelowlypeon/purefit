//
//  ApneaDiscipline.swift
//  PureFIT
//

public enum ApneaDiscipline: UInt8, FITEnum, Sendable {
    case constantWeightWithFins = 0
    case constantWeightWithBifins = 1
    case constantWeightWithoutFins = 2
    case dynamicWithFins = 3
    case dynamicWithBifins = 4
    case dynamicWithoutFins = 5
    case freeImmersion = 6
    case noLimit = 7
    case speedEnduranceApnea = 8
    case staticApnea = 9
    case variableWeight = 10
}
