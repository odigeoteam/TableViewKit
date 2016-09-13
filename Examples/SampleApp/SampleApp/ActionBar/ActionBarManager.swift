//
//  ActionBarManager.swift
//  SampleApp
//
//  Created by Alfredo Delli Bovi on 12/09/2016.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import Foundation
import TableViewKit

class ActionBarManager: ActionBarDelegate {
    
    let manager: TableViewManager
    
    init(manager: TableViewManager) {
        self.manager = manager
    }
    
    public func actionBar(_ actionBar: ActionBar, direction: Direction) {
        guard let indexPath = indexPathForResponder(forDirection: direction) else { return }
        
        manager.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        manager.tableView.cellForRow(at: indexPath)?.becomeFirstResponder()
    }
    
    public func actionBar(_ actionBar: ActionBar, doneButtonPressed doneButtonItem: UIBarButtonItem) { }
    
    fileprivate func indexPathForResponder(forDirection direction: Direction) -> IndexPath? {
        
        func isFirstResponder(item: Item) -> Bool {
            if isResponder(item: item),
                let indexPath = item.indexPath(in: manager),
                manager.tableView.cellForRow(at: indexPath)?.isFirstResponder == true {
                return true
            }
            return false
        }
        
        func isResponder(item: Item) -> Bool {
            return (item as? UIResponder)?.canBecomeFirstResponder ?? false
        }
        
        let array = manager.sections.flatMap { $0.items }
        guard let currentItem = array.first(where: isFirstResponder),
            let index = array.index(of: currentItem)
            else { return nil }
        
        let item: Item?
        
        switch direction {
        case .next:
            item = array.suffix(from: index).dropFirst().first(where: isResponder)
        case .previous:
            item = array.prefix(upTo: index).reversed().first(where: isResponder)
        }
        
        return item?.indexPath(in: manager)
        
    }
}
