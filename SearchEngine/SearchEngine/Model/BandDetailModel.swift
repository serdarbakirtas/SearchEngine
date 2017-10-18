//
//  BandDetailModel.swift
//  SearchEngine
//
//  Created by Hasan Bakirtas on 30/09/2017.
//  Copyright © 2017 Hasan Serdar Bakirtas. All rights reserved.
//

import UIKit
import SwiftyJSON
import Vendors

struct BandDetailModel {

    var albumResults: String
    var bandResults: [String: JSON] = [:]

    mutating func albumPersistResults(albumResults: String) {
        self.albumResults = albumResults
    }

    mutating func bandPersistResults(bandResults: [String: JSON]) {
        self.bandResults = bandResults
    }
}
