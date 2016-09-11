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

class TestReloadDrawer: CellDrawer {
    
    static internal var cellType = CellType.class(BaseCell.self)
    
    static internal func draw(_ cell: BaseCell, withItem item: Any) {
        cell.textLabel?.text = (item as! TestReloadItem).title
    }
}

class TestReloadItem: Item {
    internal var drawer: CellDrawer.Type = TestReloadDrawer.self
    internal var title: String?
}


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

        tableViewManager.sections.insert(section, at: 0)
        
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
    
    func testReloadRow() {
        let tableViewManager = TableViewManager(tableView: UITableView())
        
        let item: Item = TestReloadItem()
        (item as! TestReloadItem).title = "Before"
        
        let section = HeaderFooterTitleSection()
        section.items.append(item)
        
        tableViewManager.sections.append(section)
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = tableViewManager.tableView(tableViewManager.tableView, cellForRowAt: indexPath)
        
        expect(cell.textLabel?.text).to(equal("Before"))
        
        (item as! TestReloadItem).title = "After"
        item.reload(inManager: tableViewManager, withAnimation: .automatic)
        
        expect(cell.textLabel?.text).to(equal("After"))
    }

    func testNoCrashOnNonAddedItem() {
        let tableViewManager = TableViewManager(tableView: UITableView(), sections: [HeaderFooterTitleSection()])

        let item: Item = TestReloadItem()
        item.reload(inManager: tableViewManager, withAnimation: .automatic)
        
        let section = item.section(inManager: tableViewManager)
        expect(section).to(beNil())
    }
}
