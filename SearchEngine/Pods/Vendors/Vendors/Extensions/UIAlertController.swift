//
//  UIAlertController.swift
//  Pods
//
//  Created by Admin on 11/24/16.
//
//

import Foundation
import UIKit

public extension UIAlertController {
  public static func actionSheet(title: String? = nil, message: String? = nil) -> UIAlertController {
    return UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
  }

  //    public convenience init(title: String? = nil, message: String? = nil, preferredStyle: UIAlertControllerStyle = .alert, actions: [UIAlertAction]) {
  //        self.init(title: title, message: message, preferredStyle: preferredStyle)
  //
  //        for action in actions {
  //            self.addAction(action)
  //        }
  //    }

  //    public convenience init(title: String, message: String? = nil, defaultActionButtonTitle: String = "Tamam", tintColor: UIColor? = nil) {
  //        self.init(title: title, message: message, preferredStyle: .alert)
  //        let defaultAction = UIAlertAction(title: defaultActionButtonTitle, style: .default, handler: nil)
  //        self.addAction(defaultAction)
  //        if let color = tintColor {
  //            self.view.tintColor = color
  //        }
  //    }
  //
  //    public convenience init(title: String = "", error: Error, defaultActionButtonTitle: String = "Tamam", tintColor: UIColor? = nil) {
  //        self.init(title: title, message: error.localizedDescription, preferredStyle: .alert)
  //        let defaultAction = UIAlertAction(title: defaultActionButtonTitle, style: .default, handler: nil)
  //        self.addAction(defaultAction)
  //        if let color = tintColor {
  //            self.view.tintColor = color
  //        }
  //    }

  @discardableResult public class func present(message: String, handler: ((UIAlertAction?) -> Void)? = nil) -> UIAlertController {
    return UIAlertController.present(title: "", message: message, handler: handler)
  }

  @discardableResult public class func present(title: String, message: String = "", handler: ((UIAlertAction?) -> Void)? = nil) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.default, handler: handler))
    return alert
  }

  @discardableResult public class func alert(title: String, message: String = "") -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    return alert
  }

  @discardableResult public class func alert(error: NSError, handler: ((UIAlertAction?) -> Void)? = nil) -> UIAlertController {
    let alert = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.default, handler: handler))
    return alert
  }

  @discardableResult public class func alert(message: String, handler: ((UIAlertAction?) -> Void)? = nil) -> UIAlertController {
    let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.default, handler: handler))
    return alert
  }

  @discardableResult public class func alert(title: String, message: String = "", handler: ((UIAlertAction?) -> Void)? = nil) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.default, handler: handler))
    return alert
  }

  @discardableResult public class func alert(title: String, message: String, cancelTitle: String?, otherButtons: NSArray = [], handler: ((UIAlertAction, Int) -> Void)?) -> UIAlertController {
    let alert = UIAlertController.alert(title: title, message: message)

    if let cancelTitle = cancelTitle {
      alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: { [alert] action in
        alert.dismissAndWait({ _ in
          handler?(action, 0)
        })
      }))
    }

    let offset = cancelTitle == nil ? 0 : 1
    var sequent = 0
    for other in otherButtons {
      alert.addAction(UIAlertAction(title: other as? String, style: .default, handler: { action in
        handler?(action, sequent + offset)
      }))

      sequent = sequent + 1
    }

    alert.present()
    return alert
  }

  // Add an action to Alert
  ///
  /// - Parameters:
  ///   - title: action title
  ///   - style: action style (default is UIAlertActionStyle.default)
  ///   - isEnabled: isEnabled status for action (default is true)
  ///   - handler: optional action handler to be called when button is tapped (default is nil)
  /// - Returns: action created by this method
  @discardableResult public func addAction(title: String, style: UIAlertActionStyle = .default, isEnabled: Bool = true, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
    let action = UIAlertAction(title: title, style: style, handler: handler)
    action.isEnabled = isEnabled
    addAction(action)
    return action
  }

  // Add a text field to Alert
  ///
  /// - Parameters:
  ///   - text: text field text (default is nil)
  ///   - placeholder: text field placeholder text (default is nil)
  ///   - editingChangedTarget: an optional target for text field's editingChanged
  ///   - editingChangedSelector: an optional selector for text field's editingChanged
  public func addTextField(text: String? = nil, placeholder: String? = nil, editingChangedTarget: Any?, editingChangedSelector: Selector?) {
    addTextField { tf in
      tf.text = text
      tf.placeholder = placeholder
      if let target = editingChangedTarget, let selector = editingChangedSelector {
        tf.addTarget(target, action: selector, for: .editingChanged)
      }
    }
  }

}
