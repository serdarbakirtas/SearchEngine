//
//  UITableViewCellExtension.swift
//  TinySwift
//
//  Created by Piotr Sochalewski on 28.10.2016.
//  Copyright © 2016 Piotr Sochalewski. All rights reserved.
//

import UIKit

public extension UITableViewCell {
    @IBInspectable
    var seperatorHidden: Bool {
        get {
            return (self.tempObject(key: "seperatorHidden") as? Bool) ?? false // Just to satisfy property
        }
        set {
            self.setTempObject(newValue, key: "seperatorHidden")

            if newValue {
                self.hideSeparator()
            } else {
                indentationWidth = 0
                separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
            }
        }
    }

    /// Hides the separator below the cell.
    public func hideSeparator() {
        let largeIndent = 100000.0.g // CGFloat.infinity
        separatorInset = UIEdgeInsets(top: 0.0, left: largeIndent, bottom: 0.0, right: 0.0)
        indentationWidth = largeIndent * -1.0
        indentationLevel = 1
    }

    public func resetSeparators() {
        separatorInset = UIEdgeInsets.zero
        preservesSuperviewLayoutMargins = false
        layoutMargins = UIEdgeInsets.zero
    }

    public var table: UITableView? {
        var view = superview

        while view != nil && !(view is UITableView) {
            view = view?.superview
        }

        return view as? UITableView
    }
    
    public static func nibString() -> String {
        return String(describing: self)
    }
    
    public static func nib() -> UINib {
        return UINib.init(nibName: nibString(), bundle: nil)
    }
}
