//
//  CGSize.swift
//  Pods
//
//  Created by away4m on 12/30/16.
//
//

import Foundation

// MARK: - Methods
public extension CGSize {

    public init(_ width: CGFloat, _ height: CGFloat) {
        self.init(width: width, height: height)
    }
    // Aspect fit CGSize.
    ///
    /// - Parameter boundingSize: bounding size to fit self to.
    /// - Returns: self fitted into given bounding size
    public func aspectFit(to boundingSize: CGSize) -> CGSize {
        let minRatio = min(boundingSize.width / width, boundingSize.height / height)
        return CGSize(width: width * minRatio, height: height * minRatio)
    }

    // Aspect fill CGSize.
    ///
    /// - Parameter boundingSize: bounding size to fill self to.
    /// - Returns: self filled into given bounding size
    public func aspectFill(to boundingSize: CGSize) -> CGSize {
        let minRatio = max(boundingSize.width / width, boundingSize.height / height)
        return CGSize(width: width * minRatio, height: height * minRatio)
    }

}
