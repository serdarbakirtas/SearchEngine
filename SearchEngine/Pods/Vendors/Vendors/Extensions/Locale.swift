//
//  Locale.swift
//  Pods
//
//  Created by Admin on 11/24/16.
//
//

import Foundation
import UIKit

public extension Locale {
    public func getTopPreferredLanguage() -> String {
        return Locale.preferredLanguages[0]
    }

    public func getTopPreferredCountryCode() -> String {
        let locale = Locale(identifier: self.getTopPreferredLanguage())
        let countryCode = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String

        return countryCode
    }
}
