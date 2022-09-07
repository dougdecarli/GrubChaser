//
//  DoubleExtensions.swift
//  GrubChaser
//
//  Created by Douglas Immig on 03/09/22.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
