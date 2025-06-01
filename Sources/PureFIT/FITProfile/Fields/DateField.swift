//
//  DateField.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

import Foundation

struct DateField: NamedFieldDefinition {
    enum Style {
        case time, date, dateAndTime, custom(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style)
    }

    struct Value: FieldValue {
        let date: Date
        let style: Style

        func format() -> String {
            return date.description // TODO
        }
        func format(locale: Locale) -> String {
            let formatter = DateFormatter()
            switch style {
            case .date:
                formatter.dateStyle = .medium
                formatter.timeStyle = .none
            case .time:
                formatter.dateStyle = .none
                formatter.timeStyle = .medium
            case .dateAndTime:
                formatter.dateStyle = .medium
                formatter.timeStyle = .medium
            case .custom(let dateStyle, let timeStyle):
                formatter.dateStyle = dateStyle
                formatter.timeStyle = timeStyle
            }
            formatter.locale = locale
            return formatter.string(from: date)
        }
    }

    let name: String
    let baseType: FITBaseType
    let style: Style

    init(name: String, baseType: FITBaseType = .uint32, style: Style = .dateAndTime) {
        self.name = name
        self.baseType = baseType
        self.style = style
    }

    func parse(values: [FITValue]) -> Value? {
        guard let doubleValue = values.first?.doubleValue(from: baseType) else { return nil }
        return Value(date: Date(garminOffset: doubleValue), style: style)
    }
}
