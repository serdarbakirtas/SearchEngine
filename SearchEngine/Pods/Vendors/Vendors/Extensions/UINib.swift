//
//  UINib.swift
//  Pods
//
//  Created by ALI KIRAN on 6/13/17.
//
//

import Foundation
import UIKit

extension UINib {
    class func nibWithName(name: String) -> UINib {
        return UINib(nibName: name, bundle: nil)
    }
}
