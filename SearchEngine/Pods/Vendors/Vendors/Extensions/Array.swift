//
//  Array.swift
//  Pods
//
//  Created by Admin on 11/24/16.
//
//

import Foundation
import UIKit

public extension Array {
    public func randomItem() -> Element {
        return self[Int(arc4random_uniform(UInt32(self.count)))]
    }

    /// SwifterSwift: Element at the given index if it exists.
    ///
    /// - Parameter index: index of element.
    /// - Returns: optional element (if exists).
    public func item(at index: Int) -> Element? {
        guard 0 ..< count ~= index else { return nil }
        return self[index]
    }

    // First index of a given item in an array.
    ///
    /// - Parameter item: item to check.
    /// - Returns: first index of item in array (if exists).
    public func firstIndex<Item: Equatable>(of item: Item) -> Int? {
        if item is Element {
            for (index, value) in self.lazy.enumerated() {
                if value as! Item == item {
                    return index
                }
            }
            return nil
        }
        return nil
    }

    // Last index of element in array.
    ///
    /// - Parameter item: item to check.
    /// - Returns: last index of item in array (if exists).
    public func lastIndex<Item: Equatable>(of item: Item) -> Int? {
        if item is Element {
            for (index, value) in self.reversed().lazy.enumerated() {
                if value as! Item == item {
                    return count - 1 - index
                }
            }
            return nil
        }
        return nil
    }

    /// SwifterSwift: Remove last element from array and return it.
    ///
    /// - Returns: last element in array (if applicable).
    @discardableResult public mutating func pop() -> Element? {
        guard !isEmpty else { return nil }
        return removeLast()
    }

    // Insert an element at the beginning of array.
    ///
    /// - Parameter newElement: element to insert.
    public mutating func prepend(_ newElement: Element) {
        self.insert(newElement, at: 0)
    }

    // Insert an element to the end of array.
    ///
    /// - Parameter newElement: element to insert.
    public mutating func push(_ newElement: Element) {
        return append(newElement)
    }

    /**
     Returns an Array containing the results of mapping transform over self. The transform provides not only
     each element of the array but also the index of tha item in the array.

     ```
     let items: [SomeObject] = existingArray.mapWithIndex { index, response in
     return SomeObject(index: index, description: response.body)
     }
     ```

     - parameter f: The transform that given an element of the array and an index returns an element of type T

     - returns: The array created by applying the transform to this array.
     */
    public func mapWithIndex<T>(_ f: (Int, Element) -> T) -> [T] {
        return zip(startIndex ..< endIndex, self).map(f)
    }

    /**
     Rotates an array by the number of places indicated by `shift`.

     This is useful for infinitely scrolling visuals, but where the data backing those visuals is finite.

     ```
     var array = [1, 2, 3, 4, 5]

     let x = array.rotated(by: 2)   // x should be [3, 4, 5, 1, 2]
     let y = array.rotated(by: -2)  // y should be [4, 5, 1, 2, 3]
     ```

     - parameter shift: The number of indices by which the array should be shifted. Positive shifts right, negative shifts left.

     - returns: Returns the rotated array.
     */
    public func rotated(by shift: Int) -> Array {
        guard !isEmpty else { return [] }

        var array = self
        if shift > 0 {
            for _ in 1 ... shift {
                array.append(array.removeFirst())
            }
        } else if shift < 0 {
            for _ in 1 ... abs(shift) {
                array.insert(array.removeLast(), at: 0)
            }
        }
        return array
    }

    /// Rotates self in-place.
    public mutating func rotate(by shift: Int) {
        self = self.rotated(by: shift)
    }

}

// MARK: - Properties (Integer)
public extension Array where Element: Integer {
    // Sum of all elements in array.
    public var sum: Element {
        // http://stackoverflow.com/questions/28288148/making-my-function-calculate-average-of-array-swift
        return reduce(0, +)
    }

}

// MARK: - Properties (FloatingPoint)
public extension Array where Element: FloatingPoint {

    // Average of all elements in array.
    public var average: Element {
        // http://stackoverflow.com/questions/28288148/making-my-function-calculate-average-of-array-swift
        return isEmpty ? 0 : reduce(0, +) / Element(count)
    }

    // Sum of all elements in array.
    public var sum: Element {
        // http://stackoverflow.com/questions/28288148/making-my-function-calculate-average-of-array-swift
        return reduce(0, +)
    }

}

// MARK: - Properties (Equatable)
public extension Array where Element: Equatable {
    /// SwifterSwift: Shuffle array.
    public mutating func shuffle() {
        // https://gist.github.com/ijoshsmith/5e3c7d8c2099a3fe8dc3
        let arr = self
        for _ in 0 ..< 10 {
            sort { _, _ in arc4random() < arc4random() }
        }
        if self == arr {
            self.shuffle()
        }
    }

    /// SwifterSwift: Shuffled version of array.
    public var shuffled: [Element] {
        var arr = self
        arr.shuffle()
        return arr
    }

    /**
     Removes and returns the specified element from the array

     - parameter element: The element to remove from the array
     - returns: The removed element or nil, if the element was not found
     */
    public mutating func remove(_ element: Element) -> Element? {
        guard let index = index(of: element) else { return nil }
        return remove(at: index)
    }

    var unique: [Element] {
        var uniqueValues = [Element]()
        for item in self where !uniqueValues.contains(item) {
            uniqueValues.append(item)
        }
        return uniqueValues
    }

    /**
     Slices a out a segment of an array based on the start
     and end positions.
     - Parameter start: A start index.
     - Parameter end: An end index.
     - Returns: A segmented array based on the start and end
     indices.
     */
    public func slice(start: Int, end: Int?) -> [Element] {
        var e = end ?? count - 1
        if e >= count {
            e = count - 1
        }

        guard -1 < start else {
            fatalError("Range out of bounds for \(start) - \(end ?? 0), should be 0 - \(count).")
        }

        var diff = abs(e - start)
        guard count > diff else {
            return self
        }

        var ret = [Element]()
        while -1 < diff {
            ret.insert(self[start + diff], at: 0)
            diff -= 1
        }

        return ret
    }

    // Array with all duplicates removed from it.
    public var withoutDuplicates: [Element] {
        // Thanks to https://github.com/sairamkotha for improving the preperty
        return reduce([]) { ($0 as [Element]).contains($1) ? $0 : $0 + [$1] }
    }

    // Check if array contains an array of elements.
    ///
    /// - Parameter elements: array of elements to check.
    /// - Returns: true if array contains all given items.
    public func contains(_ elements: [Element]) -> Bool {
        guard !elements.isEmpty else { // elements array is empty
            return false
        }
        var found = true
        for element in elements {
            if !self.contains(element) {
                found = false
            }
        }
        return found
    }

    // All indexes of specified item.
    ///
    /// - Parameter item: item to check.
    /// - Returns: an array with all indexes of the given item.
    public func indexes(of item: Element) -> [Int] {
        var indexes: [Int] = []
        for index in 0 ..< self.count {
            if self[index] == item {
                indexes.append(index)
            }
        }
        return indexes
    }

    // Remove all instances of an item from array.
    ///
    /// - Parameter item: item to remove.
    public mutating func removeAll(_ item: Element) {
        self = self.filter { $0 != item }
    }

    // Remove all duplicates from array.
    public mutating func removeDuplicates() {
        // Thanks to https://github.com/sairamkotha for improving the method
        self = reduce([]) { $0.contains($1) ? $0 : $0 + [$1] }
    }

}
