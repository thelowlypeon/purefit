//
//  UInt16+bitString.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/11/25.
//

extension UInt16 {
    var bitString: String {
        let bits = (0..<16).map { (self >> (15 - $0)) & 1 }
        return bits.map(String.init).joined(separator: " ")
    }
}
