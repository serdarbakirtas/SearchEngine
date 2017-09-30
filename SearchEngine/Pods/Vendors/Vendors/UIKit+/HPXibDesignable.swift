//
//  HPXibDesignable.swift
//  Pods
//
//  Created by Huy Pham on 9/24/15.
//
//

import UIKit

@IBDesignable
open class HPXibDesignable: UIView {
  open var view: UIView?
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupNib()
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupNib()
    onViewReady()
  }

  var readyCallback: (() -> Void)? {
    didSet {
      if self.window != nil {
        self.readyCallback?()
      }
    }
  }
  func onViewReady() {
    readyCallback?()
  }

  fileprivate func setupNib() {
    view = loadNib()
    if let view = view {
      view.translatesAutoresizingMaskIntoConstraints = false

      addSubview(view)

      let bindings = ["view": view]
      addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: bindings))
      addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: bindings))
    }
  }

  fileprivate func loadNib() -> UIView? {
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: nibName(), bundle: bundle)
    return nib.instantiate(withOwner: self, options: nil)[0] as? UIView
  }

  open func nibName() -> String {
    return type(of: self).description().components(separatedBy: ".").last!
  }
}
