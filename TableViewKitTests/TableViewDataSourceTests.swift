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

class HeaderFooterTitleSection: Section {
    var items: ObservableArray<Item> = []
    weak var tableViewManager: TableViewManager!
    
    internal var header: HeaderFooterView { return .title("Header") }
    internal var footer: HeaderFooterView { return .title("Footer") }

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
        
        section = HeaderFooterTitleSection()
        section.items.append(item)
        
        tableViewManager.sections.append(section)
        
        tableViewManager.sections.append(ViewHeaderFooterSection(items: [NoHeigthItem(), StaticHeigthItem()]))

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
        expect(count).to(equal(2))
    }
    
    func testNumberOfRowsInSection() {
        let count = self.tableViewManager.tableView(self.tableViewManager.tableView, numberOfRowsInSection: 0)
        expect(count) == 1
    }
    
    func testTitleForHeaderInSection() {
        let title = self.tableViewManager.tableView(tableView: self.tableViewManager.tableView, titleForHeaderInSection: 0)!
        expect(HeaderFooterView.title(title)).to(equal(section.header))
    }
    
    func testTitleForFooterInSection() {
        var title: String?
        
        title = self.tableViewManager.tableView(tableView: self.tableViewManager.tableView, titleForFooterInSection: 0)
        expect(HeaderFooterView.title(title!)).to(equal(section.footer))
        
        title = self.tableViewManager.tableView(tableView: self.tableViewManager.tableView, titleForFooterInSection: 1)
        expect(title).to(beNil())

    }
    
    func testViewForHeaderInSection() {
        let view = self.tableViewManager.tableView(tableView: self.tableViewManager.tableView, viewForHeaderInSection: 0)
        expect(view).to(beNil())
    }
    
    func testViewForFooterInSection() {
        var view: UIView?
        view = self.tableViewManager.tableView(tableView: self.tableViewManager.tableView, viewForFooterInSection: 0)
        expect(view).to(beNil())
    
        view = self.tableViewManager.tableView(tableView: self.tableViewManager.tableView, viewForFooterInSection: 1)
        expect(view).notTo(beNil())
    
    }
    
}
