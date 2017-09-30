//
//  UIPasteboard.swift
//  Pods
//
//  Created by ALI KIRAN on 3/25/17.
//
//

import Foundation
public extension UIPasteboard {
    // MARK: - Functions

    /// Copy a text to the pasteboard.
    ///
    /// - Parameter text: The text to be copy to.
    public static func copy(text: String) {
        UIPasteboard.general.string = text
    }

    /// Returns the last copied string from pasteboard.
    ///
    /// - Returns: Returns the last copied string from pasteboard.
    public static func getString() -> String {
        guard let pasteboard = UIPasteboard.general.string else {
            return ""
        }

        return pasteboard
    }
}
