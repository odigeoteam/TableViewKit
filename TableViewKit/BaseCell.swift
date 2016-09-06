//
//  TableViewCell.swift
//  TableViewKit
//
//  Created by Nelson Dominguez Leon on 08/06/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import Foundation
import UIKit

public class BaseCell: UITableViewCell {

    // MARK: Public

    weak public var tableViewManager: TableViewManager!
    public var item: Item?

    public var responder: UIResponder?

    public var actionBar: ActionBar!


    // MARK: Constructors

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    public override required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    // MARK: Configure

    public func commonInit() {
        actionBar = ActionBar(delegate: self)
    }

    public override func canBecomeFirstResponder() -> Bool {
        guard let responder = responder else { return false }
        return responder.canBecomeFirstResponder()
    }

    public override func becomeFirstResponder() -> Bool {
        guard let responder = responder else { return false }
        return responder.becomeFirstResponder()
    }

    public override func isFirstResponder() -> Bool {
        guard let responder = responder else { return false }
        return responder.isFirstResponder()
    }

}

extension BaseCell: ActionBarDelegate {

    private func indexPathForPreviousResponderInSectionIndex(sectionIndex: Int) -> NSIndexPath? {

        guard let item = self.item else { return nil }

        let section = tableViewManager.sections[sectionIndex]
        let indexInSection = section === item.section(inManager: tableViewManager) ? section.items.indexOf(item) : section.items.count

        guard indexInSection > 0 else { return nil }

        for itemIndex in (0 ..< indexInSection!).reverse() {
            let previousItem = section.items[itemIndex]
            guard let indexPath = previousItem.indexPath(inManager: tableViewManager),
                let cell = tableViewManager.tableView.cellForRowAtIndexPath(indexPath)
                else { continue }
            if cell.canBecomeFirstResponder() {
                return indexPath
            }

        }

        return nil
    }

    private func indexPathForPreviousResponder() -> NSIndexPath? {
        guard let sectionIndex = item?.indexPath(inManager: tableViewManager)?.section else { return nil }


        for index in (0 ... sectionIndex).reverse() {
            if let indexPath = indexPathForPreviousResponderInSectionIndex(index) {
                return indexPath
            }
        }

        return nil
    }

    private func indexPathForNextResponderInSectionIndex(sectionIndex: Int) -> NSIndexPath? {

        let section = tableViewManager.sections[sectionIndex]
        let indexInSection = section === item!.section(inManager: tableViewManager) ? section.items.indexOf(item!) : -1

        for itemIndex in indexInSection! + 1 ..< section.items.count {
            let nextItem = section.items[itemIndex]
            guard let indexPath = nextItem.indexPath(inManager: tableViewManager),
                let cell = tableViewManager.tableView.cellForRowAtIndexPath(indexPath)
                else { continue }
            if cell.canBecomeFirstResponder() {
                return indexPath
            }
        }

        return nil
    }

    private func indexPathForNextResponder() -> NSIndexPath? {
        guard let sectionIndex = item?.indexPath(inManager: tableViewManager)?.section else { return nil }

        for index in sectionIndex ... tableViewManager.sections.count - 1 {
            if let indexPath = indexPathForNextResponderInSectionIndex(index) {
                return indexPath
            }
        }

        return nil
    }

    private func indexPathForResponder(forDirection direction: Direction) -> NSIndexPath? {

        switch direction {
        case .next:
            return indexPathForNextResponder()
        case .previous:
            return indexPathForPreviousResponder()
        }
    }

    public func actionBar(actionBar: ActionBar, direction: Direction) -> NSIndexPath? {
        guard let indexPath = indexPathForResponder(forDirection: direction) else { return nil }
        tableViewManager.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)

        let cell = tableViewManager.tableView.cellForRowAtIndexPath(indexPath) as! BaseCell
        cell.becomeFirstResponder()
        return indexPath
    }

    public func actionBar(actionBar: ActionBar, doneButtonPressed doneButtonItem: UIBarButtonItem) {
        endEditing(true)
    }
}
