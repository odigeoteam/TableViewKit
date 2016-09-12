//
//  TableViewManager.swift
//  TableViewKit
//
//  Created by Nelson Dominguez Leon on 07/06/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import Foundation
import UIKit

open class TableViewManager: NSObject {
    
    // MARK: Properties
    open let tableView: UITableView
    open var sections: ObservableArray<Section>
    
    open var validator: ValidatorManager<String?> = ValidatorManager()
    open var errors: [ValidationError] {
        get {
            return validator.errors
        }
    }
    
    
    // MARK: Inits
    
    public init(tableView: UITableView) {
        self.tableView = tableView
        self.sections = []
        super.init()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.setupSections()
        
    }
    
    public init(tableView: UITableView, sections: [Section]) {
        self.tableView = tableView
        self.sections = []
        super.init()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.setupSections()
        self.sections.replace(with: sections)
    }
    
    private func setupSections() {
        sections.callback = { [weak self] change in
            guard let weakSelf = self else { return }
            
            switch change {
            case .inserts(let array):
                array.forEach { index in
                    weakSelf.sections[index].setup(inManager: weakSelf)
                    weakSelf.sections[index].register(inManager: weakSelf)
                }
                weakSelf.tableView.insertSections(IndexSet(array), with: .automatic)
            case .deletes(let array):
                weakSelf.tableView.deleteSections(IndexSet(array), with: .automatic)
            case .updates(let array):
                weakSelf.tableView.reloadSections(IndexSet(array), with: .automatic)
            case .moves(_): break
            case .beginUpdates:
                weakSelf.tableView.beginUpdates()
            case .endUpdates:
                weakSelf.tableView.endUpdates()
            }
        }
    }
}

extension TableViewManager {
    
    fileprivate func item(forIndexPath indexPath: IndexPath) -> Item {
        return sections[indexPath.section].items[indexPath.row]
    }
    
    fileprivate func view(forKey key: (Section) -> HeaderFooterView, inSection section: Int) -> UIView? {
        guard case .view(let item) = key(sections[section]) else { return nil }
        
        let drawer = item.drawer
        let view = drawer.view(inManager: self, withItem: item)
        drawer.draw(view, withItem: item)
        
        return view
    }
    
    fileprivate func title(forKey key: (Section) -> HeaderFooterView, inSection section: Int) -> String? {
        if case .title(let value) = key(sections[section]) {
            return value
        }
        return nil
        
    }
    
    fileprivate func estimatedHeight(forKey key: (Section) -> HeaderFooterView, inSection section: Int) -> CGFloat? {
        let item = key(sections[section])
        switch item {
        case .view(let view):
            guard let height = view.height else { return nil }
            return estimatedHeight(height)
        case .title(_):
            return 1.0
        default:
            return nil
        }
    }
    
    fileprivate func estimatedHeight(atIndexPath indexPath: IndexPath) -> CGFloat? {
        guard let height = item(forIndexPath: indexPath).height else { return nil }
        return estimatedHeight(height)
    }
    
    fileprivate func estimatedHeight(_ height: ImmutableMutableHeight) -> CGFloat {
        switch height {
        case .immutable(_):
            return 0.0
        case .mutable(let value):
            return value
        }
    }
    
    fileprivate func height(forKey key: (Section) -> HeaderFooterView, inSection section: Int) -> CGFloat? {
        guard case .view(let view) = key(sections[section]), let value = view.height
            else { return nil }
        return height(value)
    }
    
    fileprivate func height(atIndexPath indexPath: IndexPath) -> CGFloat? {
        guard let value = item(forIndexPath: indexPath).height else { return nil }
        return height(value)
    }
    
    fileprivate func height(_ height: ImmutableMutableHeight) -> CGFloat {
        switch height {
        case .immutable(let value):
            return value
        case .mutable(_):
            return UITableViewAutomaticDimension
        }
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
        return title(forKey: {$0.header}, inSection: section)
    }
    
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return title(forKey: {$0.footer}, inSection: section)
    }
    
    
}

extension TableViewManager: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let currentItem = item(forIndexPath: indexPath) as? Selectable else { return }
        currentItem.onSelection(currentItem)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return height(atIndexPath: indexPath) ?? tableView.rowHeight
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return height(forKey: {$0.header}, inSection: section) ?? tableView.sectionHeaderHeight
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return height(forKey: {$0.footer}, inSection: section) ?? tableView.sectionFooterHeight
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return estimatedHeight(atIndexPath: indexPath) ?? tableView.estimatedRowHeight
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return estimatedHeight(forKey: {$0.header}, inSection: section) ?? tableView.estimatedSectionHeaderHeight
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return estimatedHeight(forKey: {$0.footer}, inSection: section) ?? tableView.estimatedSectionHeaderHeight
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return view(forKey: {$0.header}, inSection: section)
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return view(forKey: {$0.footer}, inSection: section)
    }
    
}
