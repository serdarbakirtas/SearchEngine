//
//  UITextView.swift
//  Pods
//
//  Created by away4m on 12/30/16.
//
//

#if os(iOS) || os(tvOS)
    import UIKit

    public extension UITextView {

        /// SwifterSwift: Clear text.
        public func clear() {
            text = ""
            attributedText = NSAttributedString(string: "")
        }

        // Scroll to the bottom of text view
        public func scrollToBottom() {
            let range = NSMakeRange((text as NSString).length - 1, 1)
            scrollRangeToVisible(range)
        }

        // Scroll to the top of text view
        public func scrollToTop() {
            let range = NSMakeRange(0, 1)
            scrollRangeToVisible(range)
        }

        /// Paste the pasteboard text to UITextView
        public func pasteFromPasteboard() {
            self.text = UIPasteboard.getString()
        }

        /// Copy UITextView text to pasteboard
        public func copyToPasteboard() {
            UIPasteboard.copy(text: self.text)
        }

    }
#endif
