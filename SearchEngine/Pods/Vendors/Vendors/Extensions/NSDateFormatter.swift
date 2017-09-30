//
//  NSDateFormatter.swift
//  Pods
//
//  Created by ALI KIRAN on 5/18/17.
//
//

import Foundation
import UIKit

extension DateFormatter {
    public static func date(from string: String) -> Date? {
        if string.uppercased().contains("Z") {
            return jsonDateFormatterWithTimeZone.date(from: string)
        } else {
            return jsonDateFormatter.date(from: string.splited(by: ".").first! + "Z" ?? "")
        }
    }

    public static func string(from date: Date, withZone: Bool = true) -> String? {
        return withZone ? jsonDateFormatterWithTimeZone.string(from: date) : jsonDateFormatter.string(from: date)
    }

    public static let jsonDateFormatterWithTimeZone: DateFormatter = {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        fmt.timeZone = TimeZone(secondsFromGMT: 0)
        return fmt
    }()

    public static let jsonDateFormatter: DateFormatter = {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        fmt.timeZone = TimeZone(secondsFromGMT: 0)
//        fmt.timeZone = TimeZone.current
        return fmt
    }()
}
