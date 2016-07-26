//
//  TableViewCell.swift
//  TableViewKit
//
//  Created by Nelson Dominguez Leon on 08/06/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import Foundation
import UIKit

public enum TableViewCellType {
    case First, Middle, Last, Single, Any
}

public class TableViewCell : UITableViewCell {
    
    // MARK: Public
    
    weak public var tableViewManager: TableViewManager!
    
    public var actionBar: ActionBar!
    
    public var rowIndex: Int!
    public var sectionIndex: Int!
    
    public var item: TableViewItemProtocol?
    
    public var type: TableViewCellType {
        if rowIndex == 0 && item?.section?.items.count == 1 { return .Single }
        if rowIndex == 0 && item?.section?.items.count > 1 { return .First }
        if rowIndex > 0 && rowIndex < (item?.section?.items.count)! - 1 && item?.section?.items.count > 2 { return .Middle }
        if rowIndex == (item?.section?.items.count)! - 1 && (item?.section?.items.count)! > 1 { return .Last }
        return .Any
    }
    
    // MARK: Constructors
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public override required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    // MARK: Configure
    
    public func commonInit() {
        
        actionBar = ActionBar(delegate: self)
    }
    
    public func configure() {
        
        if let cellItem = item {
            
            sectionIndex = cellItem.indexPath!.section
            rowIndex = cellItem.indexPath!.row
            
            accessoryType = cellItem.accessoryType
            accessoryView = cellItem.accessoryView
            
            imageView?.image = cellItem.image
            textLabel?.text = cellItem.title
            detailTextLabel?.text = cellItem.subtitle
        }
    }
    
    public class func canFocus(withItem item: TableViewItemProtocol) -> Bool {
        return false
    }
    
    public func responder() -> UIResponder? {
        return nil
    }
}

extension TableViewCell: ActionBarDelegate {
    
    private func indexPathForPreviousResponderInSectionIndex(sectionIndex: Int) -> NSIndexPath? {
        
        let section = tableViewManager.sections[sectionIndex]
        let indexInSection = section == item!.section ? section.items.indexOf { $0 == item! } : section.items.count
        
        if indexInSection > 0 {
            
            for itemIndex in (0 ... indexInSection! - 1).reverse() {
                let previousItem = section.items[itemIndex]
                if previousItem.drawer.cellClass().canFocus(withItem: previousItem) {
                    return NSIndexPath(forRow: itemIndex, inSection: sectionIndex)
                }
            }
        }
        
        return nil
    }
    
    private func indexPathForPreviousResponder() -> NSIndexPath? {
        
        for index in (0 ... sectionIndex).reverse() {
            if let indexPath = indexPathForPreviousResponderInSectionIndex(index) {
                return indexPath
            }
        }
        
        return nil
    }
    
    private func indexPathForNextResponderInSectionIndex(sectionIndex: Int) -> NSIndexPath? {
        
        let section = tableViewManager.sections[sectionIndex]
        let indexInSection = section == item!.section ? section.items.indexOf { $0 == item! } : -1
        
        for itemIndex in indexInSection! + 1 ... section.items.count - 1 {
            let nextItem = section.items[itemIndex]
            if nextItem.drawer.cellClass().canFocus(withItem: nextItem) {
                return NSIndexPath(forRow: itemIndex, inSection: sectionIndex)
            }
        }
        
        return nil
    }
    
    private func indexPathForNextResponder() -> NSIndexPath? {
        
        for index in sectionIndex ... tableViewManager.sections.count - 1 {
            if let indexPath = indexPathForNextResponderInSectionIndex(index) {
                return indexPath
            }
        }
        
        return nil
    }
    
    public func actionBar(actionBar: ActionBar, navigationControlValueChanged navigationControl: UISegmentedControl) {
        
        if let indexPath = navigationControl.selectedSegmentIndex == 0 ? indexPathForPreviousResponder() : indexPathForNextResponder() {
            
            // Get the cell
            var cell = tableViewManager.tableView.cellForRowAtIndexPath(indexPath) as? TableViewCell
            // No cell? Scrool tableview
            if cell == nil {
                tableViewManager.tableView .scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: false)
            }
            // Try again
            cell = tableViewManager.tableView.cellForRowAtIndexPath(indexPath) as? TableViewCell
            
            cell?.responder()?.becomeFirstResponder()
        }
    }
    
    public func actionBar(actionBar: ActionBar, doneButtonPressed doneButtonItem: UIBarButtonItem) {
        endEditing(true)
    }
}




