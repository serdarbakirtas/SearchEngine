//
//  BandSearchViewController.swift
//  BlacklaneChallenge
//
//  Created by Hasan Bakirtas on 30/09/2017.
//  Copyright © 2017 Hasan Serdar Bakirtas. All rights reserved.
//

import UIKit
import Vendors
import SwiftyJSON

class BandSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!

    @IBOutlet var bandSearchViewModel: BandSearchViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Band Name Search"

        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self

        addKeyboardHandle()
    }

    override func viewWillAppear(_ animated: Bool) {
        bandSearchViewModel.userSeachDoneSignal.subscribe(on: self) { () in
            self.tableView.reloadData()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        bandSearchViewModel.userSeachDoneSignal.cancelAllSubscriptions()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bandSearchViewModel.results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.bandSearchCell)!
        cell.data = self.bandSearchViewModel.results[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bandData = self.bandSearchViewModel.results[indexPath.row]

        let bandDetailViewController: BandDetailViewController? = R.storyboard.bandDetail.instantiateInitialViewController()
        bandDetailViewController?.bandData = bandData
        self.navigationController?.pushViewController(bandDetailViewController!, animated: true)
    }
}

class BandSearchCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!

    var data: JSON = [:] {
        didSet {
            guard let title = self.data["album"]["title"].rawString() else {
                return
            }
            self.lblTitle.text = title
        }
    }
}


// MARK: - SearchBar.
extension BandSearchViewController: UISearchBarDelegate, UISearchDisplayDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = searchBar.text {
            let search = text.trimmingCharacters(in: .whitespacesAndNewlines)
            self.bandSearchViewModel.actionSearch(searchText: search)
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
}


// MARK: - keyboard handling method.
extension BandSearchViewController {

    func addKeyboardHandle() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShowNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHideNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func removeKeyboardHandle() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func handleKeyboardWillShowNotification(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        tableViewBottomConstraint.constant = -keyboardScreenEndFrame.size.height
        commitLayoutAnimation()
    }

    func handleKeyboardWillHideNotification(notification: NSNotification) {
        tableViewBottomConstraint.constant = 0
        commitLayoutAnimation()
    }

    func commitLayoutAnimation() {
        view.setNeedsUpdateConstraints()
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
}
