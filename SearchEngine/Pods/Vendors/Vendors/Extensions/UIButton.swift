//
//  UIButton.swift
//  Pods
//
//  Ali Kiran on 11/24/16.
//
//

import Foundation
import UIKit

public extension UIButton {
    @IBInspectable
    var imageColor: UIColor {
        get {
            return UIColor.blue
        }
        set {
            self.tintColor = newValue
            self.setImageForAllStates(UIImage(color: newValue)!)
        }
    }

    var backColor: UIColor {
        get {
            return UIColor.blue
        }
        set {
            self.tintColor = newValue
            self.setBackgorundForAllStates(UIImage(color: newValue)!)
        }
    }

    @IBInspectable public var mirrorContent: Bool {
        get {
            return self.transform.a == 1 && self.transform.b == 0 && self.transform.c == 0 && self.transform.d == 1 && self.transform.tx == 0 && self.transform.a == 0
        }
        set {
            if newValue {
                self.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                self.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                self.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            } else {
                self.transform = CGAffineTransform()
            }
        }
    }

    // Toggle a UIButton
    ///
    /// - Parameter animated: set true to animate the change (default is true)
    public func toggle() {
        isSelected = !isSelected
    }

    private var states: [UIControlState] {
        return [.normal, .selected, .highlighted, .disabled]
    }

    // Set image for all states.
    ///
    /// - Parameter image: UIImage.
    public func setBackgorundForAllStates(_ image: UIImage) {
        states.forEach { self.setBackgroundImage(image, for: $0) }
    }

    // Set image for all states.
    ///
    /// - Parameter image: UIImage.
    public func setImageForAllStates(_ image: UIImage) {
        states.forEach { self.setImage(image, for: $0) }
    }

    // Set title color for all states.
    ///
    /// - Parameter color: UIColor.
    public func setTitleColorForAllStates(_ color: UIColor) {
        states.forEach { self.setTitleColor(color, for: $0) }
    }

    // Set title for all states.
    ///
    /// - Parameter title: title string.
    public func setTitleForAllStates(_ title: String) {
        states.forEach { self.setTitle(title, for: $0) }
    }

    /**
     Sets the background color to use for the specified button state.

     - parameter color: The background color to use for the specified state.
     - parameter state: The state that uses the specified image.
     */
    public func setBackgroundColor(_ color: UIColor, for state: UIControlState) {
        setBackgroundImage(UIImage(color: color), for: state)
    }

    public func configureTitle(numberOfLines: Int = 2, textAlignment: NSTextAlignment = .center, lineBreakMode: NSLineBreakMode = .byWordWrapping) {
        titleLabel?.numberOfLines = numberOfLines
        titleLabel?.textAlignment = textAlignment
        titleLabel?.lineBreakMode = lineBreakMode

    }

    public func sizeToFitTitle(alignRight: Bool = true, padding _: CGFloat = 10.0) {
        let originalLoc = alignRight ? self.right : left
        let title = self.title(for: UIControlState.normal) ?? ""
        let titleWidth = title.widthWithConstrainedHeight(height, font: titleLabel!.font)
        width = titleWidth + 10
        if alignRight {
            self.right = originalLoc
        } else {
            self.left = originalLoc
        }
        
    }
}
