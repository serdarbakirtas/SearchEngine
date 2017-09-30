//
//  Collection.swift
//  Pods
//
//  Created by away4m on 12/30/16.
//
//

import Foundation

// MARK: - Methods
public extension Collection {

    private func indicesArray() -> [Self.Index] {
        var indices: [Self.Index] = []
        var index = self.startIndex
        while index != self.endIndex {
            indices.append(index)
            index = self.index(after: index)
        }
        return indices
    }

    // performs `each` closure for each element of collection in parallel.
    ///
    /// - Parameter each: closure to run for each element.
    public func forEachInParallel(_ each: (Self.Iterator.Element) -> Void) {
        let indices = self.indicesArray()

        DispatchQueue.concurrentPerform(iterations: indices.count) { index in
            let elementIndex = indices[index]
            each(self[elementIndex])
        }
    }

    /**
     Creats a shuffled version of this array using the Fisher-Yates (fast and uniform) shuffle.
     Non-mutating. From http://stackoverflow.com/a/24029847/194869

     - returns: A shuffled version of this array.
     */
    public func shuffled() -> [Generator.Element] {
        var list = Array(self)
        list.shuffle()
        return list
    }
}

public extension Collection where Index == Int {
    /// Returns a randomized element from the collection.
    public var random: Iterator.Element? {
        guard !isEmpty else { return nil }
        let index = Int(arc4random_uniform(UInt32(endIndex - startIndex)))

        return self[index]
    }

}

// MARK: - Properties (Integer)
public extension Collection where Iterator.Element == Int, Index == Int {

    // Average of all elements in array.
    public var average: Double {
        // http://stackoverflow.com/questions/28288148/making-my-function-calculate-average-of-array-swift
        return isEmpty ? 0 : Double(reduce(0, +)) / Double(endIndex - startIndex)
    }

}

extension Collection where Self.Index == Self.Indices.Iterator.Element {
    /**
     Returns an optional element. If the `index` does not exist in the collection, the subscript returns nil.

     - parameter safe: The index of the element to return, if it exists.

     - returns: An optional element from the collection at the specified index.
     */
    public subscript(safe i: Index) -> Self.Iterator.Element? {
        return at(i)
    }

    /**
     Returns an optional element. If the `index` does not exist in the collection, the function returns nil.

     - parameter index: The index of the element to return, if it exists.

     - returns: An optional element from the collection at the specified index.
     */
    public func at(_ i: Index) -> Self.Iterator.Element? {
        return indices.contains(i) ? self[i] : nil
    }
}

public extension MutableCollection where Index == Int, IndexDistance == Int {
    /**
     Shuffle the array using the Fisher-Yates (fast and uniform) shuffle. Mutating.
     From http://stackoverflow.com/a/24029847/194869
     */
    public mutating func shuffle() {
        // Empty and single-element collections don't shuffle.
        guard count > 1 else { return }

        for i in 0 ..< (count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }

    /**
     Returns a random element from the collection.

     - returns: A random element from the collection.
     */
    public func random() -> Generator.Element {
        let index = Int(arc4random_uniform(UInt32(count)))
        return self[index]
    }
}
