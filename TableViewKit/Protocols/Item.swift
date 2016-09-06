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

    func indexPath(inManager manager: TableViewManager) -> IndexPath?
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
        return manager.sections[(indexPath as NSIndexPath).section]
    }

    public func indexPath(inManager manager: TableViewManager) -> IndexPath? {
        for section in manager.sections {
            guard
                let sectionIndex = section.index(inManager: manager),
                let rowIndex = section.items.indexOf(self) else { continue }
            return IndexPath(row: rowIndex, section: sectionIndex)
        }
        return nil
    }

    public func reloadRow(inManager manager: TableViewManager, withAnimation animation: UITableViewRowAnimation) {

        if let itemIndexPath = indexPath(inManager: manager) {
            manager.tableView.reloadRows(at: [itemIndexPath], with: animation)
        }
    }

    public func deleteRow(inManager manager: TableViewManager, withAnimation animation: UITableViewRowAnimation) {

        if let itemIndexPath = indexPath(inManager: manager) {
            manager.tableView.deleteRows(at: [itemIndexPath], with: animation)
        }
    }
}

extension Collection where Iterator.Element == Item {
    func indexOf(_ element: Iterator.Element) -> Index? {
        return index(where: { $0 === element })
    }
}
