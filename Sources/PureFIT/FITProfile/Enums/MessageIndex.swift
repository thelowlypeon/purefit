//
//  MessageIndex.swift
//  PureFIT
//
//  Created by Peter Compernolle on 6/23/25.
//

import Foundation

public struct MessageIndex: CompositeFieldSchema {
    public let rawValue: UInt16

    public enum SubField: CompositeFieldDefinition {
        case index(UInt16)
        case isSelected(Bool)
        case reserved(UInt8)

        public func format(locale: Locale = .current) -> String {
            switch self {
            case .index(value: let index): String(describing: index)
            case .isSelected(value: let isSelected): String(describing: isSelected)
            case .reserved(value: let reserved): String(describing: reserved)
            }
        }

        public var name: String {
            switch self {
            case .index: "Index"
            case .isSelected: "Is Selected"
            case .reserved: "Reserved"
            }
        }
    }

    public var values: [SubField] {
        var values: [SubField] = [.index(rawValue & 0x0FFF)]
        if (rawValue & 0x8000) != 0 {
            values.append(.isSelected(true))
        }
        let reserved = UInt8((rawValue & 0x7000) >> 12)
        if reserved != 0 {
            values.append(.reserved(reserved))
        }
        return values
    }

    public init?(fitValue: FITValue) {
        guard case .uint16(let rawValue) = fitValue
        else { return nil }
        self.rawValue = rawValue
    }

}
