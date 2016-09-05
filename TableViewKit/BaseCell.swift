//
//  TableViewCell.swift
//  TableViewKit
//
//  Created by Nelson Dominguez Leon on 08/06/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import Foundation
import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


open class BaseCell : UITableViewCell {
    
    // MARK: Public
    
    weak open var tableViewManager: TableViewManager!
    open var item: Item?
    
    open var responder: UIResponder?
    
    open var actionBar: ActionBar!
    
    
    // MARK: Constructors
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public override required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    // MARK: Configure
    
    open func commonInit() {
        actionBar = ActionBar(delegate: self)
    }

    open override var canBecomeFirstResponder: Bool {
        guard let responder = responder else { return false }
        return responder.canBecomeFirstResponder
    }
    
    open override func becomeFirstResponder() -> Bool {
        guard let responder = responder else { return false }
        return responder.becomeFirstResponder()
    }

    open override var isFirstResponder: Bool {
        guard let responder = responder else { return false }
        return responder.isFirstResponder
    }

}

extension BaseCell: ActionBarDelegate {
    
    fileprivate func indexPathForPreviousResponderInSectionIndex(_ sectionIndex: Int) -> IndexPath? {
        
        guard let item = self.item else { return nil }
        
        let section = tableViewManager.sections[sectionIndex]
        let indexInSection = section === item.section(inManager: tableViewManager) ? section.items.indexOf(item) : section.items.count
        
        guard indexInSection > 0 else { return nil }
            
        for itemIndex in (0 ..< indexInSection!).reversed() {
            let previousItem = section.items[itemIndex]
            guard let indexPath = previousItem.indexPath(inManager: tableViewManager),
                let cell = tableViewManager.tableView.cellForRow(at: indexPath)
                else { continue }
            if cell.canBecomeFirstResponder {
                return indexPath
            }

        }
        
        return nil
    }
    
    fileprivate func indexPathForPreviousResponder() -> IndexPath? {
        guard let sectionIndex = (item?.indexPath(inManager: tableViewManager) as NSIndexPath?)?.section else { return nil }


        for index in (0 ... sectionIndex).reversed() {
            if let indexPath = indexPathForPreviousResponderInSectionIndex(index) {
                return indexPath
            }
        }
        
        return nil
    }
    
    fileprivate func indexPathForNextResponderInSectionIndex(_ sectionIndex: Int) -> IndexPath? {
        
        let section = tableViewManager.sections[sectionIndex]
        let indexInSection = section === item!.section(inManager: tableViewManager) ? section.items.indexOf(item!) : -1
        
        for itemIndex in indexInSection! + 1 ..< section.items.count {
            let nextItem = section.items[itemIndex]
            guard let indexPath = nextItem.indexPath(inManager: tableViewManager),
                let cell = tableViewManager.tableView.cellForRow(at: indexPath)
                else { continue }
            if cell.canBecomeFirstResponder {
                return indexPath
            }
        }
        
        return nil
    }
    
    fileprivate func indexPathForNextResponder() -> IndexPath? {
        guard let sectionIndex = (item?.indexPath(inManager: tableViewManager) as NSIndexPath?)?.section else { return nil }

        for index in sectionIndex ... tableViewManager.sections.count - 1 {
            if let indexPath = indexPathForNextResponderInSectionIndex(index) {
                return indexPath
            }
        }
        
        return nil
    }
    
    fileprivate func indexPathForResponder(forDirection direction: Direction) -> IndexPath? {
        
        switch direction {
        case .next:
            return indexPathForNextResponder()
        case .previous:
            return indexPathForPreviousResponder()
        }
    }
    
    public func actionBar(_ actionBar: ActionBar, direction: Direction) -> IndexPath? {
        guard let indexPath = indexPathForResponder(forDirection: direction) else { return nil }
        tableViewManager.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        
        let cell = tableViewManager.tableView.cellForRow(at: indexPath) as! BaseCell
        let _ = cell.becomeFirstResponder()
        return indexPath
    }
    
    public func actionBar(_ actionBar: ActionBar, doneButtonPressed doneButtonItem: UIBarButtonItem) {
        endEditing(true)
    }
}
