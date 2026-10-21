//
//  FieldDefinitionNumberTests.swift
//  PureFIT
//

import Testing
@testable import PureFIT

struct FieldDefinitionNumberTests {
    @Test func standardFieldsSortByNumber() {
        let fields: [FieldDefinitionNumber] = [.standard(253), .standard(0), .standard(4)]
        #expect(fields.sorted() == [.standard(0), .standard(4), .standard(253)])
    }

    @Test func developerFieldsSortAfterStandardFields() {
        let fields: [FieldDefinitionNumber] = [.developer(0, 0), .standard(253)]
        #expect(fields.sorted() == [.standard(253), .developer(0, 0)])
    }

    @Test func developerFieldsSortByIndexThenFieldNumber() {
        let fields: [FieldDefinitionNumber] = [.developer(1, 1), .developer(0, 2), .developer(1, 0), .developer(0, 5)]
        #expect(fields.sorted() == [.developer(0, 2), .developer(0, 5), .developer(1, 0), .developer(1, 1)])
    }

    @Test func developerFieldOrderingIsAsymmetric() {
        #expect(FieldDefinitionNumber.developer(0, 2) < .developer(1, 1))
        #expect(!(FieldDefinitionNumber.developer(1, 1) < .developer(0, 2)))
    }
}
