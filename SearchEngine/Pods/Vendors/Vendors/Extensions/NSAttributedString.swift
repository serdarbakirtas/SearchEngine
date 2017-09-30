//
//  NSAttributedString.swift
//  Pods
//
//  Created by away4m on 12/30/16.
//
//

import Foundation

// MARK: - Properties
public extension NSAttributedString {

    public func height(boundingWidth: CGFloat) -> CGFloat {
        guard self.length > 0 else { return 0.0 }
        let frame = boundingRect(with: CGSize(width: boundingWidth, height: CGFloat.greatestFiniteMagnitude),
                                 options: [.usesLineFragmentOrigin, .usesFontLeading],
                                 context: nil)
        return ceil(frame.height)
    }
    
    public func width(boundingHeight: CGFloat) -> CGFloat {
        guard self.length > 0 else { return 0.0 }
        let frame = boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: boundingHeight),
                                 options: [.usesLineFragmentOrigin, .usesFontLeading],
                                 context: nil)
        return ceil(frame.width)
    }
    
    // Bold string
    public var bold: NSAttributedString {
        guard let copy = self.mutableCopy() as? NSMutableAttributedString else {
            return self
        }
        let range = (self.string as NSString).range(of: self.string)
        copy.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)], range: range)
        return copy
    }

    // Underlined string
    public var underline: NSAttributedString {
        guard let copy = self.mutableCopy() as? NSMutableAttributedString else {
            return self
        }
        let range = (self.string as NSString).range(of: self.string)
        copy.addAttributes([NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue], range: range)
        return copy
    }

    // Italic string
    public var italic: NSAttributedString {
        guard let copy = self.mutableCopy() as? NSMutableAttributedString else {
            return self
        }
        let range = (self.string as NSString).range(of: self.string)
        copy.addAttributes([NSFontAttributeName: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)], range: range)
        return copy
    }

    // Strikethrough string
    public var strikethrough: NSAttributedString {
        guard let copy = self.mutableCopy() as? NSMutableAttributedString else {
            return self
        }
        let range = (self.string as NSString).range(of: self.string)
        let attributes = [
            NSStrikethroughStyleAttributeName: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue as Int)
        ]
        copy.addAttributes(attributes, range: range)

        return copy
    }

    // Add color to NSAttributedString.
    ///
    /// - Parameter color: text color.
    /// - Returns: a NSAttributedString colored with given color.
    public func colored(with color: UIColor) -> NSAttributedString {
        guard let copy = self.mutableCopy() as? NSMutableAttributedString else {
            return self
        }
        let range = (string as NSString).range(of: string)
        copy.addAttributes([NSForegroundColorAttributeName: color], range: range)
        return copy
    }

    // Add a NSAttributedString to another NSAttributedString
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add to.
    ///   - rhs: NSAttributedString to add.
    public static func += (lhs: inout NSAttributedString, rhs: NSAttributedString) {
        let ns = NSMutableAttributedString(attributedString: lhs)
        ns.append(rhs)
        lhs = ns
    }

}
