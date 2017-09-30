//
//  CGImage.swift
//  Pods
//
//  Created by Admin on 11/24/16.
//
//

import Foundation
import UIKit

extension CGImage {
    public func resize(_ scale: CGFloat) -> CGImage {
        let image = UIImage(cgImage: self)
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: image.size.width * scale, height: image.size.height * scale)))
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.image = image
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!.cgImage!
    }
}
