//
//  PureFITEnumFieldTests.swift
//  PureFIT
//
//  Created by Peter Compernolle on 6/8/25.
//

import Foundation
import Testing
@testable import PureFIT

struct PureFITEnumFieldTests {
    @Test func enumStandardFieldValueTest() async throws {
        let url = Bundle.module.url(forResource: "cyclingActivityFromGarmin", withExtension: "fit", subdirectory: "Fixtures")!
        let fit = try PureFITFile(url: url)
        let activityMessage = try #require(fit.messages.compactMap { $0 as? ActivityMessage }.first)
        #expect(activityMessage.values(at: .standard(2)) == [.enum(0)])
        let activityType = try #require(activityMessage.standardFieldValue(for: .type) as? EnumField<Activity>.Value)
        #expect(activityType.rawValue == 0)
        #expect(activityType.enumValue == .manual)
    }

    @Test func enumFromFITValue() async throws {
        let manufacturerFitValue: FITValue = .uint16(1)
        #expect(Manufacturer(fitValue: manufacturerFitValue) == .garmin)
        let activityTypeFitValue: FITValue = .enum(0)
        #expect(Activity(fitValue: activityTypeFitValue) == .manual)
    }

    @Test func enumUInt16StandardFieldValueTest() async throws {
        let url = Bundle.module.url(forResource: "cyclingActivityFromGarmin", withExtension: "fit", subdirectory: "Fixtures")!
        let fit = try PureFITFile(url: url)
        let deviceInfoMessage = try #require(fit.messages.compactMap { $0 as? DeviceInfoMessage }.first)
        #expect(deviceInfoMessage.values(at: .standard(2)) == [.uint16(1)])
        let manufacturer = try #require(deviceInfoMessage.standardFieldValue(for: .manufacturer) as? EnumField<Manufacturer>.Value)
        #expect(manufacturer.rawValue == 1)
        #expect(manufacturer.enumValue == .garmin)
    }

}

