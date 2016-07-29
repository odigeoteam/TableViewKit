//
//  TableViewManager.swift
//  TableViewKit
//
//  Created by Nelson Dominguez Leon on 07/06/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import Foundation
import UIKit

@objc
public protocol TableViewManagerDelegate: UITableViewDelegate {
    
}

public class TableViewManager: NSObject {
    
    // MARK: Properties
    
    /// Array of sections
    public var sections: [TableViewSectionProtocol] = []
    
    /// TableView to be managed
    public var tableView: UITableView!
    
    /// Delegate to notify when the events occurs
    public var delegate: TableViewManagerDelegate?
    
    public var validator: ValidatorManager<String?> = ValidatorManager()
    
    public var errors: [ValidationError] {
        get {
            return validator.errors
        }
    }

    
    // MARK: Inits
    
    public init(tableView: UITableView, delegate: TableViewManagerDelegate?) {
        
        super.init()
                
        tableView.dataSource = self
        tableView.delegate = self
        
        self.tableView = tableView
        self.delegate = delegate
    }
    
    /**
     Return the item at indexPath
     
     - parameter indexPath: Position of element we want to get
     
     - returns: The element representing the cell
     */
    private func itemForIndexPath(indexPath: NSIndexPath) -> TableViewItemProtocol {
        
        let section = sections[indexPath.section]
        let item = section.items[indexPath.row]
        
        item.indexPath = indexPath
        return item
    }
    
    // MARK: Public methods
    
    /**
     Register a nib cell into tableView
     
     - parameter cell: Cell to be registered
     */
    public func register(cell cell: TableViewCellType) {
        
        register(cell: cell, bundle: nil)
    }
    
    /**
     Register a nib cell into tableView
     
     - parameter cell:   Cell to be registered
     - parameter bundle: Bundle that contain the cell
     */
    public func register(cell cell: TableViewCellType, bundle: NSBundle?) {
        switch cell {
        case .Class(let cellClass):
            tableView.registerClass(cell.cellClass, forCellReuseIdentifier: cell.reusableIdentifier)
        case .Nib(let nib, let cellClass):
            tableView.registerNib(nib, forCellReuseIdentifier: cell.reusableIdentifier)
        }

    }
    
    // MARK: Managing sections
    
    /**
     Add a section
     
     - parameter section: Section to be added
     */
    public func addSection(section: TableViewSectionProtocol) {
        
        section.tableViewManager = self
        sections.append(section)
    }
    
    /**
     Add array of sections
     
     - parameter sections: Sections to be added
     */
    public func addSections(sections: [TableViewSectionProtocol]) {
        
        for section in sections {
            addSection(section)
        }
    }
    
    public func validate(item: Validationable, setup: (Validation<String?>) -> Void) {
        setup(item.validation)
        validator.add(validation: item.validation)
    }
}


extension TableViewManager: UITableViewDataSource {
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection sectionIndex: Int) -> Int {
        let section = sections[sectionIndex]
        return section.items.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let item = itemForIndexPath(indexPath)
        
        let tableViewCell = item.drawer.cell(forTableView: tableView, atIndexPath: indexPath)
        tableViewCell.item = item
        tableViewCell.tableViewManager = self
        
        item.drawer.draw(cell: tableViewCell, withItem: item)
        
        return tableViewCell
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if let height = delegate?.tableView?(tableView, heightForRowAtIndexPath: indexPath) {
            return height
        }
        else {
            let item = itemForIndexPath(indexPath)
            return CGFloat(item.cellHeight)
        }
    }
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let section = sections[section]
        
        if let headerView = section.headerView {
            return CGRectGetHeight(headerView.frame)
        }
        
        return CGFloat(Constants.Frame.HeaderViewHeight)
    }
    
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let section = sections[section]
        return section.headerTitle
    }
    
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let section = sections[section]
        return section.headerView
    }
    
    public func tableView(tableView: UITableView, titleForFooterInSection sectionIndex: Int) -> String? {
        
        let section = sections[sectionIndex]
        return section.footerTitle
    }
    
    public func tableView(tableView: UITableView, viewForFooterInSection sectionIndex: Int) -> UIView? {
        
        let section = sections[sectionIndex]
        return section.footerView
    }
}

extension TableViewManager: UITableViewDelegate {
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let item = itemForIndexPath(indexPath)
        item.selectionHandler?(item)
    }
    
}











