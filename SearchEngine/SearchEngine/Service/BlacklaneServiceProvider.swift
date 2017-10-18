//
//  BlacklaneServiceProvider.swift
//  SearchEngine
//
//  Created by Hasan Bakirtas on 30/09/2017.
//  Copyright © 2017 Hasan Serdar Bakirtas. All rights reserved.
//

import Foundation
import Moya
import Vendors
import CVKHierarchySearcher
import Result

fileprivate var _searchprovider: MoyaProvider<SearchService>!

fileprivate var _albumprovider: MoyaProvider<AlbumService>!

fileprivate var _bandprovider: MoyaProvider<BandService>!

fileprivate let authHandler: () -> [String: String] = {

    guard let basicAuthCredentials = String(format: "").base64Encoded else {
        return [:]
    }

    return ["Authorization": "Basic \(basicAuthCredentials)"]
}

//MARK: BAND SEARCH SERVICE
protocol BandSearchServiceAccess {

}

extension BandSearchServiceAccess {
    var searchProvider: MoyaProvider<SearchService> {
        return _searchprovider
    }
}

//MARK: ALBUM SERVICE
protocol AlbumServiceAccess {

}

extension AlbumServiceAccess {
    var albumProvider: MoyaProvider<AlbumService> {
        return _albumprovider
    }
}

//MARK: BAND SERVICE
protocol BandServiceAccess {

}

extension BandServiceAccess {
    var bandProvider: MoyaProvider<BandService> {
        return _bandprovider
    }
}


class BlacklaneServiceProvider {
    static func launch() {
        _searchprovider = newProvider(headers: authHandler, plugins: [jsonLogger, HudActivityPlugin()])
        _albumprovider = newProvider(headers: authHandler, plugins: [jsonLogger, HudActivityPlugin()])
        _bandprovider = newProvider(headers: authHandler, plugins: [jsonLogger, HudActivityPlugin()])
    }
}


//MARK: HUD
var hud: AMHudView?
var hudShowCount = 0

public final class HudActivityPlugin: PluginType {
    public init() {

    }

    /// Called by the provider as soon as the request is about to start
    public func willSend(_: RequestType, target _: TargetType) {
        if hud == nil {
            let hierarchy = CVKHierarchySearcher()

            guard hierarchy.topmostViewController != nil else {
                return
            }

            hud = AMHudView.hud(withLabel: "", inView: hierarchy.topmostViewController.view)
            hud?.cancelBlock = { _ in
                hud?.dismiss()
                hud = nil

            }
        }

        hudShowCount = hudShowCount + 1
    }

    /// Called by the provider as soon as a response arrives, even if the request is cancelled.
    public func didReceive(_: Result<Moya.Response, MoyaError>, target _: TargetType) {
        hudShowCount = max(hudShowCount - 1, 0)
        if hudShowCount == 0 {
            hud?.dismiss()
            hud = nil
        }
    }
}
