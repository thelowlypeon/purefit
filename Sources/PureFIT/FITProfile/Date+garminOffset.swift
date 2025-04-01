//
//  Date+garminOffset.swift
//  PureFIT
//
//  Created by Peter Compernolle on 3/26/25.
//

import Foundation

extension Date {
    init(garminOffset: Double) {
        self.init(timeIntervalSince1970: garminOffset + 631065600)
    }
}
