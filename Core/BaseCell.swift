//
//  TableViewCell.swift
//  TableViewKit
//
//  Created by Nelson Dominguez Leon on 08/06/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import Foundation
import UIKit

public enum CellType {
    
    case Nib(UINib, UITableViewCell.Type)
    case Class(UITableViewCell.Type)
    
    public var reusableIdentifier: String {
        switch self {
        case .Class(let cellClass):
            return String(cellClass)
        case .Nib(_, let cellClass):
            return String(cellClass)
        }
    }
    
    public var cellClass: UITableViewCell.Type {
        switch self {
        case .Class(let cellClass):
            return cellClass
        case .Nib(_, let cellClass):
            return cellClass
        }
    }
}

public class BaseCell : UITableViewCell {
    
    // MARK: Public
    
    weak public var tableViewManager: TableViewManager!
    public var item: ItemProtocol?

    public var responder: UIResponder?
    
    public var actionBar: ActionBar!
    
    
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

}

extension BaseCell: ActionBarDelegate {
    
    private func indexPathForPreviousResponderInSectionIndex(sectionIndex: Int) -> NSIndexPath? {
        
        guard let item = item else { return nil }
        
        let section = tableViewManager.sections[sectionIndex]
        let indexInSection = section == item.section(inManager: tableViewManager) ? section.items.indexOf(item) : section.items.count
        
        guard indexInSection > 0 else { return nil }
            
        for itemIndex in (0 ..< indexInSection!).reverse() {
            let previousItem = section.items[itemIndex]
            let cell = previousItem.drawer.cell(inManager: tableViewManager, withItem: previousItem)
            if cell.responder != nil {
                return previousItem.indexPath(inManager: tableViewManager)
            }
        }
        
        return nil
    }
    
    private func indexPathForPreviousResponder() -> NSIndexPath? {
        let sectionIndex = (item?.indexPath(inManager: tableViewManager)?.section)!

        for index in (0 ... sectionIndex).reverse() {
            if let indexPath = indexPathForPreviousResponderInSectionIndex(index) {
                return indexPath
            }
        }
        
        return nil
    }
    
    private func indexPathForNextResponderInSectionIndex(sectionIndex: Int) -> NSIndexPath? {
        
        let section = tableViewManager.sections[sectionIndex]
        let indexInSection = section == item!.section(inManager: tableViewManager) ? section.items.indexOf(item!) : -1
        
        for itemIndex in indexInSection! + 1 ..< section.items.count {
            let nextItem = section.items[itemIndex]
            let cell = nextItem.drawer.cell(inManager: tableViewManager, withItem: nextItem)
            if cell.responder != nil {
                return nextItem.indexPath(inManager: tableViewManager)
            }
        }
        
        return nil
    }
    
    private func indexPathForNextResponder() -> NSIndexPath? {
        let sectionIndex = (item?.indexPath(inManager: tableViewManager)?.section)!

        for index in sectionIndex ... tableViewManager.sections.count - 1 {
            if let indexPath = indexPathForNextResponderInSectionIndex(index) {
                return indexPath
            }
        }
        
        return nil
    }
    
    private func indexPathForResponder(forDirection direction: Direction) -> NSIndexPath? {
        
        switch direction {
        case .next:
            return indexPathForNextResponder()
        case .previous:
            return indexPathForPreviousResponder()
        }
    }
    
    public func actionBar(actionBar: ActionBar, direction direction: Direction) {
        guard let indexPath = indexPathForResponder(forDirection: direction) else { return }
        
        tableViewManager.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: false)
        
        var cell = tableViewManager.tableView.cellForRowAtIndexPath(indexPath) as? BaseCell
        cell?.responder?.becomeFirstResponder()
    }
    
    public func actionBar(actionBar: ActionBar, doneButtonPressed doneButtonItem: UIBarButtonItem) {
        endEditing(true)
    }
}
