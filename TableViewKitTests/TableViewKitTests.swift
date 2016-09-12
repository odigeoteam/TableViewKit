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
    
    static internal var type = CellType.class(BaseCell.self)
    
    static internal func draw(_ cell: BaseCell, with item: Any) {
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
        expect(item.section(in: tableViewManager)).notTo(beNil())
        
        section.items.remove(at: 0)
        section.items.append(item)
        
        section.items.replace(with: [TestItem(), item])
    }
    
    func testConvenienceInit() {
        let tableViewManager = TableViewManager(tableView: UITableView(), with: [HeaderFooterTitleSection()])
        
        expect(tableViewManager.sections.count).to(equal(1))
    }
    
    func testUpdateRow() {
        
        let item = TestReloadItem()
        item.title = "Before"
        
        let section = HeaderFooterTitleSection(items: [item])
        let tableViewManager = TableViewManager(tableView: UITableView(), with: [section])
        
        guard let indexPath = item.indexPath(in: tableViewManager) else { return }
        var cell = tableViewManager.tableView(tableViewManager.tableView, cellForRowAt: indexPath)
        
        expect(cell.textLabel?.text).to(equal(item.title))
        
        item.title = "After"
        cell = tableViewManager.tableView(tableViewManager.tableView, cellForRowAt: indexPath)
        
        expect(cell.textLabel?.text).to(equal(item.title))
    }

    func testNoCrashOnNonAddedItem() {
        let tableViewManager = TableViewManager(tableView: UITableView(), with: [HeaderFooterTitleSection()])

        let item: Item = TestReloadItem()
        item.reload(in: tableViewManager, with: .automatic)
        
        let section = item.section(in: tableViewManager)
        expect(section).to(beNil())
    }
}
