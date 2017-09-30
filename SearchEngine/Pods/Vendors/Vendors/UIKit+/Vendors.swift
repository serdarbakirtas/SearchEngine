//
//  Vendors.swift
//  Pods
//
//  Created by away4m on 12/30/16.
//
//

import Foundation

/// Get AppDelegate. To use it, cast to AppDelegate with "as! AppDelegate".
public let appDelegate: UIApplicationDelegate? = UIApplication.shared.delegate

// MARK: - Properties
// Common usefull properties and methods.
@objc public class Vendors: NSObject {

  static var vendorID: String {
    return UIDevice.current.identifierForVendor?.uuidString ??? ""
  }

  public static func ifAppUser(name: String, callback: () -> Void) {
    let env = ProcessInfo.processInfo.environment
    if let user = env["user"], user == name {
      callback()
    }
  }

  // App's bundle ID (if applicable).
  public static var bundleId: String {
    return Bundle.main.bundleIdentifier ?? ""
  }

  // StatusBar height
  public static var statusBarHeight: CGFloat {
    return UIApplication.shared.statusBarFrame.height
  }

  /// Return the App name.
  public static var name: String = {
    Vendors.string(forKey: "CFBundleDisplayName") ?? ""
  }()

  // App current build build (if applicable).
  public static var build: String {
    return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? ""
  }

  // Application icon badge current number.
  public static var applicationIconBadgeNumber: Int {
    get {
      return UIApplication.shared.applicationIconBadgeNumber
    }
    set {
      UIApplication.shared.applicationIconBadgeNumber = newValue
    }
  }

  // App's current version (if applicable).
  public static var bundleVersion: String {
    return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
  }

  // Current battery level.
  public static var batteryLevel: Float {
    return UIDevice.current.batteryLevel
  }

  // Shared instance of current device.
  public static var currentDevice: UIDevice {
    return UIDevice.current
  }

