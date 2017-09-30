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
    import Signals

    public extension UIViewController {
        var signalButton: Signal<UIButton> {
            if self.tempObject(key: "signalButton") == nil {
                self.setTempObject(Signal<UIButton>(), key: "signalButton")
            }

            return self.tempObject(key: "signalButton") as! Signal<UIButton>
        }

        @IBAction public func actionButton(_ sender: UIButton) {
            self.signalButton.fire(sender)
            self.buttonCallback?(sender)
        }

    }
#endif
