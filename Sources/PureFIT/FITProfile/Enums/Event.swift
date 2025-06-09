//
//  Event.swift
//  PureFIT
//
//  Created by Peter Compernolle on 6/8/25.
//

public enum Event: UInt8, FITEnum, Sendable {
    case timer = 0
    case workout = 3
    case workoutStep = 4
    case powerDown = 5
    case powerUp = 6
    case offCourse = 7
    case session = 8
    case lap = 9
    case coursePoint = 10
    case battery = 11
    case virtualPartnerPace = 12
    case hrHighAlert = 13
    case hrLowAlert = 14
    case speedHighAlert = 15
    case speedLowAlert = 16
    case cadHighAlert = 17
    case cadLowAlert = 18
    case powerHighAlert = 19
    case powerLowAlert = 20
    case recoveryHr = 21
    case batteryLow = 22
    case timeDurationAlert = 23
    case distanceDurationAlert = 24
    case calorieDurationAlert = 25
    case activity = 26
    case fitnessEquipment = 27
    case length = 28
    case userMarker = 32
    case sportPoint = 33
    case calibration = 36
    case frontGearChange = 42
    case rearGearChange = 43
    case riderPositionChange = 44
    case elevHighAlert = 45
    case elevLowAlert = 46
    case commTimeout = 47
    case autoActivityDetect = 54
    case diveAlert = 56
    case diveGasSwitched = 57
    case tankPressureReserve = 71
    case tankPressureCritical = 72
    case tankLost = 73
    case radarThreatAlert = 75
    case tankBatteryLow = 76
    case tankPodConnected = 81
    case tankPodDisconnected = 82
}
