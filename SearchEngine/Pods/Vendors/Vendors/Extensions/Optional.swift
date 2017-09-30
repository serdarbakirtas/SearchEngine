//
//  Optional.swift
//  Pods
//
//  Created by ALI KIRAN on 3/26/17.
//
//

import Foundation
// https://github.com/RuiAAPeres/OptionalExtensions
public extension Optional {

    func filter(_ predicate: (Wrapped) -> Bool) -> Optional {
        return map(predicate) == .some(true) ? self : .none
    }

    func mapNil(_ predicate: () -> Wrapped) -> Optional {
        return self ?? .some(predicate())
    }

    func flatMapNil(_ predicate: () -> Optional) -> Optional {
        return self ?? predicate()
    }

    func then(_ f: (Wrapped) -> Void) {
        if let wrapped = self { f(wrapped) }
    }

    func maybe<U>(_ defaultValue: U, f: (Wrapped) -> U) -> U {
        return map(f) ?? defaultValue
    }

    func onSome(_ f: (Wrapped) -> Void) -> Optional {
        self.then(f)
        return self
    }

    func onNone(_ f: () -> Void) -> Optional {
        if isNone { f() }
        return self
    }

    var isSome: Bool {
        return self != nil
    }

    var isNone: Bool {
        return !self.isSome
    }
}
