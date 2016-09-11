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

    func reload(inManager manager: TableViewManager, withAnimation animation: UITableViewRowAnimation)
}

extension Item {

    public var height: ImmutableMutableHeight? {
        return .mutable(44.0)
    }

    public func section(inManager manager: TableViewManager) -> Section? {
        guard let indexPath = self.indexPath(inManager: manager) else { return nil }
        return manager.sections[indexPath.section]
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

    public func reload(inManager manager: TableViewManager, withAnimation animation: UITableViewRowAnimation) {
        guard let indexPath = self.indexPath(inManager: manager) else { return }
        let section = manager.sections[indexPath.section]
        section.items.callback?(.updates([indexPath.row]))
    }

}

public extension Collection where Iterator.Element == Item {
    func indexOf(_ element: Iterator.Element) -> Index? {
        return index(where: { $0 === element })
    }
}
