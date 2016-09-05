//
//  TableViewDataSourceTests.swift
//  TableViewKit
//
//  Created by Alfredo Delli Bovi on 28/08/16.
//  Copyright © 2016 odigeo. All rights reserved.
//

import XCTest
import TableViewKit
import Nimble
import ReactiveKit
import Bond

class TestSection: Section {
    var items: MutableObservableArray<Item> = MutableObservableArray([])
    weak var tableViewManager: TableViewManager!
    
    internal var headerTitle: String? { return "Header" }
    internal var footerTitle: String? { return "Footer" }

    convenience init(items: [Item]) {
        self.init()
        self.items.insert(contentsOf: items, at: 0)
    }
}

class TestDrawer: CellDrawer {
    
    static internal var cellType = CellType.class(BaseCell.self)
    
    static internal func draw(_ cell: BaseCell, withItem item: Any) {    }
}

class TestItem: Item {
    internal var drawer: CellDrawer.Type = TestDrawer.self
}

class TableViewDataSourceTests: XCTestCase {
    
    fileprivate var tableViewManager: TableViewManager!
    fileprivate var item: Item!
    fileprivate var section: Section!
    
    override func setUp() {
        super.setUp()
        tableViewManager = TableViewManager(tableView: UITableView())
        item = TestItem()
        
        section = TestSection()
        section.items.insert(item, at: 0)
        
        tableViewManager.sections.insert(section, at: 0)

    }

    
    override func tearDown() {
        tableViewManager = nil
        item = nil
        super.tearDown()
    }
    
    func testCellForRow() {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.tableViewManager.tableView(self.tableViewManager.tableView, cellForRowAt: indexPath)
        
        expect(cell).to(beAnInstanceOf(BaseCell.self))
    }
    
    func testNumberOfSections() {
        let count = self.tableViewManager.numberOfSections(in: self.tableViewManager.tableView)
        expect(count) == 1
    }
    
    func testNumberOfRowsInSection() {
        let count = self.tableViewManager.tableView(self.tableViewManager.tableView, numberOfRowsInSection: 0)
        expect(count) == 1
    }
    
    func testTitleForHeaderInSection() {
        let title = self.tableViewManager.tableView(self.tableViewManager.tableView, titleForHeaderInSection: 0)
        expect(title).to(equal(section.headerTitle))
    }
    
    func testTitleForFooterInSection() {
        let title = self.tableViewManager.tableView(self.tableViewManager.tableView, titleForFooterInSection: 0)
        expect(title).to(equal(section.footerTitle))
    }
    
    func testViewForHeaderInSection() {
        let view = self.tableViewManager.tableView(self.tableViewManager.tableView, viewForHeaderInSection: 0)
        expect(view).to(beNil())
    }
    
    func testViewForFooterInSection() {
        let view = self.tableViewManager.tableView(self.tableViewManager.tableView, viewForFooterInSection: 0)
        expect(view).to(beNil())
    }
    
    func testEstimatedHeightForRowAtIndexPath() {
        let indexPath = IndexPath(row: 0, section: 0)
        let height = self.tableViewManager.tableView(self.tableViewManager.tableView, estimatedHeightForRowAt: indexPath)
        expect(height).to(equal(44.0))
    }
    
    
    func testHeightForRowAtIndexPath() {
        let indexPath = IndexPath(row: 0, section: 0)
        let height = self.tableViewManager.tableView(self.tableViewManager.tableView, heightForRowAt: indexPath)
        expect(height).to(equal(UITableViewAutomaticDimension))
    }
    
}
