//
//  UITableView.swift
//  Pods
//
//  Ali Kiran on 11/24/16.
//
//

#if os(iOS) || os(tvOS)
    import UIKit

    public extension UITableView {
        func registerCells(nibClasses: [AnyClass]) {
            for eachClass in nibClasses {
                let classString = String(describing: eachClass)
                let nib = UINib(nibName: classString, bundle: nil)
                register(nib, forCellReuseIdentifier: classString)
            }
        }
        
        func registerCells(classes: [AnyClass]) {
            for eachClass in classes {
                let classString = String(describing: eachClass)
                register(eachClass, forCellReuseIdentifier: classString)
            }
        }
        
        private(set) public var originalDelegate: UITableViewDelegate? {
            set {
                self.setTempObject(newValue, key: "originalDelegate")
            }

            get {
                return self.tempObject(key: "originalDelegate") as? UITableViewDelegate
            }
        }

        private(set) public var originalDataSource: UITableViewDataSource? {
            set {
                self.setTempObject(newValue, key: "originalDataSource")
            }

            get {
                return self.tempObject(key: "originalDataSource") as? UITableViewDataSource
            }
        }

        public var emptyStateDelegate: EmptyStateDelegate? {
            set {

                guard let ed = newValue else {
                    self.delegate = self.originalDelegate
                    self.dataSource = self.originalDataSource

                    self.removeTempObject(key: "emptyStateDelegate")
                    self.originalDataSource = nil
                    self.originalDelegate = nil
                    return
                }

                assert(self.delegate != nil, "You should set tableview delegate first")
                assert(self.dataSource != nil, "You should set tableview datasource first")

                self.originalDataSource = self.dataSource
                self.originalDelegate = self.delegate
                self.setTempObject(ed, key: "emptyStateDelegate")
            }

            get {
                return self.tempObject(key: "emptyStateDelegate") as? EmptyStateDelegate
            }
        }

        /**
         Inserts rows into self.

         - parameter indices: The rows indices to insert into self.
         - parameter section: The section in which to insert the rows (optional, defaults to 0).
         - parameter animation: The animation to use for the row insertion (optional, defaults to `.Automatic`).
         */
        public func insert(_ indices: [Int], section: Int = 0, animation: UITableViewRowAnimation = .automatic) {
            guard !indices.isEmpty else { return }

            let indexPaths = indices.map { IndexPath(row: $0, section: section) }

            beginUpdates()
            insertRows(at: indexPaths, with: animation)
            endUpdates()
        }

        /**
         Deletes rows from self.

         - parameter indices: The rows indices to delete from self.
         - parameter section: The section in which to delete the rows (optional, defaults to 0).
         - parameter animation: The animation to use for the row deletion (optional, defaults to `.Automatic`).
         */
        public func delete(_ indices: [Int], section: Int = 0, animation: UITableViewRowAnimation = .automatic) {
            guard !indices.isEmpty else { return }

            let indexPaths = indices.map { IndexPath(row: $0, section: section) }

            beginUpdates()
            deleteRows(at: indexPaths, with: animation)
            endUpdates()
        }

        /**
         Reloads rows in self.

         - parameter indices: The rows indices to reload in self.
         - parameter section: The section in which to reload the rows (optional, defaults to 0).
         - parameter animation: The animation to use for reloading the rows (optional, defaults to `.Automatic`).
         */
        public func reload(_ indices: [Int], section: Int = 0, animation: UITableViewRowAnimation = .automatic) {
            guard !indices.isEmpty else { return }

            let indexPaths = indices.map { IndexPath(row: $0, section: section) }

            beginUpdates()
            reloadRows(at: indexPaths, with: animation)
            endUpdates()
        }

        public func reload(_ completion: @escaping () -> Void) {
            guard !self.checkEmptyState(completion: completion) else {
                return
            }

            UIView.animate(withDuration: 0, animations: { self.reloadData() }, completion: { _ in completion() })
        }

        func checkEmptyState(completion _: @escaping () -> Void) -> Bool {
            guard let stateDelegate = self.emptyStateDelegate, let dataSource: UITableViewDataSource = self.originalDataSource else {
                return false
            }

            let sectionCount = dataSource.numberOfSections?(in: self) ?? 1
            var rowCount = 0

            if stateDelegate.responds(to: #selector(EmptyStateDelegate.numberOfItems(in:))) {
                rowCount = stateDelegate.numberOfItems?(in: self) ?? 0
            } else {
                for sec in 0 ..< sectionCount {
                    rowCount = rowCount + dataSource.tableView(self, numberOfRowsInSection: sec)
                }
            }

            guard rowCount <= 0 else {
                self.dataSource = self.originalDataSource
                self.delegate = self.originalDelegate

                return false
            }

            let controller = EmptyStateDataController()
            self.dataSource = controller
            self.delegate = controller
            self.setTempObject(controller, key: "emptyStateDataController")

            self.reloadData()
            return true
        }

        /// SwifterSwift: Index path of last row in tableView.
        public var indexPathForLastRow: IndexPath? {
            return indexPathForLastRow(inSection: lastSection)
        }

        /// SwifterSwift: IndexPath for last row in section.
        ///
        /// - Parameter section: section to get last row in.
        /// - Returns: optional last indexPath for last row in section (if applicable).
        public func indexPathForLastRow(inSection section: Int) -> IndexPath? {
            guard section >= 0 else {
                return nil
            }
            guard numberOfRows(inSection: section) > 0 else {
                return IndexPath(row: 0, section: section)
            }
            return IndexPath(row: numberOfRows(inSection: section) - 1, section: section)
        }

        // Index of last section in tableView.
        public var lastSection: Int {
            return numberOfSections > 0 ? numberOfSections - 1 : 0
        }

        // Number of all rows in all sections of tableView.
        public var numberOfRows: Int {
            var section = 0
            var rowCount = 0
            while section < numberOfSections {
                rowCount += numberOfRows(inSection: section)
                section += 1
            }
            return rowCount
        }

        // Remove TableFooterView.
        public func removeTableFooterView() {
            tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        }

        // Remove TableHeaderView.
        public func removeTableHeaderView() {
            tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        }

//        // Scroll to bottom of TableView.
//        ///
//        /// - Parameter animated: set true to animate scroll (default is true).
//        public func goToBottom(animated: Bool = true) {
//            let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height)
//            setContentOffset(bottomOffset, animated: animated)
//        }
//
//        // Scroll to top of TableView.
//        ///
//        /// - Parameter animated: set true to animate scroll (default is true).
//        public func goToTop(animated: Bool = true) {
//            setContentOffset(CGPoint.zero, animated: animated)
//        }
//
        public var centerPoint: CGPoint {
            let x = center.x + contentOffset.x
            let y = center.y + contentOffset.y
            return CGPoint(x: x, y: y)
        }

        public var centerCellIndexPath: IndexPath? {
            return indexPathForRow(at: centerPoint)
        }

        public func addRefreshControl(performing block: @escaping () -> Void) -> UIRefreshControl {
            let refreshControl = UIRefreshControl()

            refreshControl.bind(.valueChanged) { block() }

            self.addSubview(refreshControl)

            return refreshControl
        }
    }
#endif

class EmptyStateDataController: NSObject, UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyStateCell", for: indexPath)
        return cell
    }

    public func tableView(_: UITableView, estimatedHeightForRowAt _: IndexPath) -> CGFloat {
        return 250
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

@objc public protocol EmptyStateDelegate: NSObjectProtocol {
    @objc optional func numberOfItems(in tableView: UITableView) -> Int

}
