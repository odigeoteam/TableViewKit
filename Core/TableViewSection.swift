//
//  TableViewSection.swift
//  TableViewKit
//
//  Created by Nelson Dominguez Leon on 07/06/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import Foundation
import UIKit

public protocol TableViewSectionProtocol: class {
    
    weak var tableViewManager: TableViewManager! { get set }
    
    var items: [TableViewItemProtocol] { get set }
    
    var headerTitle: String? { get set }
    var footerTitle: String? { get set }
    var headerHeight: CGFloat? { get set }
    var footerHeight: CGFloat? { get set }
    var headerView: UIView? { get set }
    var footerView: UIView? { get set }
    
    var index: Int? { get }
    
    func addItem(item: TableViewItemProtocol)
    func addItems(items: [TableViewItemProtocol])
    func removeItem(item: TableViewItemProtocol)
    func removeItems(array: [TableViewItemProtocol])
}

func ==(lhs: TableViewSectionProtocol, rhs: TableViewSectionProtocol) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}

func !=(lhs: TableViewSectionProtocol, rhs: TableViewSectionProtocol) -> Bool {
    return ObjectIdentifier(lhs) != ObjectIdentifier(rhs)
}

public class TableViewSection: TableViewSectionProtocol {
    
    // MARK: Public properties
    
    /**
     An array of section items (rows).
     */
    public var items: [TableViewItemProtocol]
    
    /**
     The title of the header of the specified section of the table view.
     */
    public var headerTitle: String?
    
    /**
     The title of the footer of the specified section of the table view.
     */
    public var footerTitle: String?
    
    /**
     The height of the header of the specified section of the table view.
     */
    public var headerHeight: CGFloat?
    
    /**
     The height of the footer of the specified section of the table view.
     */
    public var footerHeight: CGFloat?
    
    /**
     A view object to display in the header of the specified section of the table view.
     */
    public var headerView: UIView?
    
    /**
     A view object to display in the footer of the specified section of the table view.
     */
    public var footerView: UIView?
    
    /**
     Section index in UITableView.
     */
    public var index: Int? {
        return nil
        //return tableViewManager.sections.indexOf(self)
    }
    
    /**
     The table view manager of this section.
     */
    weak public var tableViewManager: TableViewManager!
    
    // MARK: Init methods
    
    public required init() {
        items = []
    }
    
    public convenience init(headerTitle: String) {
        
        self.init()
        self.headerTitle = headerTitle
    }
    
    public convenience init(headerTitle: String, footerTitle: String) {
        
        self.init(headerTitle: headerTitle)
        self.footerTitle = footerTitle
    }
    
    // MARK: Add methods
    
    public func addItem(item: TableViewItemProtocol) {
        
        item.section = self
        items.append(item)
        
        tableViewManager.register(cell: item.drawer.cell)

    }
    
    public func addItems(items: [TableViewItemProtocol]) {
        
        for item in items {
            addItem(item)
        }
    }
    
    // MARK: Remove methods
    
    public func removeItem(item: TableViewItemProtocol) {
        
        if let index = items.indexOf({ $0 == item }) {
            items.removeAtIndex(index)
        }
    }
    
    public func removeItems(array: [TableViewItemProtocol]) {
        
        for element in array {
            removeItem(element)
        }
    }
    
    func removeLastItem() {
        
        items.removeLast()
    }
    
    func removeFirstItem() {
        
        items.removeFirst()
    }
    
    func reloadWithAnimation(animation: UITableViewRowAnimation) {
        
        if let sectionIndex = index {
            tableViewManager.tableView.reloadSections(NSIndexSet(index: sectionIndex), withRowAnimation: animation)
        }
    }
}

