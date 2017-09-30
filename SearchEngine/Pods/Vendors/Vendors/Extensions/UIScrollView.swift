//
//  UIScrollView.swift
//  Pods
//
//  Created by Admin on 11/24/16.
//
//

import Foundation
import UIKit

public extension UIScrollView {
    public var currentPage: Int {
        return Int(round(self.contentOffset.x / self.bounds.size.width))
    }

    // If you have reversed offset (start from contentSize.width to 0)
    public var reverseCurrentPage: Int {
        return Int(round((contentSize.width - self.contentOffset.x) / self.bounds.size.width)) - 1
    }

    // MARK: - Content Size

    public var contentWidth: CGFloat {
        get {
            return contentSize.width
        }
        set {
            contentSize.width = snapToPixel(pointCoordinate: newValue)
        }
    }

    public var contentHeight: CGFloat {
        get {
            return contentSize.height
        }
        set {
            contentSize.height = snapToPixel(pointCoordinate: newValue)
        }
    }

    // MARK: - Content Edges (For Convenience)

    public var contentTop: CGFloat {
        return 0
    }

    public var contentLeft: CGFloat {
        return 0
    }

    public var contentBottom: CGFloat {
        get {
            return contentHeight
        }
        set {
            contentHeight = newValue
        }
    }

    public var contentRight: CGFloat {
        get {
            return contentWidth
        }
        set {
            contentWidth = newValue
        }
    }

    // MARK: - Viewport Edges

    public var viewportTop: CGFloat {
        get {
            return contentOffset.y
        }
        set {
            contentOffset.y = snapToPixel(pointCoordinate: newValue)
        }
    }

    public var viewportLeft: CGFloat {
        get {
            return contentOffset.x
        }
        set {
            contentOffset.x = snapToPixel(pointCoordinate: newValue)
        }
    }

    public var viewportBottom: CGFloat {
        get {
            return contentOffset.y + height
        }
        set {
            contentOffset.y = snapToPixel(pointCoordinate: newValue - height)
        }
    }

    public var viewportRight: CGFloat {
        get {
            return contentOffset.x + width
        }
        set {
            contentOffset.x = snapToPixel(pointCoordinate: newValue - width)
        }
    }

    /// Immediately stops the scrollview scrolling.
    public func stopScrolling() {
        // http://stackoverflow.com/questions/3410777/how-can-i-programmatically-force-stop-scrolling-in-a-uiscrollview
        let offset = contentOffset
        setContentOffset(offset, animated: false)
    }
    
    // Scroll to bottom of TableView.
    ///
    /// - Parameter animated: set true to animate scroll (default is true).
    public func goToBottom(animated: Bool = true) {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height)
        setContentOffset(bottomOffset, animated: animated)
    }
    
    // Scroll to top of TableView.
    ///
    /// - Parameter animated: set true to animate scroll (default is true).
    public func goToTop(animated: Bool = true) {
        setContentOffset(CGPoint.zero, animated: animated)
    }
}
