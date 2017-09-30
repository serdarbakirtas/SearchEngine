//
//  UICollectionView.swift
//  Pods
//
//  Ali Kiran on 11/24/16.
//
//

import Foundation
import UIKit

public extension UICollectionView {
    func registerCells(nibClasses: [AnyClass]) {
        for eachClass in nibClasses {
            let classString = String(describing: eachClass)
            let nib = UINib(nibName: classString, bundle: nil)
            register(nib, forCellWithReuseIdentifier: classString)
        }
    }
    
    func registerCells(classes: [AnyClass]) {
        for eachClass in classes {
            let classString = String(describing: eachClass)
            register(eachClass, forCellWithReuseIdentifier: classString)
        }
    }
    
    public func reload(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() }, completion: { _ in completion() })
    }

    /// SwifterSwift: Index path of last item in collectionView.
    public var indexPathForLastItem: IndexPath? {
        return indexPathForLastItem(inSection: self.lastSection)
    }

    /// SwifterSwift: IndexPath for last item in section.
    ///
    /// - Parameter section: section to get last item in.
    /// - Returns: optional last indexPath for last item in section (if applicable).
    public func indexPathForLastItem(inSection section: Int) -> IndexPath? {
        guard section >= 0 else {
            return nil
        }
        guard numberOfItems(inSection: section) > 0 else {
            return IndexPath(item: 0, section: section)
        }
        return IndexPath(item: self.numberOfItems(inSection: section) - 1, section: section)
    }

    // Index of last section in collectionView.
    public var lastSection: Int {
        return numberOfSections > 0 ? numberOfSections - 1 : 0
    }

    // Number of all items in all sections of collectionView.
    public var numberOfItems: Int {
        var section = 0
        var itemsCount = 0
        while section < self.numberOfSections {
            itemsCount += self.numberOfItems(inSection: section)
            section += 1
        }
        return itemsCount
    }

    /**
     Inserts rows into self.

     - parameter indices: The rows indices to insert into self.
     - parameter section: The section in which to insert the rows (optional, defaults to 0).
     - parameter completion: The completion handler, called after the rows have been inserted (optional).
     */
    public func insert(_ indices: [Int], section: Int = 0, completion: @escaping (Bool) -> Void = { _ in }) {
        guard !indices.isEmpty else { return }

        let indexPaths = indices.map { IndexPath(row: $0, section: section) }
        performBatchUpdates({ self.insertItems(at: indexPaths) }, completion: completion)
    }

    /**
     Deletes rows from self.

     - parameter indices: The rows indices to delete from self.
     - parameter section: The section in which to delete the rows (optional, defaults to 0).
     - parameter completion: The completion handler, called after the rows have been deleted (optional).
     */
    public func delete(_ indices: [Int], section: Int = 0, completion: @escaping (Bool) -> Void = { _ in }) {
        guard !indices.isEmpty else { return }

        let indexPaths = indices.map { IndexPath(row: $0, section: section) }
        performBatchUpdates({ self.deleteItems(at: indexPaths) }, completion: completion)
    }

    /**
     Reloads rows in self.

     - parameter indices: The rows indices to reload in self.
     - parameter section: The section in which to reload the rows (optional, defaults to 0).
     - parameter completion: The completion handler, called after the rows have been reloaded (optional).
     */
    public func reload(_ indices: [Int], section: Int = 0, completion: @escaping (Bool) -> Void = { _ in }) {
        guard !indices.isEmpty else { return }

        let indexPaths = indices.map { IndexPath(row: $0, section: section) }
        performBatchUpdates({ self.reloadItems(at: indexPaths) }, completion: completion)
    }

    public var centerPoint: CGPoint {
        let x = center.x + contentOffset.x
        let y = center.y + contentOffset.y
        return CGPoint(x: x, y: y)
    }

    public var centerItemIndexPath: IndexPath? {
        return indexPathForItem(at: self.centerPoint)
    }
}
