//
//  FieldValue.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

import Foundation

public protocol FieldValue {
    func format(locale: Locale) -> String
}
extension FieldValue {
    public func format() -> String {
        format(locale: .current)
    }
}
