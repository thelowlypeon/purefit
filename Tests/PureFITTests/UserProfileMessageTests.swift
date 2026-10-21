//
//  UserProfileMessageTests.swift
//  PureFIT
//

import Foundation
import Testing
@testable import PureFIT

struct UserProfileMessageTests {
    @Test func readUserProfileData() async throws {
        let fit = try Fixture.garminCycling.pureFITFile()

        let userProfileMessages = fit.messages.compactMap { $0 as? UserProfileMessage }
        #expect(userProfileMessages.count == 1)
        let userProfileMessage = try #require(userProfileMessages.first)
        let friendlyName = (userProfileMessage.standardFieldValue(for: .friendlyName) as? StringField.Value)?.string
        #expect(friendlyName == "edge530")
        let gender = (userProfileMessage.standardFieldValue(for: .gender) as? EnumField<Gender>.Value)?.enumValue
        #expect(gender == .male)
        let ageField = userProfileMessage.standardFieldValue(for: .age) as? IntegerField.Value
        #expect(ageField?.format() == "35 Years")
        let height = (userProfileMessage.standardFieldValue(for: .height) as? DistanceField.Value)?.measurement
        #expect(height?.converted(to: .meters).value == 1.90)
        let weight = (userProfileMessage.standardFieldValue(for: .weight) as? MassField.Value)?.measurement
        #expect(weight?.converted(to: .kilograms).value == 68.7)
        let language = (userProfileMessage.standardFieldValue(for: .language) as? EnumField<Language>.Value)?.enumValue
        #expect(language == .english)
        let elevationSetting = (userProfileMessage.standardFieldValue(for: .elevationSetting) as? EnumField<DisplayMeasure>.Value)?.enumValue
        #expect(elevationSetting == .statute)
        let weightSetting = (userProfileMessage.standardFieldValue(for: .weightSetting) as? EnumField<DisplayMeasure>.Value)?.enumValue
        #expect(weightSetting == .statute)
        let restingHR = userProfileMessage.standardFieldValue(for: .restingHeartRate) as? IntegerField.Value
        #expect(restingHR?.format() == "43 bpm")
        let defaultMaxBikingHR = userProfileMessage.standardFieldValue(for: .defaultMaxBikingHeartRate) as? IntegerField.Value
        #expect(defaultMaxBikingHR?.format() == "185 bpm")
        let defaultMaxHR = userProfileMessage.standardFieldValue(for: .defaultMaxHeartRate) as? IntegerField.Value
        #expect(defaultMaxHR?.format() == "185 bpm")
        let hrSetting = (userProfileMessage.standardFieldValue(for: .hrSetting) as? EnumField<DisplayHeartRate>.Value)?.enumValue
        #expect(hrSetting == .max)
        let speedSetting = (userProfileMessage.standardFieldValue(for: .speedSetting) as? EnumField<DisplayMeasure>.Value)?.enumValue
        #expect(speedSetting == .statute)
        let distSetting = (userProfileMessage.standardFieldValue(for: .distanceSetting) as? EnumField<DisplayMeasure>.Value)?.enumValue
        #expect(distSetting == .statute)
        let powerSetting = (userProfileMessage.standardFieldValue(for: .powerSetting) as? EnumField<DisplayPower>.Value)?.enumValue
        #expect(powerSetting == .percentFTP)
        let wakeTime = (userProfileMessage.standardFieldValue(for: .wakeTime) as? DurationField.Value)?.measurement
        #expect(wakeTime?.converted(to: .seconds).value == 21600)
        let sleepTime = (userProfileMessage.standardFieldValue(for: .sleepTime) as? DurationField.Value)?.measurement
        #expect(sleepTime?.converted(to: .seconds).value == 79200)
    }

    @Test func globalID() throws {
        let message = UserProfileMessage(fields: [.standard(UserProfileMessage.Field.globalId.rawValue): [.bytes([0x01, 0x02, 0x0A, 0xB0, 0xFF, 0x00])]])
        let globalID = try #require(message.standardFieldValue(for: .globalId) as? BytesField.Value)
        #expect(globalID.bytes == [0x01, 0x02, 0x0A, 0xB0, 0xFF, 0x00])
        #expect(globalID.format() == "01020AB0FF00")
    }
}
