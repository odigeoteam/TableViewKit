//
//  TableViewKitTests.swift
//  TableViewKitTests
//
//  Created by Nelson Dominguez Leon on 29/06/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import XCTest
import TableViewKit
import Nimble

@testable import TableViewKit

class TableViewKitTests: XCTestCase {
    
    private var tableViewManager: TableViewManager!
    
    override func setUp() {
        
        super.setUp()
        
        tableViewManager = TableViewManager(tableView: UITableView(), delegate: nil)
    }
    
    override func tearDown() {
        
        tableViewManager = nil
        
        super.tearDown()
    }
    
    func testAddSection() {
        
        let section = TableViewSection()
        tableViewManager.addSection(section)
        
        expect(self.tableViewManager.sections.count).to(equal(1))
    }
    
    func testAddItem() {
        
        let item = TableViewItem()
        
        let section = TableViewSection()
        section.addItem(item)
        
        expect(section.items.count).to(equal(1))
        expect(item.section).notTo(beNil())
    }
}
