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

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testAddSection() {
        let tableViewManager = TableViewManager(tableView: UITableView())

        let section = HeaderFooterTitleSection()
        tableViewManager.sections.append(section)

        expect(tableViewManager.sections.count).to(equal(1))
    }

    func testAddItem() {

        let tableViewManager = TableViewManager(tableView: UITableView())

        let item: Item = TestItem()

        let section = HeaderFooterTitleSection()
        section.items.append(item)

        tableViewManager.sections.append(section)
        
        expect(section.items.count).to(equal(1))
        expect(item.section(inManager: tableViewManager)).notTo(beNil())
        
        section.items.remove(at: 0)
        section.items.append(item)
        
        section.items.replace(with: [TestItem(), item])
    }
    
    func testConvenienceInit() {
        let tableViewManager = TableViewManager(tableView: UITableView(), sections: [HeaderFooterTitleSection()])
        
        expect(tableViewManager.sections.count).to(equal(1))
    }

}
