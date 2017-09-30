//
//  IndexPath.swift
//  Pods
//
//  Created by away4m on 12/31/16.
//
//

import Foundation

public extension IndexPath {

    @discardableResult
    public func plusRowAndSection(_ row: Int, _ section: Int) -> IndexPath {
        return IndexPath(row: self.row + row, section: self.section + section)
    }

    @discardableResult
    public func plusRow(_ by: Int) -> IndexPath {
        return plusRowAndSection(by, 0)
    }

    @discardableResult
    public func plusSection(_ by: Int) -> IndexPath {
        return plusRowAndSection(0, by)
    }
}
