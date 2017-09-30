//
//  NSArray.swift
//  Pods
//
//  Created by ALI KIRAN on 6/22/17.
//
//

import Foundation
import UIKit

extension NSArray {
  public func joinItems(key: String, seperator: String, limit: Int, ifEmpty: String) -> String {
    let items = value(forKey: key) as? Array<String> ?? []
    let joined = items[0 ..< Swift.min(limit, items.count)].joined(separator: seperator)

    return joined.length > 0 ? joined : ifEmpty
  }
}
