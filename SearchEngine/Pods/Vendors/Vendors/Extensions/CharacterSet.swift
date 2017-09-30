//
//  CharacterSet.swift
//  Pods
//
//  Created by away4m on 1/1/17.
//
//

import Foundation

extension CharacterSet {
    public func isSuperset(ofCharactersIn string: String) -> Bool {
        #if os(Linux)
            // workaround for https://bugs.swift.org/browse/SR-3485
            let chars = Set(string.characters)
            for char in chars where !contains(char.unicodeScalar) {
                return false
            }

            return true
        #else
            let otherSet = CharacterSet(charactersIn: string)
            return isSuperset(of: otherSet)
        #endif
    }
}
