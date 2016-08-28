//
//  TableViewKitTests.swift
//  TableViewKitTests
//
//  Created by Alfredo Delli Bovi on 28/08/16.
//  Copyright © 2016 odigeo. All rights reserved.
//

import XCTest
import TableViewKit
import Nimble

@testable import TableViewKit

class TableViewKitTests: XCTestCase {

    private var tableViewManager: TableViewManager!

    override func setUp() {

        super.setUp()

        tableViewManager = TableViewManager(tableView: UITableView())
    }

    override func tearDown() {

        tableViewManager = nil

        super.tearDown()
    }

    func testAddSection() {

        let section = Section()
        tableViewManager.sections.append(section)

        expect(self.tableViewManager.sections.count).to(equal(1))
    }

    func testAddItem() {

        let item: ItemProtocol = CustomItem()

        let section = Section()
        section.items.append(item)

        tableViewManager.sections.append(section)
        
        expect(section.items.count).to(equal(1))
        expect(item.section(inManager: self.tableViewManager)).notTo(beNil())
    }
    
    func testCell() {

        let section = Section()
        section.items.append(CustomItem())
        
        tableViewManager.sections.append(section)
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        let cell = self.tableViewManager.tableView(self.tableViewManager.tableView, cellForRowAtIndexPath: indexPath)
        
        expect(cell).to(beAnInstanceOf(BaseCell))
    }
}
