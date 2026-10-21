//
//  PureFITBaseTypeTests.swift
//  PureFIT
//

import Foundation
import Testing
@testable import PureFIT

struct PureFITBaseTypeTests {
    @Test(arguments: [
        (FITValue.enum(7), 7),
        (.sint8(-7), -7),
        (.uint8(200), 200),
        (.uint8z(200), 200),
        (.sint16(-700), -700),
        (.uint16(60_000), 60_000),
        (.uint16z(60_000), 60_000),
        (.sint32(-70_000), -70_000),
        (.uint32(4_000_000_000), 4_000_000_000),
        (.uint32z(4_000_000_000), 4_000_000_000),
        (.sint64(-7_000_000_000), -7_000_000_000),
        (.uint64(7_000_000_000), 7_000_000_000),
        (.uint64z(7_000_000_000), 7_000_000_000),
    ])
    func integerValueAcceptsAnyIntegerBaseType(value: FITValue, expected: Int) {
        #expect(value.integerValue == expected)
        #expect(value.doubleValue == Double(expected))
    }

    @Test func floatsHaveADoubleValueButNoIntegerValue() {
        #expect(FITValue.float32(1.5).doubleValue == 1.5)
        #expect(FITValue.float64(-2.25).doubleValue == -2.25)
        #expect(FITValue.float32(1.5).integerValue == nil)
        #expect(FITValue.float64(-2.25).integerValue == nil)
    }

    @Test func nonNumericValuesHaveNoNumericValue() {
        #expect(FITValue.string("12").integerValue == nil)
        #expect(FITValue.string("12").doubleValue == nil)
        #expect(FITValue.bytes([1, 2]).integerValue == nil)
        #expect(FITValue.bytes([1, 2]).doubleValue == nil)
    }

    @Test func uint64BeyondIntRangeKeepsItsDoubleValue() {
        let value = FITValue.uint64(UInt64(Int.max) + 1)
        #expect(value.integerValue == nil)
        #expect(value.doubleValue == Double(UInt64(Int.max) + 1))
    }

    @Test func fieldsParseValuesWrittenWithADifferentBaseType() {
        let integerField = IntegerField(name: "Integer", baseType: .uint8)
        #expect(integerField.parse(values: [.uint16(300)])?.value == 300)

        let indexField = IndexField(name: "Index", baseType: .uint16)
        #expect(indexField.parse(values: [.uint8(3)])?.value == 3)

        let distanceField = DistanceField(name: "Distance", baseType: .uint16, unit: .meters, scale: 1, offset: 0)
        #expect(distanceField.parse(values: [.uint8(12)])?.measurement == Measurement(value: 12, unit: UnitLength.meters))

        let dateField = DateField(name: "Date")
        #expect(dateField.parse(values: [.uint32z(1)])?.date == Date(garminOffset: 1))
    }

    @Test func definitionsMatchTheProfileBaseType() throws {
        let leftRightBalance = try #require(LapMessage.Field.leftRightBalance.fieldDefinition as? IntegerField)
        #expect(leftRightBalance.baseType == .uint16)
        #expect(leftRightBalance.scale == 100)
        #expect(leftRightBalance.unitSymbol == "%")

        let gpsAccuracy = try #require(LapMessage.Field.gpsAccuracy.fieldDefinition as? DistanceField)
        #expect(gpsAccuracy.baseType == .uint8)

        let antTransmissionType = try #require(DeviceInfoMessage.Field.antTransmissionType.fieldDefinition as? IntegerField)
        #expect(antTransmissionType.baseType == .uint8z)

        let antDeviceNumber = try #require(DeviceInfoMessage.Field.antDeviceNumber.fieldDefinition as? IntegerField)
        #expect(antDeviceNumber.baseType == .uint16z)
    }

    @Test func lapLeftRightBalanceParses() throws {
        let fit = try Fixture.garminCycling.pureFITFile()
        let laps = fit.messages.compactMap { $0 as? LapMessage }
        #expect(laps.first?.values(at: .leftRightBalance) == [.uint16(37308)])
        #expect(laps.allSatisfy { $0.standardFieldValue(for: .leftRightBalance) != nil })
    }
}
