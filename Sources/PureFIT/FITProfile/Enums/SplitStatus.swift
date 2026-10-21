//
//  SplitStatus.swift
//  PureFIT
//

public enum SplitStatus: UInt8, FITEnum, Sendable {
    case failure = 0
    case success = 1
    case climbAttempted = 2
    case climbCompleted = 3
}