  // Screen height.
  public static var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
  }

  // Current device model.
  public static var deviceModel: String {
    return UIDevice.current.model
  }

  // Current device name.
  public static var deviceName: String {
    return UIDevice.current.name
  }

  // Current orientation of device.
  public static var deviceOrientation: UIDeviceOrientation {
    return UIDevice.current.orientation
  }

  // Screen width.
  public static var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
  }

  // MARK: - Functions

  /// Executes a block only if in DEBUG mode.
  ///
  /// More info on how to use it [here](http://stackoverflow.com/questions/26890537/disabling-nslog-for-production-in-swift-project/26891797#26891797).
  ///
  /// - Parameter block: The block to be executed.
  public static func debug(_ block: () -> Void) {
    #if DEBUG
      block()
    #endif
  }

  // Check if app is running in debug mode.
  public static var isInDebuggingMode: Bool {
    // http://stackoverflow.com/questions/9063100/xcode-ios-how-to-determine-whether-code-is-running-in-debug-release-build
    #if DEBUG
      return true
    #else
      return false
    #endif
  }

  // Check if multitasking is supported in current device.
  public static var isMultitaskingSupported: Bool {
    return UIDevice.current.isMultitaskingSupported
  }

  // Current status bar network activity indicator state.
  public static var isNetworkActivityIndicatorVisible: Bool {
    get {
      return UIApplication.shared.isNetworkActivityIndicatorVisible
    }
    set {
      UIApplication.shared.isNetworkActivityIndicatorVisible = newValue
    }
  }

  // Check if device is iPad.
  public static var isPad: Bool {
    return UIDevice.current.userInterfaceIdiom == .pad
  }

  // Check if device is iPhone.
  public static var isPhone: Bool {
    return UIDevice.current.userInterfaceIdiom == .phone
  }

  // Check if device is registered for remote notifications for current app (read-only).
  public static var isRegisteredForRemoteNotifications: Bool {
    return UIApplication.shared.isRegisteredForRemoteNotifications
  }

  // Check if application is running on simulator (read-only).
  public static var isRunningOnSimulator: Bool {
    // http://stackoverflow.com/questions/24869481/detect-if-app-is-being-built-for-device-or-simulator-in-swift
    #if (arch(i386) || arch(x86_64)) && (os(iOS) || os(watchOS) || os(tvOS))
      return true
    #else
      return false
    #endif
  }

  // Status bar visibility state.
  public static var isStatusBarHidden: Bool {
    get {
      return UIApplication.shared.isStatusBarHidden
    }
    set {
      UIApplication.shared.isStatusBarHidden = newValue
    }
  }

  // Key window (read only, if applicable).
  public static var keyWindow: UIView? {
    return UIApplication.shared.keyWindow
  }

  // Most top view controller (if applicable).
  public static var mostTopViewController: UIViewController? {
    get {
      return UIApplication.shared.keyWindow?.rootViewController
    }
    set {
      UIApplication.shared.keyWindow?.rootViewController = newValue
    }
  }

  // Shared instance UIApplication.
  public static var sharedApplication: UIApplication {
    return UIApplication.shared
  }

  // Current status bar style (if applicable).
  public static var statusBarStyle: UIStatusBarStyle? {
    get {
      return UIApplication.shared.statusBarStyle
    }
    set {
      if let style = newValue {
        UIApplication.shared.statusBarStyle = style
      }
    }
  }

  // System current version (read-only).
  public static var systemVersion: String {
    return UIDevice.current.systemVersion
  }

  // Shared instance of standard UserDefaults (read-only).
  public static var userDefaults: UserDefaults {
    return UserDefaults.standard
  }

  private static let BFAppHasBeenOpened = "BFAppHasBeenOpened"

  /// If version is set returns if is first start for that version,
  /// otherwise returns if is first start of the App.
  ///
  /// - Parameter version: Version to be checked, you can use the global varialble AppVersion to pass the current App version.
  /// - Returns: Returns if is first start of the App or for custom version.
  public static func isFirstStart(version: String = "") -> Bool {
    let key: String
    if version == "" {
      key = BFAppHasBeenOpened
    } else {
      key = BFAppHasBeenOpened + "\(version)"
    }

    let defaults = UserDefaults.standard
    let hasBeenOpened: Bool = defaults.bool(forKey: key)

    return !hasBeenOpened
  }

  /// Executes a block on first start of the App, if version is set it will be for given version.
  ///
  /// Remember to execute UI instuctions on main thread.
  ///
  /// - Parameters:
  ///   - version: Version to be checked, you can use the global varialble AppVersion to pass the current App version.
  ///   - block: The block to execute, returns isFirstStart.
  public static func onFirstStart(version: String = "", block: (_ isFirstStart: Bool) -> Void) {
    let key: String
    if version == "" {
      key = BFAppHasBeenOpened
    } else {
      key = BFAppHasBeenOpened + "\(version)"
    }

    let defaults = UserDefaults.standard
    let hasBeenOpened: Bool = defaults.bool(forKey: key)
    if hasBeenOpened != true {
      defaults.set(true, forKey: key)
    }

    block(!hasBeenOpened)
  }

}

// MARK: - Methods
public extension Vendors {

