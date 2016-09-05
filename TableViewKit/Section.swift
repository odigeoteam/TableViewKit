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


public protocol Section: class {
    var items: CollectionProperty<[ItemProtocol]> { get }

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
            
            tableView.beginUpdates()
            if e.inserts.count > 0 {
                let indexPaths = e.inserts.map { NSIndexPath(forItem: $0, inSection: sectionIndex) }
                tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
            }
            
            if e.updates.count > 0 {
                let indexPaths = e.updates.map { NSIndexPath(forItem: $0, inSection: sectionIndex) }
                tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
            }
            
            if e.deletes.count > 0 {
                let indexPaths = e.deletes.map { NSIndexPath(forItem: $0, inSection: sectionIndex) }
                tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
            }
            tableView.endUpdates()
        }.disposeIn(manager.disposeBag)
    }
}

extension CollectionType where Generator.Element == Section {
    func indexOf(element: Generator.Element) -> Index? {
        return indexOf({ $0 === element })
    }
}