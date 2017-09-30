//
//  Set.swift
//  Pods
//
//  Created by Admin on 11/24/16.
//
//

import Foundation
import UIKit

public extension Set {
    public func random() -> Element {
        return Array(self)[Int(arc4random_uniform(UInt32(self.count)))]
    }
}