  // Called when user takes a screenshot
  ///
  /// - Parameter action: a closure to run when user takes a screenshot
  public static func didTakeScreenShot(_ action: @escaping () -> Void) {
    // http://stackoverflow.com/questions/13484516/ios-detection-of-screenshot
    let mainQueue = OperationQueue.main
    NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationUserDidTakeScreenshot, object: nil, queue: mainQueue) { _ in
      action()
    }
  }

  // Object from UserDefaults.
  ///
  /// - Parameter forKey: key to find object for.
  /// - Returns: Any object for key (if exists).
  public static func object(forKey: String) -> Any? {
    return UserDefaults.standard.object(forKey: forKey)
  }

  // String from UserDefaults.
  ///
  /// - Parameter forKey: key to find string for.
  /// - Returns: String object for key (if exists).
  public static func string(forKey: String) -> String? {
    return UserDefaults.standard.string(forKey: forKey)
  }

  // Integer from UserDefaults.
  ///
  /// - Parameter forKey: key to find integer for.
  /// - Returns: Int number for key (if exists).
  public static func integer(forKey: String) -> Int? {
    return UserDefaults.standard.integer(forKey: forKey)
  }

  // Double from UserDefaults.
  ///
  /// - Parameter forKey: key to find double for.
  /// - Returns: Double number for key (if exists).
  public static func double(forKey: String) -> Double? {
    return UserDefaults.standard.double(forKey: forKey)
  }

  // Data from UserDefaults.
  ///
  /// - Parameter forKey: key to find data for.
  /// - Returns: Data object for key (if exists).
  public static func data(forKey: String) -> Data? {
    return UserDefaults.standard.data(forKey: forKey)
  }

  // Bool from UserDefaults.
  ///
  /// - Parameter forKey: key to find bool for.
  /// - Returns: Bool object for key (if exists).
  public static func bool(forKey: String) -> Bool? {
    return UserDefaults.standard.bool(forKey: forKey)
  }

  // Array from UserDefaults.
  ///
  /// - Parameter forKey: key to find array for.
  /// - Returns: Array of Any objects for key (if exists).
  public static func array(forKey: String) -> [Any]? {
    return UserDefaults.standard.array(forKey: forKey)
  }

  // Dictionary from UserDefaults.
  ///
  /// - Parameter forKey: key to find dictionary for.
  /// - Returns: ictionary of [String: Any] for key (if exists).
  public static func dictionary(forKey: String) -> [String: Any]? {
    return UserDefaults.standard.dictionary(forKey: forKey)
  }

  // Float from UserDefaults.
  ///
  /// - Parameter forKey: key to find float for.
  /// - Returns: Float number for key (if exists).
  public static func float(forKey: String) -> Float? {
    return UserDefaults.standard.object(forKey: forKey) as? Float
  }

  // Save an object to UserDefaults.
  ///
  /// - Parameters:
  ///   - value: object to save in UserDefaults.
  ///   - forKey: key to save object for.
  public static func set(value: Any?, forKey: String) {
    UserDefaults.standard.set(value, forKey: forKey)
    UserDefaults.standard.synchronize()
  }

  public static func makeDoneToolbar(target: Any, action: Selector) -> UIToolbar {
    let keyboardToolbar = UIToolbar()
    keyboardToolbar.sizeToFit()
    let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: target, action: action)
    keyboardToolbar.items = [flexBarButton, doneBarButton]

    return keyboardToolbar
  }

  // Class name of object as string.
  ///
  /// - Parameter object: Any object to find its class name.
  /// - Returns: Class name for given object.
  public static func typeName(for object: Any) -> String {
    let type = type(of: object.self)
    return String.init(describing: type)
  }

  public static func reviewPathWithId(_ appId: String) -> String {
    return "https://itunes.apple.com/app/viewContentsUserReviews?id=" + appId
  }

  public static func reviewURLWithId(_ appId: String) -> URL {
    return URL(string: reviewPathWithId(appId))!
  }

  public static func sharePathWithId(_ appId: String) -> String {
    return "https://itunes.apple.com/app/id" + appId
  }

  public static func shareURLWithId(_ appId: String) -> URL {
    return URL(string: sharePathWithId(appId))!
  }

  public static func clearTempDirectory() {
    do {
      try tempContents.forEach {
        try FileManager.default.removeItem(atPath: $0)
      }
    } catch {}
  }

  public static var tempContents: [String] {
    let paths = (try? FileManager.default.contentsOfDirectory(atPath: NSTemporaryDirectory())) ?? []
    return paths.map {
      (NSTemporaryDirectory() as NSString).appendingPathComponent($0)
    }
  }

  public static func isDirectoryFor(_ path: String) -> Bool {
    var isDirectory: ObjCBool = false
    FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
    return isDirectory.boolValue
  }

  public static var libraryPath: String {
    return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!
  }

  public static func libraryPathForFile(_ named: String) -> String {
    return (libraryPath as NSString).appendingPathComponent(named)
  }

  public static var cachePath: String {
    return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
  }

  public static func cachePathForFile(_ named: String) -> String {
    return (cachePath as NSString).appendingPathComponent(named)
  }

  public static var tempPath: String {
    return NSTemporaryDirectory()
  }

  public static func createFolder(_ path: String) -> String {
    let fileManager = FileManager.default
    if !fileManager.fileExists(atPath: path) {
      try? fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
    }
    return path
  }

  @discardableResult
  public static func deleteFileWithPath(_ path: String) -> Bool {
    let exists = FileManager.default.fileExists(atPath: path)
    if exists {
      do {
        try FileManager.default.removeItem(atPath: path)
      } catch {
        print("error: \(error.localizedDescription)")
        return false
      }
    }
    return exists
  }

  public static var documentPath: String {
    return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
  }

  public static func documentPathForFile(_ named: String) -> String {
    return (documentPath as NSString).appendingPathComponent(named)
  }

  public static func appGroupDocumentPath(_ appGroupId: String) -> String? {
    let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupId)
    let path = url?.absoluteString.replacingOccurrences(of: "file:", with: "", options: .literal, range: nil)
    return path
  }

  public static func bundlePathForFile(_ named: String) -> String {
    return (Bundle.main.bundlePath as NSString).appendingPathComponent(named)
  }

  /// Delete file in Documents Path
  ///
  /// - parameter named: name of the file
  ///
  /// - returns: success or failed
  @discardableResult
  public static func deleteFileWithName(_ named: String) -> Bool {
    let path = documentPath + named
    return deleteFileWithPath(path)
  }
}

