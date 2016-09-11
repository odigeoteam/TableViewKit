//
//  TableViewDelegateTests.swift
//  TableViewKit
//
//  Created by Alfredo Delli Bovi on 10/09/2016.
//  Copyright © 2016 odigeo. All rights reserved.
//

import XCTest
import TableViewKit
import Nimble

class NoHeaderFooterSection: Section {
    var items: ObservableArray<Item> = []
    
    convenience init(items: [Item]) {
        self.init()
        self.items.insert(contentsOf: items, at: 0)
    }
}

public class CustomHeaderFooterView: UITableViewHeaderFooterView {
    var label: UILabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


public class CustomHeaderDrawer: HeaderFooterDrawer {
    
    static public var headerFooterType = HeaderFooterType.class(CustomHeaderFooterView.self)
    
    static public func draw(_ view: UITableViewHeaderFooterView, withItem item: Any) {
        let item = item as! ViewHeaderFooter
        let view = view as! CustomHeaderFooterView
        view.label.text = item.title
    }
}


public class ViewHeaderFooter: HeaderFooter {
    
    public var title: String?
    public var height: ImmutableMutableHeight? = ImmutableMutableHeight.mutable(44.0)
    public var drawer: HeaderFooterDrawer.Type = CustomHeaderDrawer.self
    
    public init() { }
    
    public convenience init(title: String) {
        self.init()
        self.title = title
    }
}

class ViewHeaderFooterSection: Section {
    var items: ObservableArray<Item> = []

    internal var header: HeaderFooterView = .view(ViewHeaderFooter(title: "First Section"))
    internal var footer: HeaderFooterView = .view(ViewHeaderFooter(title: "Section Footer\nHola"))

    convenience init(items: [Item]) {
        self.init()
        self.items.insert(contentsOf: items, at: 0)
    }
}

class NoHeigthItem: Item {
    internal var drawer: CellDrawer.Type = TestDrawer.self
    
    internal var height: ImmutableMutableHeight? = nil
}

class StaticHeigthItem: Item {
    static let testStaticHeightValue: CGFloat = 20.0
    
    internal var drawer: CellDrawer.Type = TestDrawer.self
    
    internal var height: ImmutableMutableHeight? = .immutable(20.0)
}

class SelectableItem: Selectable, Item {
    public var onSelection: (Selectable) -> ()
    
    internal var drawer: CellDrawer.Type = TestDrawer.self
    
    public init(callback: @escaping (Selectable) -> ()) {
        onSelection = callback
    }
}


class TableViewDelegateTests: XCTestCase {
    
    private var tableViewManager: TableViewManager!
    
    override func setUp() {
        super.setUp()
        tableViewManager = TableViewManager(tableView: UITableView())
        
        tableViewManager.sections.append(HeaderFooterTitleSection(items: [TestItem()]))
        tableViewManager.sections.append(NoHeaderFooterSection(items: [NoHeigthItem(), StaticHeigthItem()]))
        tableViewManager.sections.append(ViewHeaderFooterSection(items: [NoHeigthItem(), StaticHeigthItem()]))
        
    }
    
    
    override func tearDown() {
        tableViewManager = nil
        super.tearDown()
    }
    
    func testEstimatedHeightForHeader() {
        var height: CGFloat
        
        height = tableViewManager.tableView(tableView: tableViewManager.tableView, estimatedHeightForHeaderInSection: 0)
        expect(height).to(beGreaterThan(0.0))
        
        height = tableViewManager.tableView(tableView: tableViewManager.tableView, estimatedHeightForHeaderInSection: 1)
        expect(height).to(equal(tableViewManager.tableView.estimatedSectionHeaderHeight))

    }
    
    
    func testHeightForHeader() {
        var height: CGFloat
        
        height = tableViewManager.tableView(tableView: tableViewManager.tableView, heightForHeaderInSection: 0)
        expect(height).to(equal(UITableViewAutomaticDimension))
    }
    
    func testEstimatedHeightForFooter() {
        var height: CGFloat
        
        height = tableViewManager.tableView(tableView: tableViewManager.tableView, estimatedHeightForFooterInSection: 0)
        expect(height).to(beGreaterThan(0.0))
        
        height = tableViewManager.tableView(tableView: tableViewManager.tableView, estimatedHeightForFooterInSection: 1)
        expect(height).to(equal(tableViewManager.tableView.estimatedSectionFooterHeight))
        
        height = tableViewManager.tableView(tableView: tableViewManager.tableView, estimatedHeightForFooterInSection: 2)
        expect(height).to(equal(44.0))


    }
    
    
    func testHeightForFooter() {
        var height: CGFloat
        
        height = tableViewManager.tableView(tableView: tableViewManager.tableView, heightForFooterInSection: 0)
        expect(height).to(equal(UITableViewAutomaticDimension))
        
        height = tableViewManager.tableView(tableView: tableViewManager.tableView, heightForFooterInSection: 2)
        expect(height).to(equal(UITableViewAutomaticDimension))

    }

    
    
    func testEstimatedHeightForRowAtIndexPath() {
        var height: CGFloat
        var indexPath: IndexPath
        
        indexPath = IndexPath(row: 0, section: 0)
        height = tableViewManager.tableView(tableView: tableViewManager.tableView, estimatedHeightForRowAtIndexPath: indexPath)
        expect(height).to(equal(44.0))
        
        indexPath = IndexPath(row: 0, section: 1)
        height = tableViewManager.tableView(tableView: tableViewManager.tableView, estimatedHeightForRowAtIndexPath: indexPath)
        expect(height).to(equal(tableViewManager.tableView.estimatedRowHeight))
        
        indexPath = IndexPath(row: 1, section: 1)
        height = tableViewManager.tableView(tableView: tableViewManager.tableView, estimatedHeightForRowAtIndexPath: indexPath)
        expect(height).to(equal(0.0))


    }
    
    
    func testHeightForRowAtIndexPath() {
        var height: CGFloat
        var indexPath: IndexPath
        
        indexPath = IndexPath(row: 0, section: 0)
        height = tableViewManager.tableView(tableView: tableViewManager.tableView, heightForRowAtIndexPath: indexPath)
        expect(height).to(equal(UITableViewAutomaticDimension))
        
        indexPath = IndexPath(row: 0, section: 1)
        height = tableViewManager.tableView(tableView: tableViewManager.tableView, heightForRowAtIndexPath: indexPath)
        expect(height).to(equal(tableViewManager.tableView.rowHeight))
        
        indexPath = IndexPath(row: 1, section: 1)
        height = tableViewManager.tableView(tableView: tableViewManager.tableView, heightForRowAtIndexPath: indexPath)
        expect(height).to(equal(StaticHeigthItem.testStaticHeightValue))


    }
    
    func testSelectRow() {
        var indexPath: IndexPath
        
        indexPath = IndexPath(row: 0, section: 0)
        tableViewManager.tableView(tableViewManager.tableView, didSelectRowAt: indexPath)
        
        var check = 0;

        let section = tableViewManager.sections[0]
        indexPath = IndexPath(row: section.items.count, section: 0)
        let item = SelectableItem(callback: { _ in
            check += 1
        })
        section.items.append(item)
        
        tableViewManager.tableView(tableViewManager.tableView, didSelectRowAt: indexPath)
        expect(check).to(equal(1))

        item.select(inManager: tableViewManager, animated: true)
        expect(check).to(equal(2))
        
        item.deselect(inManager: tableViewManager, animated: true)
        expect(check).to(equal(2))
    }
    
}
