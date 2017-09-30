//
//  Int.swift
//  TinySwift
//
//  Created by Piotr Sochalewski on 27.09.2016.
//  Copyright © 2016 Piotr Sochalewski. All rights reserved.
//

import Foundation

public extension Integer {
    /// SwifterSwift: String with number and current locale currency.
    public var asLocaleCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.string(from: self as! NSNumber)!
    }

    /**
     Returns the product of all positive integers less than or equal to the integer.

     Because of the output type limitation, *n! = ∞* where *n* greater than *170*.
     */
    public var factorial: Double? {
        guard self != 0 else { return 1 }
        guard self > 0 else { return nil }
        var integers = [Double]()
        for i in 2 ... toIntMax() {
            integers.append(Double(i))
        }

        return integers.reduce(1, *)
    }

    /// A Boolean value that determines whether the value can be divided exactly by 2.
    public var isEven: Bool {
        return self % 2 == 0
    }

    /// A Boolean value that determines whether the value cannot be divided exactly by 2.
    public var isOdd: Bool {
        return self % 2 != 0
    }

    /// A Boolean value that determines whether the value is a natural number greater than 1 that has no positive divisors other than 1 and itself.
    public var isPrimeNumber: Bool {
        guard self > 1 else { return false }
        var divisor: Self = 2
        while divisor < self / 2 {
            if self % divisor == 0 {
                return false
            } else {
                divisor = divisor + 1
            }
        }

        return true
    }

    /// Returns the opposite number.
    public var additiveInverse: IntMax {
        return self.toIntMax() * -1.toIntMax()
    }

    /// Returns the value to the power of `-1`.
    public var multiplicativeInverse: Double? {
        guard self != 0 else { return nil }
        return 1.0 / Double(self.toIntMax())
    }

    /// Converts an angle measured in degrees to radians.
    public var degreesToRadians: Double {
        return Double(self.toIntMax()) * .pi / 180.0
    }

    /// Converts an angle measured in radians to degrees.
    public var radiansToDegrees: Double {
        return Double(self.toIntMax()) * 180.0 / .pi
    }

    /// Returns the time interval treating the value as a number of seconds.
    public var seconds: TimeInterval {
        return TimeInterval(self.toIntMax())
    }

    /// Returns the time interval treating the value as a number of minutes.
    public var minutes: TimeInterval {
        return seconds * 60.0
    }

    /// Returns the time interval treating the value as a number of hours.
    public var hours: TimeInterval {
        return minutes * 60.0
    }

    /// Returns the time interval treating the value as a number of days.
    public var days: TimeInterval {
        return hours * 24.0
    }

}

public extension SignedInteger {
    /// Returns the opposite number.
    public var additiveInverse: Self {
        return self * -1
    }
}

public extension Int {
    public func rotate(max: Int) -> Int {
        return (self + 1 <= max) ? self + 1 : 0
    }
    
    public func rotate(next step: Int, length: Int) -> Int {
        
        guard self < length else {
            return 0.rotate(next: self + step, length: length)
        }
        
        let nextIdx = (self + step) % length
        if 0 <= nextIdx {
            return nextIdx
        }
        return length + nextIdx
    }
    
    /**
     * Ensures that the integer value stays with the specified range.
     */
    public func clamped(_ range: Range<Int>) -> Int {
        return (self < range.lowerBound) ? range.lowerBound : ((self >= range.upperBound) ? range.upperBound - 1 : self)
    }

    public func clamped(_ range: ClosedRange<Int>) -> Int {
        return (self < range.lowerBound) ? range.lowerBound : ((self > range.upperBound) ? range.upperBound : self)
    }

    /**
     * Ensures that the integer value stays with the specified range.
     */
    public mutating func clamp(_ range: Range<Int>) -> Int {
        self = self.clamped(range)
        return self
    }

    public mutating func clamp(_ range: ClosedRange<Int>) -> Int {
        self = self.clamped(range)
        return self
    }

    /**
     * Ensures that the integer value stays between the given values, inclusive.
     */
    public func clamped(_ v1: Int, _ v2: Int) -> Int {
        let min = v1 < v2 ? v1 : v2
        let max = v1 > v2 ? v1 : v2
        return self < min ? min : (self > max ? max : self)
    }

    /**
     * Ensures that the integer value stays between the given values, inclusive.
     */
    public mutating func clamp(_ v1: Int, _ v2: Int) -> Int {
        self = self.clamped(v1, v2)
        return self
    }

    /**
     Initializes and returns a randomized integer value.

     - parameter range: A half-open interval over a comparable type, from a lower bound up to, but not including, an upper bound. You create Range instances by using the half-open range operator (`..<`). You may specify `nil` for this parameter if you want randomized value in the range of `-2^31` to `2^31`.
     - returns: A signed randomized integer value type.
     */
    public init(random range: Range<Int>? = nil) {
        if let range = range {
            self = Int(arc4random_uniform(UInt32(range.upperBound - range.lowerBound))) + range.lowerBound
        } else {
            self = Int(arc4random()) + Int(Int32.min)
        }
    }

