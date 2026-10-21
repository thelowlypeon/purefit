//
//  SwimStroke.swift
//  PureFIT
//

public enum SwimStroke: UInt8, FITEnum, Sendable {
    case freestyle = 0
    case backstroke = 1
    case breaststroke = 2
    case butterfly = 3
    case drill = 4
    case mixed = 5
    case im = 6
    case imByRound = 7
    case rimo = 8
}
