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
}
