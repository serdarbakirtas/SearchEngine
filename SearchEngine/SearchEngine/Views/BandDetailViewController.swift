//
//  BandDetailViewController.swift
//  SearchEngine
//
//  Created by Hasan Bakirtas on 30/09/2017.
//  Copyright © 2017 Hasan Serdar Bakirtas. All rights reserved.
//

import UIKit
import Vendors
import SwiftyJSON
import SDWebImage

class BandDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var bandData: JSON = [:]

    @IBOutlet var bandDetailViewModel: BandDetailViewModel!

    @IBOutlet weak fileprivate var viewHeader: UIView!
    @IBOutlet weak fileprivate var imgBandsPhoto: UIImageView!
    @IBOutlet weak fileprivate var lblGenre: UILabel!
    @IBOutlet weak fileprivate var lblYearsOfActivity: UILabel!
    @IBOutlet weak fileprivate var lblCountry: UILabel!
    @IBOutlet weak fileprivate var lblError: UILabel!

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewHeader.isHidden = true
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self

        self.title = bandData["album"]["title"].rawString()
    }

    override func viewWillAppear(_ animated: Bool) {
        bandDetailViewModel.getAlbumDoneSignal.subscribe(on: self) { () in
            self.bandDetailViewModel.getBandDoneSignal.subscribe(on: self) { () in

                if self.bandDetailViewModel.bandResults["details"]!.count <= 0 {
                    self.lblError.text = "invalid band id"
                    return
                }
                self.initializeViewHeader(self.bandDetailViewModel.bandResults)

                self.lblError.isHidden = true
                self.viewHeader.isHidden = false
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }

            self.bandDetailViewModel.getBandByID(bandID: self.bandDetailViewModel.albumResults.intValue)
        }

        self.bandDetailViewModel.getAlbums(albumID: bandData["album"]["id"].intValue)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.bandDetailViewModel.bandResults.isEmpty {
            return 0
        }
        return self.bandDetailViewModel.bandResults["discography"]!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.bandDetailCell)!
        cell.data = self.bandDetailViewModel.bandResults["discography"]![indexPath.row]
        return cell
    }

    override func viewDidDisappear(_ animated: Bool) {
        bandDetailViewModel.getAlbumDoneSignal.cancelAllSubscriptions()
        bandDetailViewModel.getBandDoneSignal.cancelAllSubscriptions()
    }

    fileprivate func initializeViewHeader(_ results: [String: JSON]) {
        guard let bandsPhoto = results["photo"]?.rawString() else {
            return
        }
        imgBandsPhoto.sd_setImage(with: URL(string: bandsPhoto), placeholderImage: UIImage(named: "placeholder.png"))

        guard let details = results["details"] else {
            return
        }

        lblGenre.text = details["genre"].rawString()
        lblCountry.text = details["country of origin"].rawString()
        lblYearsOfActivity.text = details["years active"].rawString()
    }
}

class BandDetailCell: UITableViewCell {
    @IBOutlet weak var lblAlbumTitle: UILabel!
    @IBOutlet weak var lblAlbumType: UILabel!
    @IBOutlet weak var lblAlbumYear: UILabel!

    var data: JSON = [:] {
        didSet {
            self.lblAlbumTitle.text = String(format: "%@%@", "title: ", data["title"].rawString()!)
            self.lblAlbumType.text = String(format: "%@%@", "type: ", data["type"].rawString()!)
            self.lblAlbumYear.text = String(format: "%@%@", "year: ", data["year"].rawString()!)
        }
    }
}
