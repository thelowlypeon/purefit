//
//  BooleanField.swift
//  PureFIT
//
//  Created by Peter Compernolle on 1/3/26.
//

import Foundation

public struct BooleanField: NamedFieldDefinition, Sendable {
    public struct Value: FieldValue {
        let booleanValue: Bool

        public func format(locale: Locale) -> String {
            return String(describing: booleanValue)
        }
    }

    // IMPORTANT: A garmin boolean is actually a two-case uint8 enum, where 1 is true and 0 is false
    //            a BooleanField is therefore really just an alias for EnumField<GarminBoolean>
    public let name: String
    public let baseType: FITBaseType = .enum

    init(name: String) {
        self.name = name
    }

    public func parse(values: [FITValue]) -> Value? {
        guard let fitValue = values.first,
              let garminBoolean = GarminBoolean(fitValue: fitValue)
        else { return nil }
        return Value(booleanValue: garminBoolean == .true)
    }
}
