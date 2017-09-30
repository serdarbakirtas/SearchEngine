//
//  CALayer.swift
//  Pods
//
//  Created by Admin on 11/24/16.
//
//

import Foundation
import UIKit

private final class AnimationDelegate: NSObject, CAAnimationDelegate {

    private var completion: (Bool) -> Void

    init(completion: @escaping (Bool) -> Void) {
        self.completion = completion
    }

    fileprivate func animationDidStop(_: CAAnimation, finished flag: Bool) {
        self.completion(flag)
    }
}

public extension CALayer {

    public func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {

        let border = CALayer()

        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.height - thickness, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
            break
        default:
            break
        }

        border.backgroundColor = color.cgColor

        self.addSublayer(border)
    }

    // MARK: - Position

    public var origin: CGPoint {
        get {
            return frame.origin
        }
        set {
            self.x = newValue.x
            self.y = newValue.y
        }
    }

    public var x: CGFloat {
        get { return frame.x }
        set { frame.x = newValue }
    }

    public var y: CGFloat {
        get { return frame.y }
        set { frame.y = newValue }
    }

    public var center: CGPoint {
        get { return frame.center }
        set { frame.center = newValue }
    }

    public var centerX: CGFloat {
        get { return frame.centerX }
        set { frame.centerX = newValue }
    }

    public var centerY: CGFloat {
        get { return frame.centerY }
        set { frame.centerY = newValue }
    }

    // MARK: - Size

    public var size: CGSize {
        get {
            return frame.size
        }
        set {
            width = newValue.width
            height = newValue.height
        }
    }

    public var width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame.size.width = snapToPixel(pointCoordinate: newValue)
        }
    }

    public var height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = snapToPixel(pointCoordinate: newValue)
        }
    }

    // MARK: - Edges

    public var top: CGFloat {
        get { return frame.top }
        set { frame.top = newValue }
    }

    public var right: CGFloat {
        get { return frame.right }
        set { frame.right = newValue }
    }

    public var bottom: CGFloat {
        get { return frame.bottom }
        set { frame.bottom = newValue }
    }

    public var left: CGFloat {
        get { return frame.left }
        set { frame.left = newValue }
    }

    // MARK: - Alternative Edges

    public var top2: CGFloat {
        get { return frame.top2 }
        set { frame.top2 = newValue }
    }

    public var right2: CGFloat {
        get { return frame.right2 }
        set { frame.right2 = newValue }
    }

    public var bottom2: CGFloat {
        get { return frame.bottom2 }
        set { frame.bottom2 = newValue }
    }

    public var left2: CGFloat {
        get { return frame.left2 }
        set { frame.left2 = newValue }
    }

    /**
     Add the specified animation object to the layer's render tree with a completion closure.

     - parameter animation: The animation to be added to the render tree.
     - parameter key: A string that identifier the animation.
     - parameter completion: A closure that is executed upon completion of the animation.
     */
    public func add(_ animation: CAAnimation, forKey key: String?, withCompletion completion: @escaping (Bool) -> Void) {
        animation.delegate = AnimationDelegate(completion: completion)
        add(animation, forKey: key)
    }
}
