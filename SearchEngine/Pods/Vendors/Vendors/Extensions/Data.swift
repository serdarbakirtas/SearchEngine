//
//  Data.swift
//  Pods
//
//  Created by Admin on 11/24/16.
//
//

import Foundation
import UIKit

public extension Data {
    /// Returns a formatted device token string
    func formattedDeviceToken() -> String {
        return description
            .trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
            .replacingOccurrences(of: " ", with: "")
    }

    public func toUtf8() -> String? {
        return String(data: self, encoding: String.Encoding.utf8)
    }

    /// Returns a hexadecimal encoded String.
    public var hexadecimalString: String {
        return map { String(format: "%02x", $0) }.joined(separator: "")
    }

    /**
     Initialize a `Data` from the hexadecimal string representation.

     Sample usage:

     let hexString = "48656c6c6f"
     let data = Data(hexadecimalString: hexString)
     // data is now <48656c6c6f>

     - parameter string: The hexadecimal string representation.
     - note: If the string has any non-hexadecimal characters, those are ignored and only hexadecimal characters are processed.
     - returns: The data represented by the hexadecimal string or `nil` if a data cannot be created.
     */
    public init?(hexadecimalString string: String) {
        var data = Data(capacity: string.length / 2)

        let regex = try? NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex?.enumerateMatches(in: string, options: [], range: NSMakeRange(0, string.length)) { match, _, _ in
            let byteString = (string as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }

        guard data.count > 0 else { return nil }

        self = data
    }

    // NSAttributedString from Data (if applicable).
    public var attributedString: NSAttributedString? {
        // http://stackoverflow.com/questions/39248092/nsattributedstring-extension-in-swift-3
        do {
            return try NSAttributedString(data: self, options: [
                NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue
            ], documentAttributes: nil)
        } catch _ {
            return nil
        }
    }

    /// SwifterSwift: String by encoding Data using the given encoding (if applicable).
    ///
    /// - Parameter encoding: encoding.
    /// - Returns: String by encoding Data using the given encoding (if applicable).
    public func string(encoding: String.Encoding) -> String? {
        return String(data: self, encoding: encoding)
    }
}
