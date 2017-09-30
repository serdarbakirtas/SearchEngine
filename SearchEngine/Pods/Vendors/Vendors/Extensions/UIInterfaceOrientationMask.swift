//
//  UIInterfaceOrientationMask.swift
//  Pods
//
//  Created by Admin on 11/24/16.
//
//

import Foundation
import UIKit

public extension UIInterfaceOrientationMask {
    public func toDevice() -> UIDeviceOrientation {
        switch self {
        case UIInterfaceOrientationMask.portrait: return .portrait
        case UIInterfaceOrientationMask.portraitUpsideDown: return .portraitUpsideDown
        case UIInterfaceOrientationMask.landscapeLeft, UIInterfaceOrientationMask.landscape: return .landscapeLeft
        case UIInterfaceOrientationMask.landscapeRight: return .landscapeRight
        default: return .portrait // Defaults to portrait
        }
    }
}
