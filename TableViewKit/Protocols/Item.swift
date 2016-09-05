//
//  Item.swift
//  Pods
//
//  Created by Alfredo Delli Bovi on 27/08/16.
//
//

import Foundation

public protocol Item: class {
    var drawer: CellDrawer.Type { get }
    
    var height: ImmutableMutableHeight? { get }
    
    func indexPath(inManager manager: TableViewManager) -> NSIndexPath?
    func section(inManager manager: TableViewManager) -> Section?
    
    func reloadRow(inManager manager: TableViewManager, withAnimation animation: UITableViewRowAnimation)
    func deleteRow(inManager manager: TableViewManager, withAnimation animation: UITableViewRowAnimation)
}

extension Item {
    
    public var height: ImmutableMutableHeight? {
        return .mutable(44.0)
    }
    
    public func section(inManager manager: TableViewManager) -> Section? {
        guard let indexPath = self.indexPath(inManager: manager) else { return nil }
        return manager.sections[indexPath.section]
    }
    
    public func indexPath(inManager manager: TableViewManager) -> NSIndexPath? {
        for section in manager.sections {
            guard
                let sectionIndex = section.index(inManager: manager),
                let rowIndex = section.items.indexOf(self) else { continue }
            return NSIndexPath(forRow: rowIndex, inSection: sectionIndex)
        }
        return nil
    }
    
    public func reloadRow(inManager manager: TableViewManager, withAnimation animation: UITableViewRowAnimation) {
        
        if let itemIndexPath = indexPath(inManager: manager) {
            manager.tableView.reloadRowsAtIndexPaths([itemIndexPath], withRowAnimation: animation)
        }
    }
    
    public func deleteRow(inManager manager: TableViewManager, withAnimation animation: UITableViewRowAnimation) {
        
        if let itemIndexPath = indexPath(inManager: manager) {
            manager.tableView.deleteRowsAtIndexPaths([itemIndexPath], withRowAnimation: animation)
        }
    }
}

extension CollectionType where Generator.Element == Item {
    func indexOf(element: Generator.Element) -> Index? {
        return indexOf({ $0 === element })
    }
}
