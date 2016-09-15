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
    
    // MARK: Inits
    
    public init(tableView: UITableView) {
        self.tableView = tableView
        self.sections = []
        super.init()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.setupSections()
        
    }

    public convenience init(tableView: UITableView, with sections: [Section]) {
        self.init(tableView: tableView)
        self.sections.replace(with: sections)
    }
    
    private func setupSections() {
        sections.callback = { [weak self] change in
            guard let weakSelf = self else { return }
            
            switch change {
            case .inserts(let array):
                array.forEach { index in
                    weakSelf.sections[index].setup(in: weakSelf)
                    weakSelf.sections[index].register(in: weakSelf)
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
    
    fileprivate func item(at indexPath: IndexPath) -> Item {
        return sections[indexPath.section].items[indexPath.row]
    }
    
    fileprivate func view(for key: (Section) -> HeaderFooterView, inSection section: Int) -> UIView? {
        guard case .view(let item) = key(sections[section]) else { return nil }
        
        let drawer = item.drawer
        let view = drawer.view(in: self, with: item)
        drawer.draw(view, with: item)
        
        return view
    }
    
    fileprivate func title(for key: (Section) -> HeaderFooterView, inSection section: Int) -> String? {
        if case .title(let value) = key(sections[section]) {
            return value
        }
        return nil
        
    }
    
    fileprivate func estimatedHeight(for key: (Section) -> HeaderFooterView, inSection section: Int) -> CGFloat? {
        let item = key(sections[section])
        switch item {
        case .view(let view):
            guard let height = view.height else { return nil }
            return height.estimated()
        case .title(_):
            return 1.0
        default:
            return nil
        }
    }
    
    fileprivate func estimatedHeight(at indexPath: IndexPath) -> CGFloat? {
        guard let height = item(at: indexPath).height else { return nil }
        return height.estimated()
    }
    

    
    fileprivate func height(for key: (Section) -> HeaderFooterView, inSection section: Int) -> CGFloat? {
        guard case .view(let view) = key(sections[section]), let value = view.height
            else { return nil }
        return value.height()
    }
    
    fileprivate func height(at indexPath: IndexPath) -> CGFloat? {
        guard let value = item(at: indexPath).height else { return nil }
        return value.height()
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
        let currentItem = item(at: indexPath)
        let drawer = currentItem.drawer
        
        let cell = drawer.cell(in: self, with: currentItem, for: indexPath)
        drawer.draw(cell, with: currentItem)
        
        return cell
    }
    
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return title(for: {$0.header}, inSection: section)
    }
    
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return title(for: {$0.footer}, inSection: section)
    }
    
    
}

extension TableViewManager: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let currentItem = item(at: indexPath) as? Selectable else { return }
        currentItem.onSelection(currentItem)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return height(at: indexPath) ?? tableView.rowHeight
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return height(for: {$0.header}, inSection: section) ?? tableView.sectionHeaderHeight
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return height(for: {$0.footer}, inSection: section) ?? tableView.sectionFooterHeight
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return estimatedHeight(at: indexPath) ?? tableView.estimatedRowHeight
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return estimatedHeight(for: {$0.header}, inSection: section) ?? tableView.estimatedSectionHeaderHeight
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return estimatedHeight(for: {$0.footer}, inSection: section) ?? tableView.estimatedSectionHeaderHeight
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return view(for: {$0.header}, inSection: section)
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return view(for: {$0.footer}, inSection: section)
    }
    
}
