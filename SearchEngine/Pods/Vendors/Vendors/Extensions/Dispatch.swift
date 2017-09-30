//
//  Dispatch.swift
//  Pods
//
//  Created by Admin on 11/24/16.
//
//

import Foundation
import UIKit

public func perform_after_delay(_ delay: TimeInterval, queue: DispatchQueue, block: @escaping () -> Void) {
    let time = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    queue.asyncAfter(deadline: time, execute: block)
}

public typealias cancellable_closure = (() -> Void)?

@discardableResult public func perform_after(_ seconds: Double, queue: DispatchQueue = DispatchQueue.main, closure: @escaping () -> Void) -> cancellable_closure {
    var cancelled = false
    let cancel_closure: cancellable_closure = {
        cancelled = true
    }

    queue.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
        execute: {
            if !cancelled {
                closure()
            }
        }
    )

    return cancel_closure
}

public func cancel_perform_after(_ cancel_closure: cancellable_closure) {
    cancel_closure?()
}
