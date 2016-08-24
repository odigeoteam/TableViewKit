//
//  TableViewManager.swift
//  TableViewKit
//
//  Created by Nelson Dominguez Leon on 07/06/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import Foundation
import UIKit

public class TableViewManager: NSObject {
    
    // MARK: Properties
    
    /// Array of sections
    public var sections: [Section] = []
    
    /// TableView to be managed
    public var tableView: UITableView!
    
    
    public var validator: ValidatorManager<String?> = ValidatorManager()
    
    public var errors: [ValidationError] {
        get {
            return validator.errors
        }
    }

    // MARK: Inits
    
    public init(tableView: UITableView) {
        super.init()
        self.tableView = tableView
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    public convenience init(tableView: UITableView, sections: [Section]) {
        self.init(tableView: tableView)
        append(sections)
    }
    
    // MARK: Public methods
    

    
    public func register(type type: CellType, bundle: NSBundle? = nil) {
        tableView.register(type: type, bundle: bundle)
    }
    
    public func register() {
        sections.forEach { $0.register(tableViewManager: self) }
    }
    
    // MARK: Managing sections
    
    public func append(section: Section) {
        section.tableViewManager = self
        sections.append(section)
    }
    
    public func append(sections: [Section]) {
        sections.forEach(append)
    }
    
    public func validate(item: Validationable, setup: (Validation<String?>) -> Void) {
        setup(item.validation)
        validator.add(validation: item.validation)
    }
}

extension TableViewManager {
    
    private func itemForIndexPath(indexPath: NSIndexPath) -> BaseItem {
        return sections[indexPath.section].items[indexPath.row]
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
    
    public func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        guard tableView == self.tableView else { return tableView.rowHeight }
        let item = itemForIndexPath(indexPath)
        return item.cellHeight ?? tableView.estimatedRowHeight
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        guard tableView == self.tableView else { return tableView.rowHeight }
        let item = itemForIndexPath(indexPath)
        return item.cellHeight ?? tableView.rowHeight
    }
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let section = sections[section]
        
        if let headerView = section.headerView {
            return CGRectGetHeight(headerView.frame)
        }
        
        return CGFloat(Constants.Frame.HeaderViewHeight)
    }
    
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].headerTitle
    }
    
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sections[section].headerView
    }
    
    public func tableView(tableView: UITableView, titleForFooterInSection sectionIndex: Int) -> String? {
        return sections[sectionIndex].footerTitle
    }
    
    public func tableView(tableView: UITableView, viewForFooterInSection sectionIndex: Int) -> UIView? {
        return sections[sectionIndex].footerView
    }
}

extension TableViewManager: UITableViewDelegate {
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = itemForIndexPath(indexPath)
        item.selectionHandler?(item)
    }
    
}











