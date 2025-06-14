//
//  FITHeader.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/11/25.
//

public struct FITHeader {
    public let headerSize: UInt8
    public let protocolVersion: UInt8
    public let profileVersion: UInt16
    public let dataSize: UInt32
    public let dataType: String // should always be ".FIT"
    public let crc: FITCRC?
}
extension FITHeader: Sendable {}
