import XCTest
import TableViewKit
import Nimble

extension HeaderFooterView: Equatable {
    public static func == (lhs: HeaderFooterView, rhs: HeaderFooterView) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none):
            return true
        case (.view(let lhs), .view(let rhs)):
            return lhs === rhs
        case (.title(let lhs), .title(let rhs)):
            return lhs == rhs
        default:
            return false
        }
    }
}

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
    
    static internal var type = CellType.class(TestCell.self)
    static internal func draw(_ cell: UITableViewCell, with item: Any) { }
}

class TestItem: Item, Selectable {

    public func didSelect() {
        print("didSelect called")
    }

    internal var drawer: CellDrawer.Type = TestDrawer.self
}

class TestCell: UITableViewCell, ItemCompatible {
    internal var item: Item?
}

class DifferentItem: Item {
    
    var drawer: CellDrawer.Type = DifferentDrawer.self
}

class DifferentDrawer: CellDrawer {
    
    static var type: CellType = CellType.class(DifferentCell.self)
    static func draw(_ cell: UITableViewCell, with item: Any) {}
}

class DifferentCell: UITableViewCell { }

class TableViewDataSourceTests: XCTestCase {
    
    fileprivate var tableViewManager: TableViewManager!
    
    override func setUp() {
        super.setUp()
        
        let section1 = HeaderFooterTitleSection(items: [TestItem()])
        let section2 = ViewHeaderFooterSection(items: [NoHeigthItem(), StaticHeigthItem()])
        
        tableViewManager = TableViewManager(tableView: UITableView(), sections: [section1, section2])
    }

    override func tearDown() {
        tableViewManager = nil
        super.tearDown()
    }
    
    func testCellForRow() {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.tableViewManager.tableView(self.tableViewManager.tableView, cellForRowAt: indexPath)
        
        expect(cell).to(beAnInstanceOf(TestCell.self))
    }
    
    func testDequeueCellAfterRegisterSection() {
        
        guard let section = tableViewManager.sections.first else {
            fatalError("Couldn't get the first section")
        }
        
        let otherItem = DifferentItem()
        section.items.append(otherItem)
        
        let indexPath = otherItem.indexPath(in: tableViewManager)!
        let cell = otherItem.drawer.cell(in: tableViewManager, with: otherItem, for: indexPath)
        
        XCTAssertTrue(cell is DifferentCell)
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
        let title = self.tableViewManager.tableView(self.tableViewManager.tableView, titleForHeaderInSection: 0)!
        let section = tableViewManager.sections.first!
        
        expect(HeaderFooterView.title(title)).to(equal(section.header))
    }
    
    func testTitleForFooterInSection() {
        var title: String?
        
        title = self.tableViewManager.tableView(self.tableViewManager.tableView, titleForFooterInSection: 0)
        
        let section = tableViewManager.sections.first!
        expect(HeaderFooterView.title(title!)).to(equal(section.footer))
        
        title = self.tableViewManager.tableView(self.tableViewManager.tableView, titleForFooterInSection: 1)
        expect(title).to(beNil())
    }
    
    func testViewForHeaderInSection() {
        let view = self.tableViewManager.tableView(self.tableViewManager.tableView, viewForHeaderInSection: 0)
        expect(view).to(beNil())
    }
    
    func testViewForFooterInSection() {
        var view: UIView?
        view = self.tableViewManager.tableView(self.tableViewManager.tableView, viewForFooterInSection: 0)
        expect(view).to(beNil())
    
        view = self.tableViewManager.tableView(self.tableViewManager.tableView, viewForFooterInSection: 1)
        expect(view).notTo(beNil())
    }
}
