//
//  Character.swift
//  Pods
//
//  Created by away4m on 12/30/16.
//
//

import Foundation

import Foundation

// MARK: - Properties
public extension Character {

    public var unicodeScalar: UnicodeScalar {
        let characterString = String(self)
        let scalars = characterString.unicodeScalars

        return scalars[scalars.startIndex]
    }

    // Check if character is emoji.
    public var isEmoji: Bool {
        // http://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
        guard let scalarValue = String(self).unicodeScalars.first?.value else {
            return false
        }
        switch scalarValue {
        case 0x3030, 0x00AE, 0x00A9, // Special Characters
             0x1D000 ... 0x1F77F, // Emoticons
             0x2100 ... 0x27BF, // Misc symbols and Dingbats
             0xFE00 ... 0xFE0F, // Variation Selectors
             0x1F900 ... 0x1F9FF: // Supplemental Symbols and Pictographs
            return true
        default:
            return false
        }
    }

    // Check if character is number.
    public var isNumber: Bool {
        return Int(String(self)) != nil
    }

    // Integer from character (if applicable).
    public var int: Int? {
        return Int(String(self))
    }

    // String from character.
    public var string: String {
        return String(self)
    }

    // Repeat character multiple times.
    ///
    /// - Parameters:
    ///   - lhs: character to repeat.
    ///   - rhs: number of times to repeat character.
    /// - Returns: string with character repeated n times.
    public static func * (lhs: Character, rhs: Int) -> String {
        var newString = ""
        for _ in 0 ..< rhs {
            newString += String(lhs)
        }
        return newString
    }

    // Repeat character multiple times.
    ///
    /// - Parameters:
    ///   - lhs: number of times to repeat character.
    ///   - rhs: character to repeat.
    /// - Returns: string with character repeated n times.
    public static func * (lhs: Int, rhs: Character) -> String {
        var newString = ""
        for _ in 0 ..< lhs {
            newString += String(rhs)
        }
        return newString
    }

}
