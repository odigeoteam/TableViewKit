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
    var height: Height? { get }

    func indexPath(in manager: TableViewManager) -> IndexPath?
    func section(in manager: TableViewManager) -> Section?

    func reload(in manager: TableViewManager, with animation: UITableViewRowAnimation)
}

extension Item {

    public var height: Height? {
        return .dynamic(44.0)
    }

    public func section(in manager: TableViewManager) -> Section? {
        guard let indexPath = self.indexPath(in: manager) else { return nil }
        return manager.sections[indexPath.section]
    }

    public func indexPath(in manager: TableViewManager) -> IndexPath? {
        for section in manager.sections {
            guard
                let sectionIndex = section.index(in: manager),
                let rowIndex = section.items.index(of: self) else { continue }
            return IndexPath(row: rowIndex, section: sectionIndex)
        }
        return nil
    }

    public func reload(in manager: TableViewManager, with animation: UITableViewRowAnimation = .automatic) {
        guard let indexPath = self.indexPath(in: manager) else { return }
        let section = manager.sections[indexPath.section]
        section.items.callback?(.updates([indexPath.row]))
    }

}

public extension Collection where Iterator.Element == Item {
    func index(of element: Iterator.Element) -> Index? {
        return index(where: { $0 === element })
    }
}
