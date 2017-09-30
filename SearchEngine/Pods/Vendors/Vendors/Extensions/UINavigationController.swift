//
//  UINavigationController.swift
//  Pods
//
//  Created by away4m on 12/30/16.
//
//

import Foundation

public extension UINavigationController {

    ///  SwifterSwift: Pop ViewController with completion handler.
    ///
    /// - Parameter completion: optional completion handler (default is nil).
    public func popViewController(completion: (() -> Void)? = nil) {
        // https://github.com/cotkjaer/UserInterface/blob/master/UserInterface/UIViewController.swift
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: true)
        CATransaction.commit()
    }

    // Push ViewController with completion handler.
    ///
    /// - Parameters:
    ///   - viewController: viewController to push.
    /// - Parameter completion: optional completion handler (default is nil).
    public func pushViewController(viewController: UIViewController, completion: (() -> Void)? = nil) {
        // https://github.com/cotkjaer/UserInterface/blob/master/UserInterface/UIViewController.swift
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: true)
        CATransaction.commit()
    }

    // Make navigation controller's navigation bar transparent.
    ///
    /// - Parameter withTint: tint color (default is .white).
    public func makeTransparent(withTint: UIColor = .white) {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.tintColor = withTint
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: withTint]
    }

    public func completelyTransparentBar() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        view.backgroundColor = UIColor.clear
        navigationBar.backgroundColor = UIColor.clear
    }


    public func previousViewController() -> UIViewController? {
        return viewController(at: viewControllers.count - 2)
    }

    public func viewController(at index: Int) -> UIViewController? {
        guard index >= 0 else { return nil }
        return viewControllers[index]
    }

    public func removeViewController(at index: Int) {
        var _viewControllers = viewControllers
        _viewControllers.remove(at: index)
        viewControllers = _viewControllers
    }

    public func removeViewController(atTail index: Int) {
        var _viewControllers = viewControllers
        _viewControllers.remove(at: _viewControllers.count - index - 1)
        viewControllers = _viewControllers
    }

    public func removeViewControllers(previous number: Int) {
        var _viewControllers = viewControllers
        if number < _viewControllers.count {
            _viewControllers.removeSubrange(_viewControllers.count - number - 1..._viewControllers.count - 2)
            viewControllers = _viewControllers
        }
    }

    public func removePreviousViewController() {
        removeViewController(atTail: 1)
    }
}
