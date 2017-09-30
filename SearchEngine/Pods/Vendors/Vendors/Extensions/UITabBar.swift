//
//  UITabBar.swift
//  Pods
//
//  Created by away4m on 12/30/16.
//
//

import Foundation

// MARK: - Methods
public extension UITabBar {

    public func itemFrameAtIndex(_ index: Int) -> CGRect {

        var frames = subviews.flatMap { view -> CGRect? in
            if let view = view as? UIControl {
                return view.frame
            }
            return nil
        }

        frames.sort { $0.origin.x < $1.origin.x }

        if frames.count > index {
            return frames[index]
        }

        return frames.last ?? .zero
    }

    public func indexOfItemAtPoint(_ point: CGPoint) -> Int? {

        var frames = subviews.flatMap { view -> CGRect? in
            if let view = view as? UIControl {
                return view.frame
            }
            return nil
        }

        frames.sort { $0.origin.x < $1.origin.x }

        for (i, rect) in frames.enumerated() {
            if rect.contains(point) {
                return i
            }
        }

        return nil
    }
}
