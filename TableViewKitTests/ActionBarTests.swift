//
//  ActionBarTests.swift
//  TableViewKit
//
//  Created by Alfredo Delli Bovi on 28/08/16.
//  Copyright © 2016 odigeo. All rights reserved.
//

import XCTest


import XCTest
import TableViewKit
import Nimble

extension UIView {
    func currentFirstResponder() -> UIResponder? {
        if self.isFirstResponder() {
            return self
        }
        
        for view in self.subviews {
            if let responder = view.currentFirstResponder() {
                return responder
            }
        }
        
        return nil
    }
}

class ActionBarTests: XCTestCase {
    
    private var tableViewManager: TableViewManager!
    
    override func setUp() {
        super.setUp()
        let controller = UITableViewController(style: .Plain)
        tableViewManager = TableViewManager(tableView: controller.tableView)
        
        tableViewManager.sections.append(
            Section(items: [TextFieldItem(placeHolder: "0.0"), TextFieldItem(placeHolder: "0.1")])
            )
        tableViewManager.sections.append(
            Section(items: [TextFieldItem(placeHolder: "1.0")])
            )
        tableViewManager.tableView.reloadData()
    }
    
    override func tearDown() {
        tableViewManager = nil
        super.tearDown()
    }
    
    func testActionBar() {
        var cell: BaseCell
        cell = tableViewManager.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! BaseCell
        
        expect(cell.actionBar(cell.actionBar, direction: .next)).to(equal(NSIndexPath(forRow: 1, inSection: 0)))
        
        tableViewManager.sections.collection.first!.items.removeAtIndex(0)
        
        cell = tableViewManager.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! BaseCell

        expect(cell.actionBar(cell.actionBar, direction: .next)).to(equal(NSIndexPath(forRow: 0, inSection: 1)))

    }
    
    
}
