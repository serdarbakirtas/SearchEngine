//
//  UIViewController.swift
//  Pods
//
//  Ali Kiran on 11/24/16.
//
//
#if os(iOS) || os(tvOS)
    import UIKit
    import Foundation
    import CVKHierarchySearcher

    public extension UIViewController {
        /// SwifterSwift: Assign as listener to notification.
        ///
        /// - Parameters:
        ///   - name: notification name.
        ///   - selector: selector to run with notified.
        public func addNotificationObserver(name: Notification.Name, selector: Selector) {
            NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
        }

        /// SwifterSwift: Unassign as listener to notification.
        ///
        /// - Parameter name: notification name.
        public func removeNotificationObserver(name: Notification.Name) {
            NotificationCenter.default.removeObserver(self, name: name, object: nil)
        }

        /// SwifterSwift: Unassign as listener from all notifications.
        public func removeNotificationsObserver() {
            NotificationCenter.default.removeObserver(self)
        }

        public func applyCardShadow() {
            self.view.applyShadow()
        }

        public func isModal() -> Bool {
            return self.presentingViewController?.presentedViewController == self
                || (self.navigationController != nil && self.navigationController?.presentingViewController?.presentedViewController == self.navigationController)
                || self.tabBarController?.presentingViewController is UITabBarController
        }

        public func dismissAndWait(_ callback: @escaping (UIViewController) -> Void) {
            UIView.animate(withDuration: 1.0, animations: {
                self.dismiss(animated: false, completion: {
                })
            }, completion: { _ in
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
                callback(self)
            })
        }

        @discardableResult public func present(_ complete: ((UIViewController) -> Void)? = nil) -> Self? {
            guard Thread.isMainThread else {
                DispatchQueue.main.async(execute: {
                    self.present(complete)
                })

                return self
            }

            let topmost = CVKHierarchySearcher()
            guard var topController = topmost.topmostViewController else {
                return nil

            }

            guard self != topController else {
                return nil
            }

            assert((self as UIViewController).presentingViewController == nil)
            if topController.view.window == nil {
                for child in topController.childViewControllers {
                    if child.view.window != nil {
                        topController = child
                    }
                }
            }

            if topController.isModal() {
                if topController is UIAlertController {
                    topController.dismiss(animated: true, completion: {

                        self.present(complete)
                    })

                    return nil
                }
                //
                if topController.isBeingDismissed {
                    perform_after(0.0, queue: DispatchQueue.main) {
                        topmost.topmostNonModalViewController.present(self, animated: true, completion: {
                            complete?(self)
                        })
                    }
                } else {
                    topController.present(self, animated: true, completion: {
                        complete?(self)
                    })
                }

            } else {
                topController.present(self, animated: true, completion: {
                    complete?(self)
                })
            }

            return self
        }

        open func actionPop(callback: (() -> Void)? = nil) {
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                perform_after(1.0, closure: {
                    callback?()
                })
            }

            self.actionPop()
            CATransaction.commit()
        }

        var buttonCallback: ((UIButton) -> Void)? {
            set {
                self.setTempObject(newValue, key: "buttonCallback")
            }

            get {
                return self.tempObject(key: "buttonCallback") as? ((UIButton) -> Void)
            }
        }

        var popCallback: ((UIViewController) -> Void)? {
            set {
                self.setTempObject(newValue, key: "popCallback")
            }

            get {
                return self.tempObject(key: "popCallback") as? ((UIViewController) -> Void)
            }
        }

        @IBAction open func actionPop() {
            if self.navigationController?.viewControllers.first == self && self.navigationController?.presentingViewController != nil {
                self.dismiss(animated: true, completion: {
                    self.popCallback?(self)
                })
            } else if self.navigationController != nil {
                _ = self.navigationController?.popViewController(animated: true)
                self.popCallback?(self)
            } else {
                self.dismiss(animated: true) {
                    self.popCallback?(self)
                }
            }
        }

        // NavigationBar in a ViewController.
        public var navigationBar: UINavigationBar? {
            return navigationController?.navigationBar
        }

        public func isVisible() -> Bool {
            return self.isViewLoaded && self.view.window != nil
        }

        /// Retrieve the view controller currently on-screen
        ///
        /// Based off code here: http://stackoverflow.com/questions/24825123/get-the-current-view-controller-from-the-app-delegate
        public static var current: UIViewController? {
            if let controller = UIApplication.shared.keyWindow?.rootViewController {
                return findCurrent(controller)
            }
            return nil
        }

        private static func findCurrent(_ controller: UIViewController) -> UIViewController {
            if let controller = controller.presentedViewController {
                return findCurrent(controller)
            } else if let controller = controller as? UISplitViewController, let lastViewController = controller.viewControllers.first, controller.viewControllers.count > 0 {
                return findCurrent(lastViewController)
            } else if let controller = controller as? UINavigationController, let topViewController = controller.topViewController, controller.viewControllers.count > 0 {
                return findCurrent(topViewController)
            } else if let controller = controller as? UITabBarController, let selectedViewController = controller.selectedViewController, (controller.viewControllers?.count ?? 0) > 0 {
                return findCurrent(selectedViewController)
            } else {
                return controller
            }
        }

        public var statusBarFrame: CGRect {
            return view.window?.convert(UIApplication.shared.statusBarFrame, to: view) ?? CGRect.zero
        }

        public var topBarHeight: CGFloat {
            var navBarHeight: CGFloat {
                guard let bar = navigationController?.navigationBar else { return 0 }
                return view.window?.convert(bar.frame, to: view).height ?? 0
            }
            let statusBarHeight = view.window?.convert(UIApplication.shared.statusBarFrame, to: view).height ?? 0
            return statusBarHeight + navBarHeight
        }

        /**
         While trying to present a new controller, current controller' bar may disappear temporary.
         But I still need the real height of top bar.
         - Why not set a constant (64.0 or 32.0)? Apple may change the constant in some device in the future.
         */
        public func topBarHeightWhenTemporaryDisappear() -> CGFloat {
            let key = "kASTopBarHeightWhenTemporaryDisappear"
            if UserDefaults.standard.value(forKey: key) == nil {
                UserDefaults.standard.setValue(topBarHeight, forKey: key)
            } else if topBarHeight != 0 && topBarHeight != UserDefaults.standard.value(forKey: key) as! CGFloat {
                UserDefaults.standard.setValue(topBarHeight, forKey: key)
            }
            return UserDefaults.standard.value(forKey: key) as! CGFloat
        }



        func hideKeyboardWhenTappedAround() {
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(
                target: self, action: #selector(UIViewController.dismissKeyboard))

            view.addGestureRecognizer(tap)
        }

        func dismissKeyboard() {
            view.endEditing(true)
        }


    }
#endif
