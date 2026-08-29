//
//  PureFITFieldDurationTests.swift
//  PureFIT
//
//  Created by Peter Compernolle on 6/8/25.
//

import Foundation
import Testing
@testable import PureFIT

struct PureFITDurationFieldTests {
    @Test func durationStandardFieldValue() async throws {
        let fit = try Fixture.workoutdoorsRunning.pureFITFile()
        let activityMessage = try #require(fit.messages.compactMap { $0 as? ActivityMessage }.first)
        let durationValue = try #require(activityMessage.standardFieldValue(for: .totalTimerTime) as? DurationField.Value)
        #expect(durationValue.duration == 4267.891)
    }

    @Test func durationStandardFieldValueFormatted() async throws {
        let fit = try Fixture.workoutdoorsRunning.pureFITFile()
        let activityMessage = try #require(fit.messages.compactMap { $0 as? ActivityMessage }.first)
        let durationValue = try #require(activityMessage.standardFieldValue(for: .totalTimerTime) as? DurationField.Value)
        #expect(durationValue.format() == "1:11:07")
    }

    @Test func durationStandardFieldValueFormattedWitLocale() async throws {
        let fit = try Fixture.workoutdoorsRunning.pureFITFile()
        let activityMessage = try #require(fit.messages.compactMap { $0 as? ActivityMessage }.first)
        let durationValue = try #require(activityMessage.standardFieldValue(for: .totalTimerTime) as? DurationField.Value)
        #expect(durationValue.format(locale: Locale(identifier: "zh-CN")) == "1:11:07")
    }

    @Test func durationRawValuesFormat() async throws {
        let fit = try Fixture.workoutdoorsRunning.pureFITFile()
        let activityMessage = try #require(fit.messages.compactMap { $0 as? ActivityMessage }.first)
        let durationFieldDefinition = ActivityMessage.Field.totalTimerTime.fieldDefinition
        let rawValues = try #require(activityMessage.values(at: .totalTimerTime))
        #expect(durationFieldDefinition.parse(values: rawValues)?.format() == "1:11:07")
    }

    @Test func durationRawValueFormat() async throws {
        let fit = try Fixture.workoutdoorsRunning.pureFITFile()
        let activityMessage = try #require(fit.messages.compactMap { $0 as? ActivityMessage }.first)
        let durationFieldDefinition = ActivityMessage.Field.totalTimerTime.fieldDefinition
        let rawValue = try #require(activityMessage.value(at: .totalTimerTime))
        #expect(durationFieldDefinition.parse(values: [rawValue])?.format() == "1:11:07")
    }

    @Test func durationRawValue() async throws {
        let fit = try Fixture.workoutdoorsRunning.pureFITFile()
        let activityMessage = try #require(fit.messages.compactMap { $0 as? ActivityMessage }.first)
        let rawValue = try #require(activityMessage.value(at: .totalTimerTime))
        #expect(rawValue == .uint32(4267891))
    }

    @Test func durationAtFieldPath() async throws {
        let fit = try Fixture.workoutdoorsRunning.pureFITFile()
        let activityMessage = try #require(fit.messages.compactMap { $0 as? ActivityMessage }.first)
        let rawValue = try #require(activityMessage.value(at: .standard(0)))
        #expect(rawValue == .uint32(4267891))
    }

    @Test func durationInAllFieldDefinitions() async throws {
        let fit = try Fixture.workoutdoorsRunning.pureFITFile()
        let fieldDefinitions = fit.fieldDefinitions
        let definition = try #require(fieldDefinitions[GlobalMessageType.activity.rawValue]?[.standard(0)] as? DurationField)
        #expect(definition.baseType == .uint32)
        #expect(definition.name == "Total Timer Time")
        #expect(definition.offset == 0)
        #expect(definition.scale == 1000)
        #expect(definition.unit == .seconds)
    }
}
