//
//  TableViewManager.swift
//  TableViewKit
//
//  Created by Nelson Dominguez Leon on 07/06/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import Foundation
import UIKit
import ReactiveKit

public class TableViewManager: NSObject {
    
    // MARK: Properties
    public let tableView: UITableView
    public var sections: CollectionProperty<[Section]> = CollectionProperty([])
    
    public var validator: ValidatorManager<String?> = ValidatorManager()
    public var errors: [ValidationError] {
        get {
            return validator.errors
        }
    }
    
    let disposeBag = DisposeBag()


    // MARK: Inits
    
    public init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        sections.observeNext { e in
            guard e.inserts.count + e.updates.count + e.deletes.count > 0 else { return }

            e.inserts.forEach { index in
                e.collection[index].setup(inManager: self)
                e.collection[index].register(inManager: self)
            }
            
            tableView.beginUpdates()
            if e.inserts.count > 0 {
                tableView.insertSections(NSIndexSet(e.inserts), withRowAnimation: .Automatic)
            }
            
            if e.updates.count > 0 {
                tableView.reloadSections(NSIndexSet(e.updates), withRowAnimation: .Automatic)
            }
            
            if e.deletes.count > 0 {
                tableView.deleteSections(NSIndexSet(e.deletes), withRowAnimation: .Automatic)
            }
            tableView.endUpdates()
        }.disposeIn(disposeBag)
    }
    
    public convenience init(tableView: UITableView, sections: [Section]) {
        self.init(tableView: tableView)
        self.sections.insertContentsOf(sections, at: 0)
    }
    
}

extension TableViewManager {
    
    private func item(forIndexPath indexPath: NSIndexPath) -> Item {
        return sections[indexPath.section].items[indexPath.row]
    }
    
    private func header(inSection section: Int) -> HeaderFooter? {
        return sections[section].header
    }
    
    private func footer(inSection section: Int) -> HeaderFooter? {
        return sections[section].footer
    }

}

extension TableViewManager: UITableViewDataSource {
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection sectionIndex: Int) -> Int {
        let section = sections[sectionIndex]
        return section.items.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let currentItem = item(forIndexPath: indexPath)
        let drawer = currentItem.drawer
        
        let cell = drawer.cell(inManager: self, withItem: currentItem, forIndexPath: indexPath)
        drawer.draw(cell, withItem: currentItem)
        
        return cell
    }
    
    
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].headerTitle
    }
    
    
    public func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections[section].footerTitle
    }
    

}

extension TableViewManager: UITableViewDelegate {
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let currentItem = item(forIndexPath: indexPath) as? Selectable else { return }
        currentItem.onSelection(currentItem)
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        guard let height = item(forIndexPath: indexPath).height else { return tableView.rowHeight }
        switch height {
        case .immutable(let value):
            return value
        case .mutable(_):
            return UITableViewAutomaticDimension
        }
    }
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let currentItem = header(inSection: section), let height = currentItem.height
            else { return tableView.sectionHeaderHeight }
        
        switch height {
        case .immutable(let value):
            return value
        case .mutable(_):
            return UITableViewAutomaticDimension
        }
    }
    
    public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let currentItem = footer(inSection: section), let height = currentItem.height
            else { return tableView.sectionFooterHeight }
        
        switch height {
        case .immutable(let value):
            return value
        case .mutable(_):
            return UITableViewAutomaticDimension
        }
    }
    
    public func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        guard let height = item(forIndexPath: indexPath).height else { return tableView.estimatedRowHeight }
        switch height {
        case .immutable(_):
            return 0.0
        case .mutable(let value):
            return value
        }
    }
    
    public func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        guard let currentItem = header(inSection: section), let height = currentItem.height
            else { return tableView.estimatedSectionHeaderHeight }
        
        switch height {
        case .immutable(_):
            return 0.0
        case .mutable(let value):
            return value
        }        
    }
    
    public func tableView(tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        guard let currentItem = footer(inSection: section), let height = currentItem.height
            else { return tableView.estimatedSectionFooterHeight }
        
        switch height {
        case .immutable(_):
            return 0.0
        case .mutable(let value):
            return value
        }
    }
    
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let currentItem = header(inSection: section) else { return nil }
        
        let drawer = currentItem.drawer
        let view = drawer.view(inManager: self, withItem: currentItem)
        drawer.draw(view, withItem: currentItem)
        
        return view
    }
    
    public func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let currentItem = footer(inSection: section) else { return nil }
        
        let drawer = currentItem.drawer
        let view = drawer.view(inManager: self, withItem: currentItem)
        drawer.draw(view, withItem: currentItem)
        
        return view
        
    }
    
}











