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

        let section = TestSection()
        tableViewManager.sections.append(section)

        expect(self.tableViewManager.sections.count).to(equal(1))
    }

    func testAddItem() {

        let item: ItemProtocol = TestItem()

        let section = TestSection()
        section.items.append(item)

        tableViewManager.sections.append(section)
        
        expect(section.items.count).to(equal(1))
        expect(item.section(inManager: self.tableViewManager)).notTo(beNil())
    }

}
