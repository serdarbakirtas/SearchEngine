//
//  UISwitch.swift
//  Pods
//
//  Created by away4m on 12/30/16.
//
//
#if os(iOS)
    import Foundation

    // MARK: - Methods
    public extension UISwitch {

        // Toggle a UISwitch
        ///
        /// - Parameter animated: set true to animate the change (default is true)
        public func toggle(animated: Bool = true) {
            setOn(!isOn, animated: animated)
        }
    }
#endif
