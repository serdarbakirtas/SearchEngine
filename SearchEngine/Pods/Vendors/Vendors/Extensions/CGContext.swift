//
//  CGContext.swift
//  Pods
//
//  Created by away4m on 1/2/17.
//
//

import Foundation

// MARK: - CGContext

extension CGContext {
    /// The current graphics context
    public static var current: CGContext? {
        return UIGraphicsGetCurrentContext()
    }
}
