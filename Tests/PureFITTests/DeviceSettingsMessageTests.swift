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

    @Test func deviceSettingsClockTime() async throws {
        let message = DeviceSettingsMessage(fields: [
            .standard(39): [.uint32(1096542999)],
        ])

        #expect(DeviceSettingsMessage.Field.clockTime.rawValue == 39)
        let clockTimeDefinition = try #require(message.fieldDefinition(for: .standard(39), developerFieldDefinitions: [:]) as? DateField)
        #expect(clockTimeDefinition.name == "Clock Time")
        let clockTime = (message.standardFieldValue(for: .clockTime) as? DateField.Value)?.date
        #expect(clockTime == Date(garminOffset: 1096542999))
    }
}
