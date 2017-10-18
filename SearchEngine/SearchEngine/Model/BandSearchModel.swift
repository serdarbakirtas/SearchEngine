//
//  BandSearchModel.swift
//  SearchEngine
//
//  Created by Hasan Bakirtas on 30/09/2017.
//  Copyright © 2017 Hasan Serdar Bakirtas. All rights reserved.
//

import UIKit
import SwiftyJSON
import Vendors

struct BandSearchModel {
    var results: [JSON] = []

    mutating func persistResults(results: [JSON]) {
        self.results = results

        Vendors.set(value: JSON(results).rawString(), forKey: "search-results")
    }

    mutating func loadResultsFromDisk() {
        let string: String = Vendors.string(forKey: "search-results") ?? "[]"
        self.results = JSON(parseJSON: string).arrayValue
    }
}
