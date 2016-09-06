//
//  TableViewSection.swift
//  TableViewKit
//
//  Created by Nelson Dominguez Leon on 07/06/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import Foundation
import UIKit
import ReactiveKit
import Bond


public protocol Section: class {
    var items: MutableObservableArray<Item> { get }

    var headerTitle: String? { get }
    var footerTitle: String? { get }
    var header: HeaderFooter? { get }
    var footer: HeaderFooter? { get }

    func index(inManager manager: TableViewManager) -> Int?
    func setup(inManager manager: TableViewManager)
    func register(inManager manager: TableViewManager)
}

extension Section {
    public var headerTitle: String? { return nil }
    public var footerTitle: String? { return nil }
    public var header: HeaderFooter? { return nil }
    public var footer: HeaderFooter? { return nil }

    public func index(inManager manager: TableViewManager) -> Int? { return manager.sections.indexOf(self) }
    public func register(inManager manager: TableViewManager) {
        if let header = header {
            manager.tableView.register(type: header.drawer.headerFooterType)
        }
        if let header = header {
            manager.tableView.register(type: header.drawer.headerFooterType)
        }
        items.forEach {
            if let item = $0 as? Validationable {
                manager.validator.add(validation: item.validation)
            }

            manager.tableView.register(type: $0.drawer.cellType)
        }
    }

    public func setup(inManager manager: TableViewManager) {
        items.observeNext { e in
            guard let sectionIndex = manager.sections.indexOf(self) else { return }
            let tableView = manager.tableView

            switch e.change {
            case .initial: break
            case .inserts(let array):
                let indexPaths = array.map { IndexPath(item: $0, section: sectionIndex) }
                tableView.insertRows(at: indexPaths, with: .automatic)
            case .deletes(let array):
                let indexPaths = array.map { IndexPath(item: $0, section: sectionIndex) }
                tableView.deleteRows(at: indexPaths, with: .automatic)
            case .updates(let array):
                let indexPaths = array.map { IndexPath(item: $0, section: sectionIndex) }
                tableView.reloadRows(at: indexPaths, with: .automatic)
            case .move(_, _): break
            case .beginBatchEditing:
                tableView.beginUpdates()
            case .endBatchEditing:
                tableView.endUpdates()
            }

        }.disposeIn(manager.disposeBag)
    }
}

extension Collection where Iterator.Element == Section {
    func indexOf(_ element: Iterator.Element) -> Index? {
        return index(where: { $0 === element })
    }
}
