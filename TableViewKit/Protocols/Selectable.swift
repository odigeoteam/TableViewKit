//
//  Selectable.swift
//  TableViewKit
//
//  Created by Alfredo Delli Bovi on 29/08/16.
//  Copyright © 2016 odigeo. All rights reserved.
//

import Foundation

public protocol Selectable: Item {
    var onSelection: (Selectable) -> () { get set }
    
    func selectRow(inManager manager: TableViewManager, animated: Bool, scrollPosition: UITableViewScrollPosition)
    func deselectRow(inManager manager: TableViewManager, animated: Bool)
}

extension Selectable {
    
    public func selectRow(inManager manager: TableViewManager, animated: Bool, scrollPosition: UITableViewScrollPosition = .none) {
        
        manager.tableView.selectRow(at: indexPath(inManager: manager) as IndexPath?, animated: animated, scrollPosition: scrollPosition)
    }
    
    public func deselectRow(inManager manager: TableViewManager, animated: Bool) {
        
        if let itemIndexPath = indexPath(inManager: manager) {
            manager.tableView.deselectRow(at: itemIndexPath as IndexPath, animated: animated)
        }
    }
    
}
