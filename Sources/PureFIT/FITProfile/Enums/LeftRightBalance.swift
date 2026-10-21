//
//  LeftRightBalance.swift
//  PureFIT
//

import Foundation

public enum LeftRightBalanceSubField: CompositeFieldDefinition {
    case contribution(Double)
    // The profile only flags right; an unset bit means the side is unknown, not left.
    case isRight(Bool)

    public func format(locale: Locale = .current) -> String {
        switch self {
        case .contribution(let percent):
            let formatter = NumberFormatter()
            formatter.locale = locale
            formatter.maximumFractionDigits = 2
            return "\(formatter.string(from: NSNumber(value: percent)) ?? String(describing: percent)) %"
        case .isRight(let isRight):
            return String(describing: isRight)
        }
    }

    public var name: String {
        switch self {
        case .contribution: "Contribution"
        case .isRight: "Right"
        }
    }
}

/// `left_right_balance`: an 8-bit percentage with a right-side flag.
public struct LeftRightBalance: CompositeFieldSchema {
    public let rawValue: UInt8

    public var values: [LeftRightBalanceSubField] {
        var values: [LeftRightBalanceSubField] = [.contribution(Double(rawValue & 0x7F))]
        if (rawValue & 0x80) != 0 {
            values.append(.isRight(true))
        }
        return values
    }

    public init?(fitValue: FITValue) {
        guard let integerValue = fitValue.integerValue, let rawValue = UInt8(exactly: integerValue)
        else { return nil }
        self.rawValue = rawValue
    }
}

/// `left_right_balance_100`: a 16-bit percentage scaled by 100, with a right-side flag.
public struct LeftRightBalance100: CompositeFieldSchema {
    public let rawValue: UInt16

    public var values: [LeftRightBalanceSubField] {
        var values: [LeftRightBalanceSubField] = [.contribution(Double(rawValue & 0x3FFF) / 100)]
        if (rawValue & 0x8000) != 0 {
            values.append(.isRight(true))
        }
        return values
    }

    public init?(fitValue: FITValue) {
        guard let integerValue = fitValue.integerValue, let rawValue = UInt16(exactly: integerValue)
        else { return nil }
        self.rawValue = rawValue
    }
}
