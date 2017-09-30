//
//  Edge.swift
//  Pods
//
//  Created by ALI KIRAN on 1/22/17.
//
//

import Foundation

public struct Edge<T>: Equatable where T: Equatable, T: Hashable {
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(_: Edge<T>, _: Edge<T>) -> Bool {
        return false
    }

    public let from: Vertex<T>
    public let to: Vertex<T>

    public let weight: Double?

}
