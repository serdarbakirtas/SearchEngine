//
//  Double.swift
//  Pods
//
//  Created by away4m on 12/30/16.
//
//

import Foundation

// MARK: - Properties
public extension Double {

    // Absolute of double value.
    public var abs: Double {
        return Swift.abs(self)
    }

    // String with number and current locale currency.
    public var asLocaleCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.string(from: self as NSNumber)!
    }

    // Ceil of double value.
    public var ceil: Double {
        return Foundation.ceil(self)
    }

    // Radian value of degree input.
    public var degreesToRadians: Double {
        return Double(Double.pi) * self / 180.0
    }

    // Floor of double value.
    public var floor: Double {
        return Foundation.floor(self)
    }

    // Degree value of radian input.
    public var radiansToDegrees: Double {
        return self * 180 / Double(Double.pi)
    }

    /// Generate a random Double bounded by a closed interval range.
    public static func random(_ range: ClosedRange<Double>) -> Double {
        return Double(arc4random()) / Double(UInt64(UINT32_MAX)) * (range.upperBound - range.lowerBound) + range.lowerBound
    }

    /// Generate a random Double bounded by a range from min to max.
    public static func random(min: Double, max: Double) -> Double {
        return random(min ... max)
    }

    public func roundToPlaces(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return Darwin.round(self * divisor) / divisor
    }
}

// MARK: - Operators

infix operator **
// Value of exponentiation.
///
/// - Parameters:
///   - lhs: base double.
///   - rhs: exponent double.
/// - Returns: exponentiation result (example: 4.4 ** 0.5 = 2.0976176963).
public func ** (lhs: Double, rhs: Double) -> Double {
    // http://nshipster.com/swift-operators/
    return pow(lhs, rhs)
}

prefix operator √
// Square root of double.
///
/// - Parameter int: double value to find square root for
/// - Returns: square root of given double.
public prefix func √ (double: Double) -> Double {
    // http://nshipster.com/swift-operators/
    return sqrt(double)
}

infix operator ±
// Tuple of plus-minus operation.
///
/// - Parameters:
///   - lhs: double number
///   - rhs: double number
/// - Returns: tuple of plus-minus operation (example: 2.5 ± 1.5 -> (4, 1)).
public func ± (lhs: Double, rhs: Double) -> (Double, Double) {
    // http://nshipster.com/swift-operators/
    return (lhs + rhs, lhs - rhs)
}

prefix operator ±
// Tuple of plus-minus operation.
///
/// - Parameter int: double number
/// - Returns: tuple of plus-minus operation (example: ± 2.5 -> (2.5, -2.5)).
public prefix func ± (double: Double) -> (Double, Double) {
    // http://nshipster.com/swift-operators/
    return 0 ± double
}
