//
//  FileIDMessageTests.swift
//  PureFIT
//

import Foundation
import Testing
@testable import PureFIT

struct FileIDMessageTests {
    @Test func readFileIDData() async throws {
        let fit = try Fixture.garminCycling.pureFITFile()
        let fileIDMessages = fit.messages.compactMap { $0 as? FileIDMessage }
        #expect(fileIDMessages.count == 1)
    }

    @Test func fileNumber() throws {
        let message = FileIDMessage(fields: [.standard(FileIDMessage.Field.number.rawValue): [.uint16(42)]])
        #expect((message.standardFieldValue(for: .number) as? IntegerField.Value)?.value == 42)
    }
}
