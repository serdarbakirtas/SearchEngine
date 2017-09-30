//
//  UIWebView.swift
//  Pods
//
//  Created by ALI KIRAN on 3/25/17.
//
//

import Foundation
import UIKit

public extension UIWebView {
    // MARK: - Functions

    /// Remove the background shadow of the UIWebView.
    public func removeBackgroundShadow() {
        for i in 0 ..< scrollView.subviews.count {
            let singleSubview: UIView = scrollView.subviews[i]
            if singleSubview.isKind(of: UIImageView.self), singleSubview.frame.origin.x <= 500 {
                singleSubview.isHidden = true
                singleSubview.removeFromSuperview()
            }
        }
    }

    /// Load the requested website.
    ///
    /// - Parameter website: Website to load.
    public func loadWebsite(_ website: String) {
        loadRequest(URLRequest(url: URL(string: website)!))
    }
}
