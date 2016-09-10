//
//  TableViewManager.swift
//  TableViewKit
//
//  Created by Nelson Dominguez Leon on 07/06/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import Foundation
import UIKit

public class TableViewManager: NSObject {

    // MARK: Properties
    public let tableView: UITableView
    public var sections: ObservableArray<Section> = []

    public var validator: ValidatorManager<String?> = ValidatorManager()
    public var errors: [ValidationError] {
        get {
            return validator.errors
        }
    }


    // MARK: Inits

    public init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        self.tableView.dataSource = self
        self.tableView.delegate = self

        sections.callback = { change in

            switch change {
            case .inserts(let array):
                array.forEach { index in
                    self.sections[index].setup(inManager: self)
                    self.sections[index].register(inManager: self)
                }
                tableView.insertSections(NSIndexSet(array), withRowAnimation: .Automatic)
            case .deletes(let array):
                tableView.deleteSections(NSIndexSet(array), withRowAnimation: .Automatic)
            case .updates(let array):
                tableView.reloadSections(NSIndexSet(array), withRowAnimation: .Automatic)
            case .moves(_): break
            case .beginUpdates:
                tableView.beginUpdates()
            case .endUpdates:
                tableView.endUpdates()
            }

        }
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
    
    private func view(forKey key: (Section) -> HeaderFooterView, inSection section: Int) -> UIView? {
        guard case .view(let item) = key(sections[section]) else { return nil }
        
        let drawer = item.drawer
        let view = drawer.view(inManager: self, withItem: item)
        drawer.draw(view, withItem: item)
        
        return view
    }
    
    private func title(forKey key: (Section) -> HeaderFooterView, inSection section: Int) -> String? {
        if case .title(let value) = key(sections[section]) {
            return value
        }
        return nil

    }
    
    private func estimatedHeight(forKey key: (Section) -> HeaderFooterView, inSection section: Int) -> CGFloat? {
        guard case .view(let view) = key(sections[section]), let height = view.height
            else { return nil }
        return estimatedHeight(height)
    }
    
    private func estimatedHeight(atIndexPath indexPath: NSIndexPath) -> CGFloat? {
        guard let height = item(forIndexPath: indexPath).height else { return nil }
        return estimatedHeight(height)
    }
    
    private func estimatedHeight(height: ImmutableMutableHeight) -> CGFloat {
        switch height {
        case .immutable(_):
            return 0.0
        case .mutable(let value):
            return value
        }
    }
    
    private func height(forKey key: (Section) -> HeaderFooterView, inSection section: Int) -> CGFloat? {
        guard case .view(let view) = key(sections[section]), let value = view.height
            else { return nil }
        return height(value)
    }
    
    private func height(atIndexPath indexPath: NSIndexPath) -> CGFloat? {
        guard let value = item(forIndexPath: indexPath).height else { return nil }
        return height(value)
    }

    
    private func height(height: ImmutableMutableHeight) -> CGFloat {
        switch height {
        case .immutable(let value):
            return value
        case .mutable(_):
            return UITableViewAutomaticDimension
        }
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
        return title(forKey: {$0.header}, inSection: section)
    }


    public func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return title(forKey: {$0.footer}, inSection: section)
    }


}

extension TableViewManager: UITableViewDelegate {

    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let currentItem = item(forIndexPath: indexPath) as? Selectable else { return }
        currentItem.onSelection(currentItem)
    }

    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return height(atIndexPath: indexPath) ?? tableView.rowHeight
    }

    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return height(forKey: {$0.header}, inSection: section) ?? tableView.sectionHeaderHeight
    }

    public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return height(forKey: {$0.footer}, inSection: section) ?? tableView.sectionFooterHeight
    }

    public func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return estimatedHeight(atIndexPath: indexPath) ?? tableView.estimatedRowHeight
    }

    public func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return estimatedHeight(forKey: {$0.header}, inSection: section) ?? tableView.estimatedSectionHeaderHeight
    }

    public func tableView(tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return estimatedHeight(forKey: {$0.footer}, inSection: section) ?? tableView.estimatedSectionHeaderHeight
    }

    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return view(forKey: {$0.header}, inSection: section)
    }

    public func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return view(forKey: {$0.footer}, inSection: section)
    }
    
}
