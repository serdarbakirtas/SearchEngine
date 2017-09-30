//
//  ExpressibleByDictionaryLiteral.swift
//  Pods
//
//  Created by Admin on 11/24/16.
//
//

import Foundation
import UIKit

public extension ExpressibleByDictionaryLiteral where Key == String {

    public func nestedKey(_ key: String) -> AnyObject? {

        let keys = key.components(separatedBy: ".")

        let target: AnyObject? = self as AnyObject

        return keys.reduce(target) { x, y in

            if x == nil { return x }

            guard let curDict = x as? [String: AnyObject] else {
                return nil
            }

            guard let next = curDict[y] else {
                return nil
            }

            return next
        }
    }
}
