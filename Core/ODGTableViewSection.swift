//
//  ODGTableViewSection.swift
//  TableViewKit
//
//  Created by Nelson Dominguez Leon on 07/06/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import Foundation
import UIKit

public protocol ODGTableViewSectionProtocol: class {
    
    weak var tableViewManager: ODGTableViewManager! { get set }
    
    var items: [ODGTableViewItemProtocol] { get set }
    
    var headerTitle: String? { get set }
    var footerTitle: String? { get set }
    var headerHeight: CGFloat? { get set }
    var footerHeight: CGFloat? { get set }
    var headerView: UIView? { get set }
    var footerView: UIView? { get set }
    
    var index: Int? { get }
    
    func errors() -> [NSError]
    
    func addItem(item: ODGTableViewItemProtocol)
    func addItems(items: [ODGTableViewItemProtocol])
    func removeItem(item: ODGTableViewItemProtocol)
    func removeItems(array: [ODGTableViewItemProtocol])
}

func ==(lhs: ODGTableViewSectionProtocol, rhs: ODGTableViewSectionProtocol) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}

func !=(lhs: ODGTableViewSectionProtocol, rhs: ODGTableViewSectionProtocol) -> Bool {
    return ObjectIdentifier(lhs) != ObjectIdentifier(rhs)
}

public class ODGTableViewSection: ODGTableViewSectionProtocol {
    
    // MARK: Public properties
    
    /**
     An array of section items (rows).
     */
    public var items: [ODGTableViewItemProtocol]
    
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
    
    public func errors() -> [NSError] {
        
        var errors: [NSError] = []
        
        for item in items {
            for error in item.errors() {
                errors.append(error)
            }
        }
        
        return errors
    }
    
    /**
     The table view manager of this section.
     */
    weak public var tableViewManager: ODGTableViewManager!
    
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
    
    public func addItem(item: ODGTableViewItemProtocol) {
        
        item.section = self
        items.append(item)
    }
    
    public func addItems(items: [ODGTableViewItemProtocol]) {
        
        for item in items {
            addItem(item)
        }
    }
    
    // MARK: Remove methods
    
    public func removeItem(item: ODGTableViewItemProtocol) {
        
        if let index = items.indexOf({ $0 == item }) {
            items.removeAtIndex(index)
        }
    }
    
    public func removeItems(array: [ODGTableViewItemProtocol]) {
        
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

