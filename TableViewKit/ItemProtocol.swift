//
//  ItemProtocol.swift
//  Pods
//
//  Created by Alfredo Delli Bovi on 27/08/16.
//
//

import Foundation

public protocol ItemProtocol: class {
    var drawer: CellDrawer.Type { get }
    
    var cellHeight: CGFloat? { get set }
    
    var onSelection: (ItemProtocol) -> () { get set }
    
    func indexPath(inManager manager: TableViewManager) -> NSIndexPath?
    func section(inManager manager: TableViewManager) -> Section?
    
    func selectRow(inManager manager: TableViewManager, animated: Bool, scrollPosition: UITableViewScrollPosition)
    func deselectRow(inManager manager: TableViewManager, animated: Bool)
    func reloadRow(inManager manager: TableViewManager, withAnimation animation: UITableViewRowAnimation)
    func deleteRow(inManager manager: TableViewManager, withAnimation animation: UITableViewRowAnimation)
}

extension ItemProtocol {
    
    public func section(inManager manager: TableViewManager) -> Section? {
        guard let indexPath = self.indexPath(inManager: manager) else { return nil }
        return manager.sections[indexPath.section]
    }
    
    public func indexPath(inManager manager: TableViewManager) -> NSIndexPath? {
        for section in manager.sections {
            guard
                let sectionIndex = section.index,
                let rowIndex = section.items.indexOf(self) else { continue }
            return NSIndexPath(forRow: rowIndex, inSection: sectionIndex)
        }
        return nil
    }
    
    public func selectRow(inManager manager: TableViewManager, animated: Bool, scrollPosition: UITableViewScrollPosition = .None) {
        
        manager.tableView.selectRowAtIndexPath(indexPath(inManager: manager), animated: animated, scrollPosition: scrollPosition)
    }
    
    public func deselectRow(inManager manager: TableViewManager, animated: Bool) {
        
        if let itemIndexPath = indexPath(inManager: manager) {
            manager.tableView.deselectRowAtIndexPath(itemIndexPath, animated: animated)
        }
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

extension CollectionType where Generator.Element == ItemProtocol {
    func indexOf(element: Generator.Element) -> Index? {
        return indexOf({ $0 === element })
    }
}
