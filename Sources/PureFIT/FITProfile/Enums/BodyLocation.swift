//
//  BodyLocation.swift
//  PureFIT
//
//  Created by Peter Compernolle on 6/8/25.
//

public enum BodyLocation: UInt8, FITEnum, CaseIterable, Sendable {
    case leftLeg = 0
    case leftCalf = 1
    case leftShin = 2
    case leftHamstring = 3
    case leftQuad = 4
    case leftGlute = 5
    case rightLeg = 6
    case rightCalf = 7
    case rightShin = 8
    case rightHamstring = 9
    case rightQuad = 10
    case rightGlute = 11
    case torsoBack = 12
    case leftLowerBack = 13
    case leftUpperBack = 14
    case rightLowerBack = 15
    case rightUpperBack = 16
    case torsoFront = 17
    case leftAbdomen = 18
    case leftChest = 19
    case rightAbdomen = 20
    case rightChest = 21
    case leftArm = 22
    case leftShoulder = 23
    case leftBicep = 24
    case leftTricep = 25
    case leftBrachioradialis = 26
    case leftForearmExtensors = 27
    case rightArm = 28
    case rightShoulder = 29
    case rightBicep = 30
    case rightTricep = 31
    case rightBrachioradialis = 32
    case rightForearmExtensors = 33
    case neck = 34
    case throat = 35
    case waistMidBack = 36
    case waistFront = 37
    case waistLeft = 38
    case waistRight = 39
}