/**
 Gets the Obj-C reference for the instance object within the UIView extension.
 - Parameter base: Base object.
 - Parameter key: Memory key pointer.
 - Parameter initializer: Object initializer.
 - Returns: The associated reference for the initializer object.
 */
public func AssociatedObject<T: Any>(base: Any, key: UnsafePointer<UInt8>, initializer: () -> T) -> T {
  if let v = objc_getAssociatedObject(base, key) as? T {
    return v
  }

  let v = initializer()
  objc_setAssociatedObject(base, key, v, .OBJC_ASSOCIATION_RETAIN)
  return v
}

/**
 Sets the Obj-C reference for the instance object within the UIView extension.
 - Parameter base: Base object.
 - Parameter key: Memory key pointer.
 - Parameter value: The object instance to set for the associated object.
 - Returns: The associated reference for the initializer object.
 */
public func AssociateObject<T: Any>(base: Any, key: UnsafePointer<UInt8>, value: T) {
  objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN)
}

/// @creator: Slipp Douglas Thompson
/// @license: Public Domain per The Unlicense.  See accompanying LICENSE file or <http://unlicense.org/>.
/// @purpose: A concise operator syntax for assigning to a non-`Optional` from an `Optional`.
/// @why:
/// 	Sometimes in Swift you want to assign only if the RHS is non-`nil`.
/// 	Say you have `someArg:Int?` and `_someIvar:Int`.  You could use a single-line `if`:
/// 	    `if someArg != nil { _someIvar = someArg! }`
/// 	Or you could use a ternary or nil-coalesce:
/// 	    `_someIvar = someArg != nil ? someArg! : _someIvar`
/// 	    `_someIvar = someArg ?? _someIvar`
/// 	But each of those are a bit messy for a simple maybe-assignment.
/// @usage:
/// 	1. Add `NilCoalescingAssignmentOperators.swift` to your project.
/// 	2. Use like this: `_someIvar ??= someArg` (given `_someIvar:Int`/`someArg:Int?`, or given `_someIvar:Int?`/`someArg:Int`).
/// @interwebsouce: https://gist.github.com/capnslipp/9d27a8af34b6ad3402c1d5e5f2a47d0f

