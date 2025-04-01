//
//  UnitAngle+garminSemicircle.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

import Foundation

extension UnitAngle {
    static let garminSemicircle = UnitAngle(
        symbol: "semicircle",
        converter: UnitConverterLinear(coefficient: 180.0 / 2147483648.0)
    )
}
