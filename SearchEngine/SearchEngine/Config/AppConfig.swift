//
//  AppConfig.swift
//  BlacklaneChallenge
//
//  Created by Hasan Bakirtas on 28/09/2017.
//  Copyright © 2017 Hasan Serdar Bakirtas. All rights reserved.
//

import Foundation
import Vendors
import Signals

struct AppConfig {
    static let updatedSignal: Signal<Void> = Signal<Void>()
    static var backend: String = ""
    static var appName: String = ""

    static var launchOptions: [AnyHashable: Any] = [:]
    static func launch(with options: [AnyHashable: Any], callback: () -> ()) {
        launchOptions = options
        loadFromPlist()

        moyaSharedDomain.baseURL = URL(string: AppConfig.backend)!

        launchServices()
        updatedSignal.fire()

        callback()
    }

    static func launchServices() {
        BlacklaneServiceProvider.launch()
    }

    static func loadFromPlist() {
        var resourceName: String = ""

        #if DEBUG
            resourceName = "APP_DEBUG_CONFIG"
        #else
            resourceName = "APP_RELEASE_CONFIG"
        #endif

        let path = Bundle.main.path(forResource: resourceName, ofType: "plist")!
        let data: Dictionary<String, Any> = NSDictionary(contentsOfFile: path) as! Dictionary<String, Any>
        backend = data["backend"] as! String
        appName = data["appName"] as! String
    }
}