// MARK: =?? Operator
infix operator =??: AssignmentPrecedence

/// Assigns only when `rhs` is non-`nil`..
/// - Remark: effectively `lhs = rhs ?? lhs` _(skipping same-value assignments)_
public func =??<Wrapped>(lhs: inout Wrapped, rhsClosure: (@autoclosure () throws -> Wrapped?)) rethrows {
  let rhs: Wrapped? = try rhsClosure()
  if rhs != nil {
    lhs = rhs!
  }
}
/// Assigns only when `rhs` is non-`nil`.
/// - Remark: effectively `lhs = (rhs ?? lhs) ?? nil` _(skipping same-value assignments)_
public func =??<Wrapped>(lhs: inout Wrapped?, rhsClosure: (@autoclosure () throws -> Wrapped?)) rethrows {
  let rhs: Wrapped? = try rhsClosure()
  if rhs != nil {
    lhs = rhs
  }
}
/// Assigns only when `rhs` is non-`nil`.
/// - Remark: effectively `lhs = (rhs ?? lhs) ?? nil` _(skipping same-value assignments)_
public func =??<Wrapped>(lhs: inout Wrapped!, rhsClosure: (@autoclosure () throws -> Wrapped?)) rethrows {
  let rhs: Wrapped? = try rhsClosure()
  if rhs != nil {
    lhs = rhs
  }
}

// MARK: ??= Operator
infix operator ??=: AssignmentPrecedence

// FIXME: The following two variants are commented-out because Swift (3.0.2)'s type inference will apparently auto-promote a `Wrapped` type returned from a closure to `Wrapped?`, then get confused that we have specializations for both `Wrapped` & `Wrapped?`.
// 	Without commenting these out, we're stuck with explicitly typing any closures used as the RHS.
// 	With these commented out (using the specializations with always-`Wrapped?` RHSes), we just have to deal with the additional inefficiency of promoting the RHS's `Wrapped` to `Wrapped?` then doing a superfluous `rhs != nil` check.
///// Assigns only when `lhs` is `nil`.
///// - Remark: effectively `lhs = lhs ?? rhs` _(skipping same-value assignments)_
// public func ??=<Wrapped>(lhs:inout Wrapped?, rhsClosure:(@autoclosure ()throws->Wrapped)) rethrows {
//	if lhs == nil {
//		let rhs:Wrapped = try rhsClosure()
//		lhs = rhs
//	}
// }
///// Assigns only when `lhs` is `nil`.
///// - Remark: effectively `lhs = lhs ?? rhs` _(skipping same-value assignments)_
// public func ??=<Wrapped>(lhs:inout Wrapped!, rhsClosure:(@autoclosure ()throws->Wrapped)) rethrows {
//	if lhs == nil {
//		let rhs:Wrapped = try rhsClosure()
//		lhs = rhs
//	}
// }
/// Assigns only when `lhs` is `nil` (and `rhs` is non-`nil`).
/// - Remark: effectively `lhs = (lhs ?? rhs) ?? nil` _(skipping same-value assignments)_
public func ??=<Wrapped>(lhs: inout Wrapped?, rhsClosure: (@autoclosure () throws -> Wrapped?)) rethrows {
  if lhs == nil {
    let rhs: Wrapped? = try rhsClosure()
    if rhs != nil {
      lhs = rhs
    }
  }
}
/// Assigns only when `lhs` is `nil` (and `rhs` is non-`nil`).
/// - Remark: effectively `lhs = (lhs ?? rhs) ?? nil` _(skipping same-value assignments)_
public func ??=<Wrapped>(lhs: inout Wrapped!, rhsClosure: (@autoclosure () throws -> Wrapped?)) rethrows {
  if lhs == nil {
    let rhs: Wrapped? = try rhsClosure()
    if rhs != nil {
      lhs = rhs
    }
  }
}
