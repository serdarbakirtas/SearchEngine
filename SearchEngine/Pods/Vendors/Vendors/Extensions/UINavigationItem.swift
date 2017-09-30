//
//  UINavigationItem.swift
//  Pods
//
//  Created by away4m on 12/30/16.
//
//

import Foundation

// MARK: - Methods
public extension UINavigationItem {

    // Replace title label with an image in navigation item.
    ///
    /// - Parameter image: UIImage to replace title with.
    public func replaceTitle(with image: UIImage) {
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = image
        self.titleView = logoImageView
    }

}
