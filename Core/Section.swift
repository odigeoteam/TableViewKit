//
//  TableViewSection.swift
//  TableViewKit
//
//  Created by Nelson Dominguez Leon on 07/06/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import Foundation
import UIKit
import ReactiveKit

public class Section {
    
    // MARK: Public properties
    
    public var items: CollectionProperty<[BaseItem]> = CollectionProperty([])
    
    public var index: Int? { return tableViewManager?.sections.indexOf(self) }
    
    weak public private(set) var  tableViewManager: TableViewManager!
    
    public var headerTitle: String?
    public var footerTitle: String?
    public var headerHeight: CGFloat?
    public var footerHeight: CGFloat?
    public var headerView: UIView?
    public var footerView: UIView?
    
    // MARK: Init methods
    
    public required init() {
        items.observeNext { e in
            e.inserts.forEach { index in
                e.collection[index].section = self
            }
        }
    }
    
    public func register(tableViewManager manager: TableViewManager) {
        tableViewManager = manager
        items.forEach {
           manager.register(type: $0.drawer.cellType)
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
        self.items.insertContentsOf(items, at: 0)
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
