//
//  Float.swift
//  Pods
//
//  Created by away4m on 12/30/16.
//
//

import Foundation

// MARK: - Properties
public extension Float {

    // Absolute of float value.
    public var abs: Float {
        return Swift.abs(self)
    }

    // String with number and current locale currency.
    public var asLocaleCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.string(from: self as NSNumber)!
    }

    // Ceil of float value.
    public var ceil: Float {
        return Foundation.ceil(self)
    }

    // Radian value of degree input.
    public var degreesToRadians: Float {
        return Float(Double.pi) * self / 180.0
    }

    // Floor of float value.
    public var floor: Float {
        return Foundation.floor(self)
    }

    // Degree value of radian input.
    public var radiansToDegrees: Float {
        return self * 180 / Float(Double.pi)
    }

    public func roundToPlaces(places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return Darwin.round(self * divisor) / divisor
    }
}

// MARK: - Methods
extension Float {

    // Random float between two float values.
    ///
    /// - Parameters:
    ///   - min: minimum number to start random from.
    ///   - max: maximum number random number end before.
    /// - Returns: random float between two Float values.
    public static func randomBetween(min: Float, max: Float) -> Float {
        let delta = max - min
        return min + Float(arc4random_uniform(UInt32(delta)))
    }

}

// MARK: - Operators

infix operator **
// Value of exponentiation.
///
/// - Parameters:
///   - lhs: base float.
///   - rhs: exponent float.
/// - Returns: exponentiation result (4.4 ** 0.5 = 2.0976176963).
public func ** (lhs: Float, rhs: Float) -> Float {
    // http://nshipster.com/swift-operators/
    return pow(lhs, rhs)
}

prefix operator √
// Square root of float.
///
/// - Parameter int: float value to find square root for
/// - Returns: square root of given float.
public prefix func √ (Float: Float) -> Float {
    // http://nshipster.com/swift-operators/
    return sqrt(Float)
}

infix operator ±
// Tuple of plus-minus operation.
///
/// - Parameters:
///   - lhs: float number
///   - rhs: float number
/// - Returns: tuple of plus-minus operation ( 2.5 ± 1.5 -> (4, 1)).
public func ± (lhs: Float, rhs: Float) -> (Float, Float) {
    // http://nshipster.com/swift-operators/
    return (lhs + rhs, lhs - rhs)
}

prefix operator ±
// Tuple of plus-minus operation.
///
/// - Parameter int: float number
/// - Returns: tuple of plus-minus operation (± 2.5 -> (2.5, -2.5)).
public prefix func ± (Float: Float) -> (Float, Float) {
    // http://nshipster.com/swift-operators/
    return 0 ± Float
}
