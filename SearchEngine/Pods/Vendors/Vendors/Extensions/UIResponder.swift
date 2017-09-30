//
//  UIResponder.swift
//  Pods
//
//  Created by away4m on 12/31/16.
//
//

import Foundation

import UIKit

private var _currentFirstResponder: UIResponder?

public extension UIResponder {

    public var currentFirstResponder: UIResponder? {
        _currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder(_:)), to: nil, from: nil, for: nil)
        return _currentFirstResponder
    }

    @objc fileprivate func findFirstResponder(_: AnyObject) {
        _currentFirstResponder = self
    }

}
