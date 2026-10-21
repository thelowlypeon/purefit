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
}
