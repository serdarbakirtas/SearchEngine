//
//  BandDetailViewModel.swift
//  BlacklaneChallenge
//
//  Created by Hasan Bakirtas on 30/09/2017.
//  Copyright © 2017 Hasan Serdar Bakirtas. All rights reserved.
//

import Foundation
import UIKit
import Signals
import Vendors
import SwiftyJSON

class BandDetailViewModel: NSObject, AlbumServiceAccess, BandServiceAccess {
    fileprivate var model: BandDetailModel = BandDetailModel(albumResults: "", bandResults: [:])

    var getAlbumDoneSignal: Signal<Void> = Signal<Void>()
    var getBandDoneSignal: Signal<Void> = Signal<Void>()

    var albumResults: String {
        return self.model.albumResults
    }

    var bandResults: [String: JSON] {
        return self.model.bandResults
    }

    //MARK: JSONP Get album by ID
    func getAlbums(albumID: Int) {
        perform_after(1.0) {
            self.albumProvider.request(AlbumService.album(album_id: albumID)) { [weak self](result) in
                guard let `self` = self else {
                    return
                }

                switch result {
                case let .success(moyaResponse):
                    let json = moyaResponse.asJSON()

                    guard let bandID = json["data"]["band"]["id"].rawString() else {
                        return
                    }
                    self.model.albumPersistResults(albumResults: bandID)
                    self.getAlbumDoneSignal.fire()

                case let .failure(error):
                    trace(error)
                    // TODO: handle the error == best. comment. ever.
                    trace()
                }
            }
        }
    }

    //MARK: JSONP Get band by ID
    func getBandByID(bandID: Int) {

        perform_after(1.0) {
            self.bandProvider.request(BandService.band(band_id: bandID)) { [weak self](result) in
                guard let `self` = self else {
                    return
                }

                switch result {
                case let .success(moyaResponse):
                    let json = moyaResponse.asJSON()

                    self.model.bandPersistResults(bandResults: json["data"].dictionaryValue)
                    self.getBandDoneSignal.fire()

                case let .failure(error):
                    trace(error)
                    // TODO: handle the error == best. comment. ever.
                    trace()
                }
            }
        }
    }
}
