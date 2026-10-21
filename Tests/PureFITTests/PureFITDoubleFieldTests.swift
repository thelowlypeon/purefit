//
//  PureFITDoubleFieldTests.swift
//  PureFIT
//

import Foundation
import Testing
@testable import PureFIT

struct PureFITDoubleFieldTests {
    @Test func keepsSignAndHundredths() throws {
        let grade = try #require(RecordMessage.Field.grade.fieldDefinition as? DoubleField)
        #expect(grade.parse(values: [.sint16(537)])?.value == 5.37)
        #expect(grade.parse(values: [.sint16(-537)])?.value == -5.37)
        #expect(grade.parse(values: [.sint16(537)])?.format(locale: Locale(identifier: "en_US")) == "5.37 %")
    }

    @Test func formatUsesLocaleDecimalSeparator() throws {
        let torqueEffectiveness = try #require(RecordMessage.Field.leftTorqueEffectiveness.fieldDefinition as? DoubleField)
        let value = try #require(torqueEffectiveness.parse(values: [.uint8(145)]))
        #expect(value.format(locale: Locale(identifier: "en_US")) == "72.5 %")
        #expect(value.format(locale: Locale(identifier: "de_DE")) == "72,5 %")
    }

    @Test func formatOmitsTrailingZerosAndGrouping() {
        let field = DoubleField(name: "Test", baseType: .uint32, scale: 100)
        #expect(field.parse(values: [.uint32(123_400)])?.format(locale: Locale(identifier: "en_US")) == "1234")
    }

    @Test func appliesOffsetAfterScale() {
        let field = DoubleField(name: "Test", baseType: .uint16, unitSymbol: "m", scale: 4, offset: 10)
        let value = field.parse(values: [.uint16(22)])
        #expect(value?.value == -4.5)
        #expect(value?.unitSymbol == "m")
    }

    @Test func mismatchedBaseTypeStillParses() throws {
        let grade = try #require(RecordMessage.Field.grade.fieldDefinition as? DoubleField)
        #expect(grade.parse(values: [.uint8(5)])?.value == 0.05)
    }
}
