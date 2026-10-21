//
//  FileCreatorMessageTests.swift
//  PureFIT
//

import Foundation
import Testing
@testable import PureFIT

struct FileCreatorMessageTests {
    @Test func readFileCreatorData() async throws {
        let fit = try Fixture.garminCycling.pureFITFile()
        let fileCreatorMessages = fit.messages.compactMap { $0 as? FileCreatorMessage }
        #expect(fileCreatorMessages.count == 1)
    }
}
