//
//  DeviceSettingsMessageTests.swift
//  PureFIT
//

import Foundation
import Testing
@testable import PureFIT

struct DeviceSettingsMessageTests {
    @Test func readDeviceSettingsData() async throws {
        let fit = try Fixture.garminCycling.pureFITFile()

        let deviceSettingsMessages = fit.messages.compactMap { $0 as? DeviceSettingsMessage }
        #expect(deviceSettingsMessages.count == 1)
        let deviceSettingsMessage = try #require(deviceSettingsMessages.first)
        let timeOffset = (deviceSettingsMessage.standardFieldValue(for: .timeOffset) as? IntegerField.Value)?.value
        #expect(timeOffset == 4294934776)
        let timeMode = (deviceSettingsMessage.standardFieldValue(for: .timeMode) as? EnumField<TimeMode>.Value)?.enumValue
        #expect(timeMode == .hour24)
        let backlightMode = (deviceSettingsMessage.standardFieldValue(for: .backlightMode) as? EnumField<BacklightMode>.Value)?.enumValue
        #expect(backlightMode == .autoBrightness)
        let lactateThresholdAutoDetectEnabled = (deviceSettingsMessage.standardFieldValue(for: .lactateThresholdAutoDetectEnabled) as? BooleanField.Value)?.booleanValue
        #expect(lactateThresholdAutoDetectEnabled == true)
    }
}