    /**
     Submits a block object for execution number or times defined by the value.

     - parameter block: The block to be invoked at least once. This parameter cannot be `NULL`.
     */
    public func times(execute block: @escaping () -> Void) {
        guard self > 0 else { return }
        (0 ..< self).forEach { _ in
            block()
        }
    }

    // Absolute value of integer.
    public var abs: Int {
        return Swift.abs(self)
    }

    // String with number and current locale currency.
    public var asLocaleCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.string(from: self as NSNumber)!
    }

    // Radian value of degree input.
    public var degreesToRadians: Double {
        return Double.pi * Double(self) / 180.0
    }

    // Array of digits of integer value.
    public var digits: [Int] {
        var digits: [Int] = []
        for char in String(self).characters {
            if let int = Int(String(char)) {
                digits.append(int)
            }
        }
        return digits
    }

    // Number of digits of integer value.
    public var digitsCount: Int {
        return String(self).length
    }

    // Check if integer is even.
    public var isEven: Bool {
        return (self % 2) == 0
    }

    // Check if integer is odd.
    public var isOdd: Bool {
        return (self % 2) != 0
    }

    // Degree value of radian input
    public var radiansToDegrees: Double {
        return Double(self) * 180 / Double.pi
    }

    // Roman numeral string from integer (if applicable).
    public var romanNumeral: String? {
        // https://gist.github.com/kumo/a8e1cb1f4b7cff1548c7
        guard self > 0 else { // there is no roman numerals for 0 or negative numbers
            return nil
        }
        let romanValues = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
        let arabicValues = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]

        var romanValue = ""
        var startingValue = self

        for (index, romanChar) in romanValues.enumerated() {
            let arabicValue = arabicValues[index]
            let div = startingValue / arabicValue
            if div > 0 {
                for _ in 0 ..< div {
                    romanValue += romanChar
                }
                startingValue -= arabicValue * div
            }
        }
        guard romanValue.length > 0 else {
            return nil
        }
        return romanValue
    }

    // String of format (XXh XXm) from seconds Int
    public var timeString: String {
        guard self > 0 else {
            return "0 sec"
        }
        if self < 60 {
            return "\(self) sec"
        }
        if self < 3600 {
            return "\(self / 60) min"
        }
        let hours = self / 3600
        let mins = (self % 3600) / 60

        if hours == 0 && mins != 0 {
            return "\(mins) min"

        } else if hours != 0 && mins == 0 {
            return "\(hours) h"

        } else {
            return "\(hours) h \(mins) m"
        }
    }

    // String formatted for values over ±1000 (example: 1k, -2k, 100k, 1kk, -5kk..)
    public var kFormatted: String {
        var sign: String {
            return self >= 0 ? "" : "-"
        }
        let abs = self.abs
        if abs >= 0 && abs < 1000 {
            return "0K"
        } else if abs >= 1000 && abs < 1000000 {
            return String(format: "\(sign)%ik", abs / 1000)
        } else if abs >= 1000000 {
            return String(format: "\(sign)%ikk", abs / 100000)
        } else {
            return String(describing: self)
        }
    }

    // Greatest common divisor of integer value and n.
    ///
    /// - Parameter n: integer value to find gcd with.
    /// - Returns: greatest common divisor of self and n.
    public func gcd(of n: Int) -> Int {
        return n == 0 ? self : n.gcd(of: self % n)
    }

    // Least common multiple of integer and n.
    ///
    /// - Parameter n: integer value to find lcm with.
    /// - Returns: least common multiple of self and n.
    public func lcm(of n: Int) -> Int {
        return (self * n).abs / self.gcd(of: n)
    }

}

// MARK: - Operators

infix operator **
// Value of exponentiation.
///
/// - Parameters:
///   - lhs: base integer.
///   - rhs: exponent integer.
/// - Returns: exponentiation result (example: 2 ** 3 = 8).
public func ** (lhs: Int, rhs: Int) -> Double {
    // http://nshipster.com/swift-operators/
    return pow(Double(lhs), Double(rhs))
}

prefix operator √
// Square root of integer.
///
/// - Parameter int: integer value to find square root for
/// - Returns: square root of given integer.
public prefix func √ (int: Int) -> Double {
    // http://nshipster.com/swift-operators/
    return sqrt(Double(int))
}

infix operator ±
// Tuple of plus-minus operation.
///
/// - Parameters:
///   - lhs: integer number
///   - rhs: integer number
/// - Returns: tuple of plus-minus operation (example: 2 ± 3 -> (5, -1)).
public func ± (lhs: Int, rhs: Int) -> (Int, Int) {
    // http://nshipster.com/swift-operators/
    return (lhs + rhs, lhs - rhs)
}

prefix operator ±
// Tuple of plus-minus operation.
///
/// - Parameter int: integer number
/// - Returns: tuple of plus-minus operation (example: ± 2 -> (2, -2)).
public prefix func ± (int: Int) -> (Int, Int) {
    // http://nshipster.com/swift-operators/
    return 0 ± int
}
