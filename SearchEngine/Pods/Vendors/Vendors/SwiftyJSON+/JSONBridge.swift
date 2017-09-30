//
//  JSON.swift
//  Pods
//
//  Created by ALI KIRAN on 3/3/17.
//
//

//  MAHALLEMKULLANICI
//
//  Created by ALI KIRAN on 3/3/17.
//  Copyright © 2017 Ali KIRAN. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

@objc public class JSONBridge: NSObject {
    public var boxed: JSON!

    public init(_ object: Any) {
        boxed = JSON(object)
    }

    public init(json string: String) {
        boxed = JSON(parseJSON: string)
    }

    public init(_ json: JSON) {
        boxed = json
    }

    public func dictionaryObject() -> [String: Any]? {
        return boxed.dictionaryObject
    }

    public func arrayObject() -> [Any]? {
        return boxed.arrayObject
    }

    public var array: [JSON]? {
        return self.boxed.array
    }
    
    public var arrayValueBridge: [JSONBridge] {
        return self.boxed.arrayValue.map({JSONBridge($0)})
    }

    // Non-optional [JSON]
    public var arrayValue: [JSON] {
        return self.boxed.arrayValue
    }

    public var dictionary: [String: JSON]? {
        return self.boxed.dictionary
    }

    // Non-optional [String : JSON]
    public var dictionaryValue: [String: JSON] {
        return self.boxed.dictionaryValue
    }

    public var bool: Bool? {
        get {
            return self.boxed.bool
        }
        set {
            self.boxed.bool = newValue
        }
    }

    // Non-optional bool
    public var boolValue: Bool {
        get {
            return self.boxed.boolValue
        }
        set {
            self.boxed.object = newValue
        }
    }

    // Optional string
    public var string: String? {
        get {
            return self.boxed.string
        }
        set {
            self.boxed.string = newValue
        }
    }

    // Non-optional string
    public var stringValue: String {
        get {
            return self.boxed.stringValue
        }
        set {
            self.boxed.stringValue = newValue
        }
    }

    // Optional number
    public var number: NSNumber? {
        get {
            return self.boxed.number
        }
        set {
            self.boxed.number = newValue
        }
    }

    // Non-optional number
    public var numberValue: NSNumber {
        get {
            return self.boxed.numberValue
        }
        set {
            self.boxed.numberValue = newValue
        }
    }

    public var null: NSNull? {
        get {
            return self.boxed.null
        }
        set {
            self.boxed.null = newValue
        }
    }

    public func exists() -> Bool {
        return boxed.exists()
    }

    // Optional URL
    public var url: URL? {
        get {
            return self.boxed.url
        }
        set {
            self.boxed.url = newValue

        }
    }

    func merge(_ object: Any) -> JSONBridge? {
        let income = JSON(object)
        do {
            _ = try boxed.merged(with: income)
        } catch {
            return nil
        }

        return self
    }

    public var object: Any {
        get {
            return self.boxed.object
        }

        set {
            self.boxed.object = newValue
        }
    }

    public var double: Double? {
        get {
            return self.boxed.double
        }
        set {
            self.boxed.double = newValue
        }
    }

    public var doubleValue: Double {
        get {
            return self.boxed.doubleValue
        }
        set {
            self.boxed.doubleValue = newValue
        }
    }

    public var float: Float? {
        get {
            return self.boxed.float
        }
        set {
            self.boxed.float = newValue
        }
    }

    public var floatValue: Float {
        get {
            return self.boxed.floatValue
        }
        set {
            self.boxed.floatValue = newValue
        }
    }

    public var int: Int? {
        get {
            return self.boxed.int
        }
        set {
            self.boxed.int = newValue
        }
    }

    public var intValue: Int {
        get {
            return self.boxed.intValue
        }
        set {
            self.boxed.intValue = newValue
        }
    }

    public var uInt: UInt? {
        get {
            return self.boxed.uInt
        }
        set {
            self.boxed.uInt = newValue
        }
    }

