//
//  DeviceInfoMessageTests.swift
//  PureFIT
//

import Foundation
import Testing
@testable import PureFIT

struct DeviceInfoMessageTests {
    @Test func readDeviceInfoData() async throws {
        let fit = try Fixture.garminCycling.pureFITFile()
        let deviceInfoMessages = fit.messages.compactMap { $0 as? DeviceInfoMessage }
        #expect(deviceInfoMessages.count == 14)
    }

    @Test func deviceInfoFractionalValues() throws {
        let fit = try Fixture.garminCycling.pureFITFile()
        let deviceInfo = fit.messages.compactMap { $0 as? DeviceInfoMessage }[11]
        #expect(deviceInfo.value(at: .deviceIndex) == .uint8(4))
        #expect((deviceInfo.standardFieldValue(for: .softwareVersion) as? DoubleField.Value)?.value == 16.03)
        #expect((deviceInfo.standardFieldValue(for: .batteryVoltage) as? DoubleField.Value)?.value == 2.7890625)
    }
}
