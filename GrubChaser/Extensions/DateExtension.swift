//
//  DateExtension.swift
//  GrubChaser
//
//  Created by Douglas Immig on 26/09/22.
//

import Foundation

extension Date {
    static func getDateFormatter(timestamp: Double) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = getDateFormatterConfig()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    static func getDateFormatterConfig() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.locale = .current
        return dateFormatter
    }
}
