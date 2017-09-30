//
//  CGFloat.swift
//  Pods
//
//  Created by away4m on 12/30/16.
//
//

import Foundation

/** The value of π as a CGFloat */
let π = CGFloat(Double.pi)
// MARK: - Properties
public extension CGFloat {

    /**
     * Returns 1.0 if a floating point value is positive; -1.0 if it is negative.
     */
    public func sign() -> CGFloat {
        return (self >= 0.0) ? 1.0 : -1.0
    }

    // Absolute of CGFloat value.
    public var abs: CGFloat {
        return Swift.abs(self)
    }

    // Ceil of CGFloat value.
    public var ceil: CGFloat {
        return Foundation.ceil(self)
    }

    // Radian value of degree input.
    public var degreesToRadians: CGFloat {
        return CGFloat(Double.pi) * self / 180.0
    }

    // Floor of CGFloat value.
    public var floor: CGFloat {
        return Foundation.floor(self)
    }

    // Degree value of radian input.
    public var radiansToDegrees: CGFloat {
        return self * 180 / CGFloat(Double.pi)
    }

    /// Generate a random CGFloat bounded by a closed interval range.
    public static func random(_ range: ClosedRange<CGFloat>) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt64(UINT32_MAX)) * (range.upperBound - range.lowerBound) + range.lowerBound
    }

    /// Generate a random CGFloat bounded by a range from min to max.
    public static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random(min ... max)
    }

    /**
     Round self to a specified number of decimal places.

     - parameter places: The number of decimal places by which to round self.
     - returns: A CGFloat value, rounded to the specified number of decimal places.

     Examples:
     ```
     let val: CGFloat = 12.345678

     val.rounded(places: 2) // 12.35
     val.rounded(places: 3) // 12.346
     ```
     */
    public func rounded(places: UInt) -> CGFloat {
        let multiplier = pow(10, CGFloat(places))
        return (self * multiplier).rounded() / multiplier
    }

    /**
     * Ensures that the float value stays between the given values, inclusive.
     */
    public func clamped(_ v1: CGFloat, _ v2: CGFloat) -> CGFloat {
        let min = v1 < v2 ? v1 : v2
        let max = v1 > v2 ? v1 : v2
        return self < min ? min : (self > max ? max : self)
    }

    /**
     * Ensures that the float value stays between the given values, inclusive.
     */
    public mutating func clamp(_ v1: CGFloat, _ v2: CGFloat) -> CGFloat {
        self = self.clamped(v1, v2)
        return self
    }

    /**
     * Returns the shortest angle between two angles. The result is always between
     * -π and π.
     */
    public func shortestAngleBetween(_ angle1: CGFloat, angle2: CGFloat) -> CGFloat {
        let twoπ = π * 2.0
        var angle = (angle2 - angle1).truncatingRemainder(dividingBy: twoπ)
        if angle >= π {
            angle = angle - twoπ
        }
        if angle <= -π {
            angle = angle + twoπ
        }
        return angle
    }
    
    public func roundToPlaces(places: Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return Darwin.round(self * divisor) / divisor
    }
}
