//
//  Dictionary.swift
//  Pods
//
//  Created by Admin on 11/24/16.
//
//

import Foundation
import UIKit

public extension Dictionary {

    /// Build string representation of HTTP parameter dictionary of keys and objects
    ///
    /// This percent escapes in compliance with RFC 3986
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// :returns: String representation in the form of key1=value1&key2=value2 where the keys and values are percent escaped

    public func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).stringByAddingPercentEncodingForURLQueryValue()!
            let percentEscapedValue = (value as! String).stringByAddingPercentEncodingForURLQueryValue()!
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }

        return parameterArray.joined(separator: "&")
    }

    // Check if key exists in dictionary.
    ///
    /// - Parameter key: key to search for
    /// - Returns: true if key exists in dictionary.
    public func has(key: Key) -> Bool {
        return index(forKey: key) != nil
    }

    /// SwifterSwift: JSON Data from dictionary.
    ///
    /// - Parameter prettify: set true to prettify data (default is false).
    /// - Returns: optional JSON Data (if applicable).
    public func jsonData(prettify: Bool = false) -> Data? {
        guard JSONSerialization.isValidJSONObject(self) else {
            return nil
        }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
        return try? JSONSerialization.data(withJSONObject: self, options: options)
    }

    /// SwifterSwift: JSON String from dictionary.
    ///
    /// - Parameter prettify: set true to prettify string (default is false).
    /// - Returns: optional JSON String (if applicable).
    public func jsonString(prettify: Bool = false) -> String? {
        guard JSONSerialization.isValidJSONObject(self) else {
            return nil
        }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
        let jsonData = try? JSONSerialization.data(withJSONObject: self, options: options)
        return jsonData?.string(encoding: .utf8)
    }

    /**
     Add dictionary to self in-place.

     - parameter dictionary: The dictionary to add to self
     */
    public mutating func formUnion(_ dictionary: Dictionary) {
        dictionary.forEach { updateValue($0.1, forKey: $0.0) }
    }

    /**
     Return a dictionary containing the union of two dictionaries

     - parameter dictionary: The dictionary to add
     - returns: The combination of self and dictionary
     */
    public func union(_ dictionary: Dictionary) -> Dictionary {
        var completeDictionary = self
        completeDictionary.formUnion(dictionary)
        return completeDictionary
    }
}

// MARK: - Methods (ExpressibleByStringLiteral)
public extension Dictionary where Key: ExpressibleByStringLiteral {

    // Lowercase all keys in dictionary.
    public mutating func lowercaseAllKeys() {
        // http://stackoverflow.com/questions/33180028/extend-dictionary-where-key-is-of-type-string
        for key in self.keys {
            if let lowercaseKey = String(describing: key).lowercased() as? Key {
                self[lowercaseKey] = self.removeValue(forKey: key)
            }
        }
    }
}

/**
 Combine the contents of dictionaries into a single dictionary. Equivalent to `lhs.union(rhs)`.

 - parameter lhs: The first dictionary.
 - parameter rhs: The second dictionary.
 - returns: The combination of the two input dictionaries
 */
public func +<Key, Value>(lhs: Dictionary<Key, Value>, rhs: Dictionary<Key, Value>) -> Dictionary<Key, Value> {
    return lhs.union(rhs)
}

/**
 Add the contents of one dictionary to another dictionary. Equivalent to `lhs.unionInPlace(rhs)`.

 - parameter lhs: The dictionary in which to add key-values.
 - parameter rhs: The dictionary from which to add key-values.
 */
public func +=<Key, Value>(lhs: inout Dictionary<Key, Value>, rhs: Dictionary<Key, Value>) {
    lhs.formUnion(rhs)
}
