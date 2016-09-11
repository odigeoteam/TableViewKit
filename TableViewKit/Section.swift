//
//  TableViewSection.swift
//  TableViewKit
//
//  Created by Nelson Dominguez Leon on 07/06/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import Foundation
import UIKit

public protocol Section: class {
    var items: ObservableArray<Item> { get set }

    var header: HeaderFooterView { get }
    var footer: HeaderFooterView { get }

    func index(inManager manager: TableViewManager) -> Int?
    func setup(inManager manager: TableViewManager)
    func register(inManager manager: TableViewManager)
}

extension Section {
    public var header: HeaderFooterView { return nil }
    public var footer: HeaderFooterView { return nil }

    public func index(inManager manager: TableViewManager) -> Int? { return manager.sections.indexOf(self) }
    public func register(inManager manager: TableViewManager) {
        if case .view(let header) = header {
            manager.tableView.register(type: header.drawer.headerFooterType)
        }
        if case .view(let footer) = footer {
            manager.tableView.register(type: footer.drawer.headerFooterType)
        }
        items.forEach {
            if let item = $0 as? Validationable {
                manager.validator.add(validation: item.validation)
            }

            manager.tableView.register(type: $0.drawer.cellType)
        }
    }

    public func setup(inManager manager: TableViewManager) {
        items.callback = { change in
            guard let sectionIndex = manager.sections.indexOf(self) else { return }
            let tableView = manager.tableView

            switch change {
            case .inserts(let array):
                let indexPaths = array.map { IndexPath(item: $0, section: sectionIndex) }
                tableView.insertRows(at: indexPaths, with: .automatic)
            case .deletes(let array):
                let indexPaths = array.map { IndexPath(item: $0, section: sectionIndex) }
                tableView.deleteRows(at: indexPaths, with: .automatic)
            case .updates(let array):
                let indexPaths = array.map { IndexPath(item: $0, section: sectionIndex) }
                tableView.reloadRows(at: indexPaths, with: .automatic)
            case .moves(let array):
                let fromIndexPaths = array.map { IndexPath(item: $0.0, section: sectionIndex) }
                let toIndexPaths = array.map { IndexPath(item: $0.1, section: sectionIndex) }
                tableView.moveRows(at: fromIndexPaths, to: toIndexPaths)
            case .beginUpdates:
                tableView.beginUpdates()
            case .endUpdates:
                tableView.endUpdates()
            }

        }
    }
}

public extension Collection where Iterator.Element == Section {
    func indexOf(_ element: Iterator.Element) -> Index? {
        return index(where: { $0 === element })
    }
}
