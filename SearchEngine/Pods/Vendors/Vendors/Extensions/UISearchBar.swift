//
//  UISearchBar.swift
//  Pods
//
//  Created by away4m on 12/30/16.
//
//

import Foundation

// MARK: - Properties
public extension UISearchBar {

    // Text field inside search bar (if applicable).
    public var textField: UITextField? {
        let subViews = subviews.flatMap { $0.subviews }
        guard let textField = (subViews.filter { $0 is UITextField }).first as? UITextField else {
            return nil
        }
        return textField
    }

    // Text with no spaces or new lines in beginning and end (if applicable).
    public var trimmedText: String? {
        return text?.trimmed
    }

    /// SwifterSwift: Clear text.
    public func clear() {
        text = ""
    }

}
