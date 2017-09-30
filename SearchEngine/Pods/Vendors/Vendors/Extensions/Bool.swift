//
//  Bool.swift
//  TinySwift
//
//  Created by Piotr Sochalewski on 02.12.2016.
//  Copyright © 2016 Piotr Sochalewski. All rights reserved.
//

import Foundation

public extension Bool {
    /**
     Creates an instance initialized to the specified integer value.
     - parameter integer: The integer value.
     */
    public init<T: Integer>(_ integer: T) {
        self = integer != 0
    }

    /// Creates an instance initialized to randomized value: `true` or `false`.
    public static var random: Bool {
        return arc4random_uniform(2) == 0
    }

    // Return 1 if true, or 0 if false.
    public var int: Int {
        return self ? 1 : 0
    }

    // Return "true" if true, or "false" if false.
    public var string: String {
        return description
    }

    // Return inversed value of bool.
    public var toggled: Bool {
        return !self
    }

    /**
     Performs a logical NOT operation on a Boolean value.

     The logical NOT operator (`!`) inverts a Boolean value. If the value is `true`, the result of the operation is `false`; if the value is `false`, the result is `true`.

     var bool = true
     bool.toggle()
     print(bool)
     // Prints false
     */
    public mutating func toggle() {
        self = !self
    }
}
