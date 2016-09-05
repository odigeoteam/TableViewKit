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
import Bond

open class TableViewManager: NSObject {
    
    // MARK: Properties
    open let tableView: UITableView
    open var sections: MutableObservableArray<Section> = MutableObservableArray([])
    
    open var validator: ValidatorManager<String?> = ValidatorManager()
    open var errors: [ValidationError] {
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
            
            switch e.change {
            case .initial: break
            case .inserts(let array):
                array.forEach { index in
                    self.sections[index].setup(inManager: self)
                    self.sections[index].register(inManager: self)
                }
                tableView.insertSections(IndexSet(array), with: .automatic)
            case .deletes(let array):
                tableView.deleteSections(IndexSet(array), with: .automatic)
            case .updates(let array):
                tableView.reloadSections(IndexSet(array), with: .automatic)
            case .move(_, _): break
            case .beginBatchEditing:
                tableView.beginUpdates()
            case .endBatchEditing:
                tableView.endUpdates()
            }
            
        }.disposeIn(disposeBag)
    }
    
    public convenience init(tableView: UITableView, sections: [Section]) {
        self.init(tableView: tableView)
        self.sections.insert(contentsOf: sections, at: 0)
    }
    
}

extension TableViewManager {
    
    fileprivate func item(forIndexPath indexPath: IndexPath) -> Item {
        return sections[(indexPath as NSIndexPath).section].items[(indexPath as NSIndexPath).row]
    }
    
    fileprivate func header(inSection section: Int) -> HeaderFooter? {
        return sections[section].header
    }
    
    fileprivate func footer(inSection section: Int) -> HeaderFooter? {
        return sections[section].footer
    }

}

extension TableViewManager: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection sectionIndex: Int) -> Int {
        let section = sections[sectionIndex]
        return section.items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentItem = item(forIndexPath: indexPath)
        let drawer = currentItem.drawer
        
        let cell = drawer.cell(inManager: self, withItem: currentItem, forIndexPath: indexPath)
        drawer.draw(cell, withItem: currentItem)
        
        return cell
    }
    
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].headerTitle
    }
    
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections[section].footerTitle
    }
    

}

extension TableViewManager: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let currentItem = item(forIndexPath: indexPath) as? Selectable else { return }
        currentItem.onSelection(currentItem)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let height = item(forIndexPath: indexPath).height else { return tableView.rowHeight }
        switch height {
        case .immutable(let value):
            return value
        case .mutable(_):
            return UITableViewAutomaticDimension
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let currentItem = header(inSection: section), let height = currentItem.height
            else { return tableView.sectionHeaderHeight }
        
        switch height {
        case .immutable(let value):
            return value
        case .mutable(_):
            return UITableViewAutomaticDimension
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let currentItem = footer(inSection: section), let height = currentItem.height
            else { return tableView.sectionFooterHeight }
        
        switch height {
        case .immutable(let value):
            return value
        case .mutable(_):
            return UITableViewAutomaticDimension
        }
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let height = item(forIndexPath: indexPath).height else { return tableView.estimatedRowHeight }
        switch height {
        case .immutable(_):
            return 0.0
        case .mutable(let value):
            return value
        }
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        guard let currentItem = header(inSection: section), let height = currentItem.height
            else { return tableView.estimatedSectionHeaderHeight }
        
        switch height {
        case .immutable(_):
            return 0.0
        case .mutable(let value):
            return value
        }        
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        guard let currentItem = footer(inSection: section), let height = currentItem.height
            else { return tableView.estimatedSectionFooterHeight }
        
        switch height {
        case .immutable(_):
            return 0.0
        case .mutable(let value):
            return value
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let currentItem = header(inSection: section) else { return nil }
        
        let drawer = currentItem.drawer
        let view = drawer.view(inManager: self, withItem: currentItem)
        drawer.draw(view, withItem: currentItem)
        
        return view
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let currentItem = footer(inSection: section) else { return nil }
        
        let drawer = currentItem.drawer
        let view = drawer.view(inManager: self, withItem: currentItem)
        drawer.draw(view, withItem: currentItem)
        
        return view
        
    }
    
}











