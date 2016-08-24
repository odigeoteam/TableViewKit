//
//  TableViewSection.swift
//  TableViewKit
//
//  Created by Nelson Dominguez Leon on 07/06/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import Foundation
import UIKit

public class Section {
    
    // MARK: Public properties
    
    public private(set) var items: [BaseItem]

    public var index: Int? { return tableViewManager?.sections.indexOf(self) }
    
    weak public var tableViewManager: TableViewManager!
    
    public var headerTitle: String?
    public var footerTitle: String?
    public var headerHeight: CGFloat?
    public var footerHeight: CGFloat?
    public var headerView: UIView?
    public var footerView: UIView?
    
    // MARK: Init methods
    
    public required init() {
        items = []
    }
    
    // MARK: Add methods
    
    public func append(item: BaseItem) {
        item.section = self
        items.append(item)
    }
    
    public func append(items: [BaseItem]) {
        items.forEach(append)
    }
    
    // MARK: Remove methods
    
    public func remove(item: BaseItem) {
        if let index = items.indexOf(item) {
            items.removeAtIndex(index)
        }
    }
    
    public func remove(array: [BaseItem]) {
        array.forEach(remove)
    }
    
    public func register(tableViewManager manager: TableViewManager) {
        tableViewManager = manager
        items.forEach {
            manager.tableView.register(type: $0.drawer.cellType)
        }
    }
}

extension Section: Equatable {}
public func ==(lhs: Section, rhs: Section) -> Bool{
    return lhs === rhs
}

extension Section {
    
    public func reload(rowAnimation: UITableViewRowAnimation = .None) {
        guard let tableView = tableViewManager?.tableView, index = index else { return }
        tableView.reloadSections(NSIndexSet(index: index), withRowAnimation: rowAnimation)
    }
}

extension Section {
    
    public convenience init(items: [BaseItem]) {
        self.init()
        self.append(items)
    }
    
    public convenience init(headerTitle: String) {
        self.init()
        self.headerTitle = headerTitle
    }
    
    public convenience init(headerTitle: String, footerTitle: String) {
        
        self.init(headerTitle: headerTitle)
        self.footerTitle = footerTitle
    }
}
