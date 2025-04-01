//
//  UnitSpeed+minutesPerMile.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

import Foundation

final class UnitConverterInverse: UnitConverter {
    let coefficient: Double

    init(coefficient: Double) {
        self.coefficient = coefficient
    }

    override func baseUnitValue(fromValue value: Double) -> Double {
        return coefficient / value
    }

    override func value(fromBaseUnitValue baseUnitValue: Double) -> Double {
        return coefficient / baseUnitValue
    }
}

extension Measurement where UnitType == UnitSpeed {
    func formattedPace() -> String {
        let paceInMinPerMile = self.converted(to: .minutesPerMile).value

        var wholeMinutes = Int(paceInMinPerMile)
        let fraction = paceInMinPerMile - Double(wholeMinutes)
        var seconds = Int(round(fraction * 60))

        if seconds == 60 {
            wholeMinutes += 1
            seconds = 0
        }

        return String(format: "%d:%02d", wholeMinutes, seconds)
    }
}

extension UnitSpeed {
    static let minutesPerMile: UnitSpeed = {
        let milesPerMinuteInMetersPerSecond = 1609.344 / 60.0
        return UnitSpeed(
            symbol: "/mi",
            converter: UnitConverterInverse(coefficient: milesPerMinuteInMetersPerSecond)
        )
    }()
}
