//
//  StackView.swift
//  Vendors
//
//  Created by ALI KIRAN on 9/7/17.
//

import Foundation
import UIKit
@available(iOS 9.0, *)
open class StackView: UIStackView {
    private var color: UIColor?
    override open var backgroundColor: UIColor? {
        get { return color }
        set {
            color = newValue
            self.setNeedsLayout() // EDIT 2017-02-03 thank you @BruceLiu
        }
    }

    private lazy var backgroundLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        self.layer.insertSublayer(layer, at: 0)
        return layer
    }()

    public override var cornerRadius: CGFloat {
        set {
            self.layer.cornerRadius = newValue
            self.setNeedsLayout()
        }

        get {
            return self.layer.cornerRadius
        }
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
        let maskPath = UIBezierPath(
            roundedRect: self.bounds,
            byRoundingCorners: [UIRectCorner.allCorners],
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        )

        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        backgroundLayer.mask = shape
        backgroundLayer.path = UIBezierPath(rect: self.bounds).cgPath
        backgroundLayer.fillColor = self.backgroundColor?.cgColor
    }
}
