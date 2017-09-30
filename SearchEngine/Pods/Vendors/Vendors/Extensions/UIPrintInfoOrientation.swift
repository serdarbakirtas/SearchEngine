//
//  UIPrintInfoOrientation.swift
//  Pods
//
//  Created by Admin on 11/24/16.
//
//

import Foundation
import UIKit

public extension UIPrintInfoOrientation {
    public func toDevice() -> UIDeviceOrientation {
        switch self {
        case .portrait: return .portrait
        case .landscape: return .landscapeLeft
        }
    }
}
