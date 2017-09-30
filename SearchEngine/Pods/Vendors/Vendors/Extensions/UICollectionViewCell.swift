//
//  UICollectionViewCell.swift
//  Pods
//
//  Created by ALI KIRAN on 6/13/17.
//
//

import Foundation

public extension UICollectionViewCell {
    
    public static func nibString() -> String {
        return String(describing: self)
    }
    
    public static func nib() -> UINib {
        return UINib.init(nibName: nibString(), bundle: nil)
    }
    
}
