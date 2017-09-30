//
//  SignalBridge.swift
//  Pods
//
//  Created by ALI KIRAN on 4/2/17.
//
//

import Foundation
import Signals

public class SignalSubscriptionBridge: NSObject {
    var subscription: SignalSubscription<Any>?
}

public class SignalBridge: NSObject {
    public let signal: Signal<Any> = Signal<Any>()
    
    public var retainLastData: Bool = false {
        didSet {
            self.signal.retainLastData = retainLastData
        }
    }
    
    public var observers: [AnyObject] {
        return self.signal.observers
    }
    
    public var fireCount: Int {
        return self.signal.fireCount
    }
    
    public var lastDataFired: Any? {
        return self.signal.lastDataFired
    }
    
    public func fire(_ data: Any) {
        signal.fire(data)
    }
    
    @discardableResult
    public func subscribe(on observer: AnyObject, callback: @escaping (Any) -> Void) -> SignalSubscriptionBridge {
        let subsBridge: SignalSubscriptionBridge = SignalSubscriptionBridge()
        
        subsBridge.subscription = signal.subscribe(on: observer, callback: callback)
        
        return subsBridge
    }
    
    @discardableResult
    public func subscribeOnce(on observer: AnyObject, callback: @escaping (Any) -> Void) -> SignalSubscriptionBridge {
        let subsBridge: SignalSubscriptionBridge = SignalSubscriptionBridge()
        let signalListener = signal.subscribe(on: observer, callback: callback)
        signalListener.once = true
        subsBridge.subscription = signalListener
        return subsBridge
    }
    
    @discardableResult
    public func subscribePast(on observer: AnyObject, callback: @escaping (Any) -> Void) -> SignalSubscriptionBridge {
        let subsBridge: SignalSubscriptionBridge = SignalSubscriptionBridge()
        subsBridge.subscription = signal.subscribePast(on: observer, callback: callback)
        
        return subsBridge
    }
    
    @discardableResult
    public func subscribePastOnce(on observer: AnyObject, callback: @escaping (Any) -> Void) -> SignalSubscriptionBridge {
        let subsBridge: SignalSubscriptionBridge = SignalSubscriptionBridge()
        subsBridge.subscription = signal.subscribePastOnce(on: observer, callback: callback)
        
        return subsBridge
    }
    
    public func cancelSubscription(for observer: AnyObject) {
        return signal.cancelSubscription(for: observer)
    }
    
    public func cancelAllSubscriptions() {
        signal.cancelAllSubscriptions()
    }
    
    /// Clears the last fired data from the `Signal` and resets the fire count.
    public func clearLastData() {
        signal.clearLastData()
    }
}

infix operator =>

/// Helper operator to fire signal data.
public func => (signal: SignalBridge, data: Any) -> Void {
    signal.fire(data)
}
