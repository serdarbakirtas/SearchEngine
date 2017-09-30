//
//  UIStoryboard.swift
//  Pods
//
//  Created by away4m on 12/31/16.
//
//

import Foundation

public extension UIStoryboard {

    /// Instantiates and returns the view controller with the specified identifier.
    /// Note: withIdentifier must equal to the vc Class
    public func instantiateViewController<T: UIViewController>(with vc: T.Type) -> T {
        return instantiateViewController(withIdentifier: String(describing: vc.self)) as! T
    }
    
    class func initialViewController(_ name: String) -> UIViewController {
        let sb = UIStoryboard(name: name, bundle: nil)
        return sb.instantiateInitialViewController()!
    }

    class func initialViewController(_ name: String, identifier: String) -> UIViewController {
        let sb = UIStoryboard(name: name, bundle: nil)
        return sb.instantiateViewController(withIdentifier: identifier)
    }
}
