//
//  UIRefreshControl.swift
//  Pods
//
//  Created by away4m on 12/31/16.
//
//

import Foundation

public extension UIRefreshControl {

    public func beginRefreshingManually() {

        guard let scrollView = superview as? UIScrollView else { return }

        let offsetY = scrollView.contentOffset.y - frame.height

        scrollView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: true)

        beginRefreshing()
    }
}
