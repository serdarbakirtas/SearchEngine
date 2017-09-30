//
//  NSLayoutConstraint.swift
//  Pods
//
//  Created by Admin on 11/24/16.
//
//

import Foundation
import UIKit

extension NSLayoutConstraint {
    public func deactivate() {
        NSLayoutConstraint.deactivate([self])
    }

    public func activate() {
        NSLayoutConstraint.activate([self])
    }

    open override var description: String {
        return "" //"id: \(self.identifier ?? ""), constant: \(self.constant), multiplier: \(self.multiplier), <firstItem>: \(self.firstItem) <second item>: \(self.secondItem ?? "" as AnyObject)"
    }
}
