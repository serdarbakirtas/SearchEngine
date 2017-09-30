//
//  UILabel.swift
//  Pods
//
//  Created by away4m on 12/30/16.
//
//

import Foundation

// MARK: - Methods
public extension UILabel {

    // Required height for a label
    public var requiredHeight: CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.attributedText = attributedText
        label.sizeToFit()
        return label.frame.height
    }

    public func sizeToFitWidth() {
        self.height = CGFloat.greatestFiniteMagnitude
        self.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.numberOfLines = 0
        self.sizeToFit()
        self.layoutIfNeeded()

    }

    public func sizeToFitHeight() {
        self.width = CGFloat.greatestFiniteMagnitude
        self.lineBreakMode = NSLineBreakMode.byTruncatingTail
        self.sizeToFit()
        self.layoutIfNeeded()

    }
}
