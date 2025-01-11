//
//  UInt8+bitString.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/11/25.
//

extension UInt8 {
    var bitString: String {
        let bits = (0..<8).map { (self >> (7 - $0)) & 1 }
        return bits.map(String.init).joined(separator: " ")
    }
}
