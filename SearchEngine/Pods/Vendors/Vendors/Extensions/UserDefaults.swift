//
//  UserDefaults.swift
//  Pods
//
//  Created by away4m on 12/31/16.
//
//

import Foundation

public extension UserDefaults {
    public func bool(forKey key: String, defaultValue: Bool) -> Bool {
        if value(forKey: key) == nil {
            set(defaultValue, forKey: key)
        }
        return bool(forKey: key)
    }

    public func integer(forKey key: String, defaultValue: Int) -> Int {
        if value(forKey: key) == nil {
            set(defaultValue, forKey: key)
        }
        return integer(forKey: key)
    }

    public func string(forKey key: String, defaultValue: String) -> String {
        if value(forKey: key) == nil {
            set(defaultValue, forKey: key)
        }
        return string(forKey: key) ?? defaultValue
    }

    public func double(forKey key: String, defaultValue: Double) -> Double {
        if value(forKey: key) == nil {
            set(defaultValue, forKey: key)
        }
        return double(forKey: key)
    }

    public func object(forKey key: String, defaultValue: AnyObject) -> Any? {
        if object(forKey: key) == nil {
            set(defaultValue, forKey: key)
        }
        return object(forKey: key)
    }

    public func setArchivedData(_ object: Any?, forKey key: String) {
        var data: Data?
        if let object = object {
            data = NSKeyedArchiver.archivedData(withRootObject: object)
        }
        set(data, forKey: key)
    }

    public func unarchiveObjectWithData(forKey key: String) -> Any? {
        guard let object = object(forKey: key) else { return nil }
        guard let data = object as? Data else { return nil }
        return NSKeyedUnarchiver.unarchiveObject(with: data)
    }

    public func color(forKey key: String) -> UIColor? {
        var color: UIColor?
        if let colorData = data(forKey: key) {
            color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
        }
        return color
    }

    public func setColor(_ color: UIColor?, forKey key: String) {
        var colorData: Data?
        if let color = color {
            colorData = NSKeyedArchiver.archivedData(withRootObject: color)
        }
        set(colorData, forKey: key)
    }
}
