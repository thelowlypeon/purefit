//
//  PureFITFileTests.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/15/25.
//

import Testing
import Foundation
@testable import PureFIT

struct PureFITFileTests {
    @Test func parsingGarminFITFile() async throws {
        let url = Bundle.module.url(forResource: "cyclingActivityFromGarmin", withExtension: "fit", subdirectory: "Fixtures")!
        let raw = try RawFITFile(url: url)
        let fit = try PureFITFile(rawFITFile: raw)
        #expect(fit.messages.count == 23291)
    }

    @Test func parsingFITFile() async throws {
        let url = Bundle.module.url(forResource: "fitfile1", withExtension: "fit", subdirectory: "Fixtures")!
        let raw = try RawFITFile(url: url)
        let fit = try PureFITFile(rawFITFile: raw)

        // fileId message
        #expect(fit.messages.count(where: { $0.globalMessageNumber == 0 }) == 1)
        let fileIdMessage = try #require(fit.messages.first(where: { $0.globalMessageNumber == 0 }))
        #expect(fileIdMessage.fields.keys.sorted() == [.standard(0),.standard(1),.standard(3),.standard(4)])
        let fileType = try #require(fileIdMessage.value(at: .standard(0)))
        #expect(fileType == .enum(4)) // file type
        let manufacturer = try #require(fileIdMessage.value(at: .standard(1)))
        #expect(manufacturer == .uint16(255)) // manufacturer
        let serial = try #require(fileIdMessage.value(at: .standard(3)))
        #expect(serial == .uint32z(282475249)) // serial
        let timeCreated = try #require(fileIdMessage.value(at: .standard(4)))
        #expect(timeCreated == .uint32(1100201060)) // time created

        // developer data id
        #expect(fit.messages.count(where: { $0.globalMessageNumber == 207 }) == 1)
        let developerDataIdMessage = try #require(fit.messages.filter { $0.globalMessageNumber == 207 }.first)
        #expect(developerDataIdMessage.value(at: 1) == .bytes([87, 111, 114, 107, 79, 117, 116, 68, 111, 111, 114, 115, 32, 65, 112, 112]))

        // record messages
        #expect(fit.messages.count(where: { $0.globalMessageNumber == 20 }) == 4257)
        let secondRecordMessage = fit.messages.filter { $0.globalMessageNumber == 20 }[1]
        #expect(secondRecordMessage.fields.keys.sorted() == [
            .standard(0),.standard(1),.standard(2),.standard(3),.standard(4),.standard(5),.standard(6),.standard(7),.standard(39),.standard(41),.standard(253),
            .developer(0, 5), .developer(0, 6), .developer(0, 8), .developer(0, 9), .developer(0, 11)
        ])
        let timestamp = try #require(secondRecordMessage.value(at: 253))
        #expect(timestamp == .uint32(1096542999))
        let latitude = try #require(secondRecordMessage.value(at: 0))
        #expect(latitude == .sint32(500395805))
        let longitude = try #require(secondRecordMessage.value(at: 1))
        #expect(longitude == .sint32(-1045723574))
        let altitude = try #require(secondRecordMessage.value(at: 2))
        #expect(altitude == .uint16(3415))
        let distance = try #require(secondRecordMessage.value(at: 5))
        #expect(distance == .uint32(1400))
        let speed = try #require(secondRecordMessage.value(at: 6))
        #expect(speed == .uint16(2434))
        let heartRate = try #require(secondRecordMessage.value(at: 3))
        #expect(heartRate == .uint8(118))
        let cadence = try #require(secondRecordMessage.value(at: 4))
        #expect(cadence == .uint8(86))
        let verticalOscillation = try #require(secondRecordMessage.value(at: 39))
        #expect(verticalOscillation == .uint16(540))
        let stanceTime = try #require(secondRecordMessage.value(at: 41))
        #expect(stanceTime == .uint16(2520))
        let power = try #require(secondRecordMessage.value(at: 7))
        #expect(power == .uint16(190))

        // developer fields
        let developerFieldDefinitions = fit.messages.filter { $0.globalMessageNumber == 206 }
        #expect(developerFieldDefinitions.count == 5)
        #expect(secondRecordMessage.value(at: .developer(0, 5)) == .float32(2.43359375))
        #expect(secondRecordMessage.value(at: .developer(0, 6)) == .uint32(14))
        #expect(secondRecordMessage.value(at: .developer(0, 8)) == .uint16(61))
        #expect(secondRecordMessage.value(at: .developer(0, 9)) == .float32(11.25))
        #expect(secondRecordMessage.value(at: .developer(0, 11)) == .uint16(5))
    }
}
