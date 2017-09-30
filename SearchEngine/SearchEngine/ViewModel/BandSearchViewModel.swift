//
//  BandSearchViewModel.swift
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

class BandSearchViewModel: NSObject, BandSearchServiceAccess {

    var userSeachDoneSignal: Signal<Void> = Signal<Void>()

    fileprivate var model: BandSearchModel = BandSearchModel()
    fileprivate var timer = Timer()

    var results: Array<JSON> {
        return self.model.results
    }

    override func awakeFromNib() {
        self.model.loadResultsFromDisk()
    }

    func actionSearch(searchText: String) {
        timer.invalidate()

        if (searchText.characters.count > 0) {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
                //Put the code that be called by the timer here.

                self.searchProvider.request(SearchService.band(type: SearchType.band, word: searchText)) { [weak self](result) in
                    guard let `self` = self else {
                        return
                    }

                    switch result {
                    case let .success(moyaResponse):

                        let json = moyaResponse.asJSON()

                        self.model.persistResults(results: json["data"]["search_results"].arrayValue)
                        self.userSeachDoneSignal.fire()
                    case let .failure(error):
                        trace(error)
                        // TODO: handle the error == best. comment. ever.
                        trace()
                    }
                }
            }
        }
    }
}
