//
//  ZonesTargetMessageTests.swift
//  PureFIT
//

import Foundation
import Testing
@testable import PureFIT

struct ZonesTargetMessageTests {
    @Test func readZonesTargetData() async throws {
        let fit = try Fixture.garminCycling.pureFITFile()

        let zonesTargetMessages = fit.messages.compactMap { $0 as? ZonesTargetMessage }
        #expect(zonesTargetMessages.count == 1)
        let zonesTargetMessage = try #require(zonesTargetMessages.first)
        let maxHeartRate = (zonesTargetMessage.standardFieldValue(for: .maxHeartRate) as? IntegerField.Value)?.value
        #expect(maxHeartRate == 189)
        let thresholdHeartRate = (zonesTargetMessage.standardFieldValue(for: .thresholdHeartRate) as? IntegerField.Value)?.value
        #expect(thresholdHeartRate == 167)
        let functionalThresholdPower = (zonesTargetMessage.standardFieldValue(for: .functionalThresholdPower) as? PowerField.Value)?.measurement.converted(to: .watts).value
        #expect(functionalThresholdPower == 213)
        let hrCalcType = (zonesTargetMessage.standardFieldValue(for: .hrCalcType) as? EnumField<HrZoneCalc>.Value)?.enumValue
        #expect(hrCalcType == .percentLactateThreshold)
        let pwrCalcType = (zonesTargetMessage.standardFieldValue(for: .pwrCalcType) as? EnumField<PwrZoneCalc>.Value)?.enumValue
        #expect(pwrCalcType == .percentFtp)
    }
}
