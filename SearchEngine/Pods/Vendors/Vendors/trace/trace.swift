//
// Created by ALI KIRAN on 2/7/16.
// Copyright (c) 2016 ALI KIRAN. All rights reserved.
//

import Foundation
import Darwin

public func platform() -> String {
    var size: Int = 0 // as Ben Stahl noticed in his answer
    sysctlbyname("hw.machine", nil, &size, nil, 0)
    var machine = [CChar](repeating: 0, count: Int(size))
    sysctlbyname("hw.machine", &machine, &size, nil, 0)
    return String(cString: machine)
}

public struct Boot {
    public static var time = mach_absolute_time()
}

#if DEBUG
    let ESCAPE = "\u{001b}["
    let RESET_FG = ESCAPE + "fg;" // Clear any foreground color
    let RESET_BG = ESCAPE + "bg;" // Clear any background color
    let RESET = ESCAPE + ";" // Clear any foreground or background color

    func red<T>(object: T) -> String {
        return "\(ESCAPE)fg240,19,52;\(object)\(RESET)"
    }

    func green<T>(object: T) -> String {
        return "\(ESCAPE)fg0,174,124;\(object)\(RESET)"
    }

    func blue<T>(object: T) -> String {
        return "\(ESCAPE)fg27,183,195;\(object)\(RESET)"
    }

    func yellow<T>(object: T) -> String {
        return "\(ESCAPE)fg255,252,25;\(object)\(RESET)"
    }

    func purple<T>(object: T) -> String {
        return "\(ESCAPE)fg33,91,126;\(object)\(RESET)"
    }

    func gray<T>(object: T) -> String {
        return "\(ESCAPE)fg0,255,255;\(object)\(RESET)"
    }

#else
    let ESCAPE = "\u{001b}"
    let RESET_FG = ESCAPE + "fg;" // Clear any foreground color
    let RESET_BG = ESCAPE + "bg;" // Clear any background color
    let RESET = ESCAPE + "" // Clear any foreground or background color

    func red<T>(_ object: T) -> String {
        return "\(ESCAPE)[31m\(object)"
    }

    func green<T>(_ object: T) -> String {
        return "\(ESCAPE)[32m\(object)"
    }

    func blue<T>(_ object: T) -> String {
        return "\(ESCAPE)[34m\(object)"
    }

    func yellow<T>(_ object: T) -> String {
        return "\(ESCAPE)[43m\(object)"
    }

    func purple<T>(_ object: T) -> String {
        return "\(ESCAPE)[96m\(object)"
    }

    func gray<T>(_ object: T) -> String {
        return "\(ESCAPE)[37m\(object)"
    }

#endif

@inline(__always) public func log<Template>(_ object: @autoclosure () -> Template) {
//    guard let obj = object() as? NSObject else {
//        print("\(object()) ")
//        return
//    }
//
//    NSLog("%@", obj)
    
     print("\(object()) ")
}
public func padTo<T>(_ str: T, length: Int = 10, blank: String = " ") -> String {
    let out = NSString(string: "\(str)")
    return out.padding(toLength: max(length, out.length), withPad: blank, startingAt: 0)
}

@inline(__always) public func trace(_ file: String = #file, _ functionName: String = #function, _ lineNum: Int = #line) {
    trace("", file, functionName, lineNum)
}

@inline(__always) public func trace<Template>(_ object: @autoclosure () -> Template, _ file: String = #file, _ functionName: String = #function, _ lineNum: Int = #line) {

    let threadSign = Thread.current.isMainThread ? "*" : ""

    if let url = URL(string: file) {
        let path = url.lastPathComponent
        let first = Boot.time
        let now = mach_absolute_time()
        let elapsed = now - first

        var info: mach_timebase_info = mach_timebase_info(numer: 0, denom: 0)
        let status = mach_timebase_info(&info)

        var total: UInt64 = 0
        if status == KERN_SUCCESS {
            total = (elapsed * UInt64(info.numer) / UInt64(info.denom)) / 1000000
        }

        let totalStr = "[\(total) ms]"
        let threadSignStr = "\(threadSign)\(Unmanaged.passUnretained(Thread.current).toOpaque())"
        let clickableLine = " \(path):\(lineNum)"

        #if COLORED_LOG
            print("\(red(padTo(totalStr))) \(gray(padTo(threadSignStr, length: 20))) \(padTo(clickableLine, length: 40)) ►\(red(padTo(functionName)))\n→\t\(green(object()))\n\n", terminator: "")
        #endif

        guard let obj = object() as? NSObject else {
            print("\(padTo(totalStr)) \(padTo(threadSignStr)) \(clickableLine) \(padTo(functionName)) \(object()) ")
            return
        }
        //        NSString(format: "%@", obj)

        NSLog("%@ %@ %@ ►%@ \n→\t %@", padTo(totalStr), padTo(threadSignStr), clickableLine, padTo(functionName), obj)
    } else {
        print("\(threadSign)\(functionName) \(object())\n", terminator: "")
    }
}

@objc public class Console: NSObject {
    override init() {
    }

    @inline(__always) public class func log() {
        trace()
    }
}
