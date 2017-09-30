//
//  UIWindow.swift
//  Pods
//
//  Created by Admin on 11/24/16.
//
//

import Foundation
import UIKit

public extension UIWindow {
    // MARK: - Functions

    /// Take a screenshot of current window and choose if save it or not.
    ///
    /// - Parameter save: Set to true to save, otherwise false.
    /// - Returns: Returns the screenshot as an UIImage.
    public func windowScreenshot(save: Bool = false) -> UIImage? {
        let ignoreOrientation: Bool = osVersionGreaterThanOrEqual("8.0")

        let orientation: UIInterfaceOrientation = UIApplication.shared.statusBarOrientation

        var imageSize: CGSize = CGSize.zero
        if UIInterfaceOrientationIsPortrait(orientation) || ignoreOrientation {
            imageSize = UIScreen.main.bounds.size
        } else {
            imageSize = CGSize(width: UIScreen.main.bounds.size.height, height: UIScreen.main.bounds.size.width)
        }

        UIGraphicsBeginImageContextWithOptions(imageSize, false, UIScreen.main.scale)
        guard let context: CGContext = UIGraphicsGetCurrentContext() else {
            return nil
        }
        context.saveGState()
        context.translateBy(x: center.x, y: center.y)
        context.concatenate(transform)
        context.translateBy(x: -bounds.size.width * layer.anchorPoint.x, y: -bounds.size.height * layer.anchorPoint.y)

        if !ignoreOrientation {
            if orientation == .landscapeLeft {
                context.rotate(by: CGFloat.pi / 2)
                context.translateBy(x: 0, y: -imageSize.width)
            } else if orientation == .landscapeRight {
                context.rotate(by: -CGFloat.pi / 2)
                context.translateBy(x: -imageSize.height, y: 0)
            } else if orientation == .portraitUpsideDown {
                context.rotate(by: CGFloat.pi)
                context.translateBy(x: -imageSize.width, y: -imageSize.height)
            }
        }

        if responds(to: #selector(UIView.drawHierarchy(in:afterScreenUpdates:))) {
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: false)
        } else {
            guard let context = UIGraphicsGetCurrentContext() else {
                return nil
            }
            layer.render(in: context)
        }

        context.restoreGState()

        guard let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }

        UIGraphicsEndImageContext()

        if save {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }

        return image
    }

    public func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(rootViewController)
        }
        return nil
    }

    public class func getVisibleViewControllerFrom(_ vc: UIViewController) -> UIViewController {
        if vc.isKind(of: UINavigationController.self) {
            let navigationController = vc as! UINavigationController
            return UIWindow.getVisibleViewControllerFrom(navigationController.visibleViewController!)
        } else if vc.isKind(of: UITabBarController.self) {
            let tabBarController = vc as! UITabBarController
            return UIWindow.getVisibleViewControllerFrom(tabBarController.selectedViewController!)
        } else {
            if let presentedViewController = vc.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(presentedViewController.presentedViewController ?? presentedViewController)
            } else {
                return vc
            }
        }
    }

    /// Take a screenshot of current window, choose if save it or not after a delay.
    ///
    /// - Parameters:
    ///   - delay: The delay, in seconds.
    ///   - save: Set to true to save, otherwise false.
    ///   - completion: Completion handler with the UIImage.
    public func windowScreenshot(delay: Double, save: Bool = false, completion: @escaping (_ screeshot: UIImage?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            completion(self.windowScreenshot(save: save))
        })
    }

    // do not use `NSClassFromString("UIRemoteKeyboardWindow")`, this is private API

    public var isKeyboardWindow: Bool {
        return String(describing: classForCoder) == "UIRemoteKeyboardWindow"
    }

    public class var isTopWindowKeyboard: Bool {
        return UIApplication.shared.windows.last?.isKeyboardWindow ?? false
    }

    public class var keyboardWindow: (Bool, UIWindow?) {
        return (isTopWindowKeyboard, UIApplication.shared.windows.last)
    }
}

public func changeKeyboardColorWith(_ color: UIColor) {

    guard UIWindow.keyboardWindow.0, let kbWindow = UIWindow.keyboardWindow.1 else { return }

    kbWindow.loopViews("UIKBBackdropView") { subView in
        subView.backgroundColor = color
    }
}

public func opaqueKeyboardKeyView() {

    guard UIWindow.keyboardWindow.0, let kbWindow = UIWindow.keyboardWindow.1 else { return }

    kbWindow.loopViews("UIKBKeyView", shouldReturn: false) { subView in
        subView.isOpaque = true
    }
}
