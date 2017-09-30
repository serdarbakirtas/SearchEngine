//
//  Float64.swift
//  Pods
//
//  Created by Admin on 11/24/16.
//
//

import Foundation
import UIKit

public extension Float64 {
    public func secondsToHoursMinutesSeconds() -> (Float64, Float64, Float64, Int) {
        let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 100)
        let seconds = self.truncatingRemainder(dividingBy: 60)
        let minutes = (self / 60).truncatingRemainder(dividingBy: 60)
        let hours = (self / 3600)

        return (hours, minutes, seconds, ms)
    }

    public func toFormattedTimeString() -> String {
        let time = self.secondsToHoursMinutesSeconds()
        if time.0.l > 0 {
            return String(format: "%02d:%02d:%02d", time.0.l, time.1.l, time.2.l)
        } else if time.1.l > 0 {
            return String(format: "%02d:%02d", time.1.l, time.2.l)
        } else {
            return String(format: "%02d.%02d", time.2.l, time.3)
        }

    }
}
