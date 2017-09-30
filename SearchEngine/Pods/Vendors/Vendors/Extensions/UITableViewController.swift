//
//  UITableViewController.swift
//  Pods
//
//  Created by ALI KIRAN on 8/13/17.
//
//

import UIKit

extension UITableViewController {
    func sizeHeaderToFit() {
        if let headerView = tableView.tableHeaderView {
            
            headerView.setNeedsLayout()
            headerView.layoutIfNeeded()
            
            let height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
            var frame = headerView.frame
            frame.size.height = height
            headerView.frame = frame
            
            tableView.tableHeaderView = headerView
        }
    }
    
    func sizeFooterToFit() {
        if let footerView = tableView.tableFooterView {
            footerView.setNeedsLayout()
            footerView.layoutIfNeeded()
            
            let height = footerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
            var frame = footerView.frame
            frame.size.height = height
            footerView.frame = frame
            
            tableView.tableFooterView = footerView
        }
    }
}
