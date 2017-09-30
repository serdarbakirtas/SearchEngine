//
//  Vertice.swift
//  Pods
//
//  Created by ALI KIRAN on 1/22/17.
//
//

import Foundation

public struct Vertex<T>: Equatable where T: Equatable, T: Hashable {
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(_: Vertex<T>, _: Vertex<T>) -> Bool {
        return false
    }

    public var data: T
    public let index: Int

}