    public var uIntValue: UInt {
        get {
            return self.boxed.uIntValue
        }
        set {
            self.boxed.uIntValue = newValue
        }
    }

    public var int8: Int8? {
        get {
            return self.boxed.int8
        }
        set {
            self.boxed.int8 = newValue
        }
    }

    public var int8Value: Int8 {
        get {
            return self.boxed.int8Value
        }
        set {
            self.boxed.int8Value = newValue
        }
    }

    public var uInt8: UInt8? {
        get {
            return self.boxed.uInt8
        }
        set {
            self.boxed.uInt8 = newValue
        }
    }

    public var uInt8Value: UInt8 {
        get {
            return self.boxed.uInt8Value
        }
        set {
            self.boxed.uInt8Value = newValue
        }
    }

    public var int16: Int16? {
        get {
            return self.boxed.int16
        }
        set {
            self.boxed.int16 = newValue
        }
    }

    public var int16Value: Int16 {
        get {
            return self.boxed.int16Value
        }
        set {
            self.boxed.int16Value = newValue
        }
    }

    public var uInt16: UInt16? {
        get {
            return self.boxed.uInt16
        }
        set {
            self.boxed.uInt16 = newValue
        }
    }

    public var uInt16Value: UInt16 {
        get {
            return self.boxed.uInt16Value
        }
        set {
            self.boxed.uInt16Value = newValue
        }
    }

    public var int32: Int32? {
        get {
            return self.boxed.int32
        }
        set {
            self.boxed.int32 = newValue
        }
    }

    public var int32Value: Int32 {
        get {
            return self.boxed.int32Value
        }
        set {
            self.boxed.int32Value = newValue
        }
    }

    public var uInt32: UInt32? {
        get {
            return self.boxed.uInt32
        }
        set {
            self.boxed.uInt32 = newValue
        }
    }

    public var uInt32Value: UInt32 {
        get {
            return self.numberValue.uint32Value
        }
        set {
            self.object = NSNumber(value: newValue)
        }
    }

    public var int64: Int64? {
        get {
            return self.boxed.int64
        }
        set {
            self.boxed.int64 = newValue
        }
    }

    public var int64Value: Int64 {
        get {
            return self.numberValue.int64Value
        }
        set {
            self.object = NSNumber(value: newValue)
        }
    }

    public var uInt64: UInt64? {
        get {
            return self.boxed.uInt64
        }
        set {
            self.boxed.uInt64 = newValue
        }
    }

    public var uInt64Value: UInt64 {
        get {
            return self.boxed.uInt64Value
        }
        set {
            self.boxed.uInt64Value = newValue
        }
    }

    public override var description: String {
        return self.boxed.description
    }

    public override var debugDescription: String {
        return self.boxed.debugDescription
    }

    public var rawValue: Any {
        return self.boxed.rawValue
    }

    public func rawString() -> String? {
        return boxed.rawString()
    }

    public var type: Int { return self.boxed.type.rawValue }

    public var error: NSError? { return self.boxed.error }
    public static var null: JSONBridge { return JSONBridge(JSON(NSNull())) }

    @objc open func objectForKeyedSubscript(_ key: String) -> JSONBridge {
        return JSONBridge(boxed[key])
    }

    @objc open func objectAtIndexedSubscript(_ idx: Int) -> JSONBridge {
        return JSONBridge(boxed[idx])
    }

}

extension JSONBridge: Swift.Comparable {}

public func == (lhs: JSONBridge, rhs: JSONBridge) -> Bool {

    return lhs.boxed == rhs.boxed
}

public func <= (lhs: JSONBridge, rhs: JSONBridge) -> Bool {
    return lhs.boxed <= rhs.boxed
}

public func >= (lhs: JSONBridge, rhs: JSONBridge) -> Bool {

    return lhs.boxed >= rhs.boxed
}

public func > (lhs: JSONBridge, rhs: JSONBridge) -> Bool {

    return lhs.boxed > rhs.boxed
}

public func < (lhs: JSONBridge, rhs: JSONBridge) -> Bool {

    return lhs.boxed < rhs.boxed
}
