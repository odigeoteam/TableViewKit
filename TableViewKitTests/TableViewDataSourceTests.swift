import XCTest
@testable import TableViewKit
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

class HeaderFooterTitleSection: TableSection {
    var items: ObservableArray<TableItem> = []
    weak var tableViewManager: TableViewManager!

    internal var header: HeaderFooterView { return .title("Header") }
    internal var footer: HeaderFooterView { return .title("Footer") }

    convenience init(items: [TableItem]) {
        self.init()
        self.items.insert(contentsOf: items, at: 0)
    }
}

class TestDrawer: CellDrawer {
    static internal var type = CellType.class(TestCell.self)
    static internal func draw(_ cell: TestCell, with item: TableItem) { }
}

class TestItem: TableItem, Selectable {
    static internal var drawer = AnyCellDrawer(TestDrawer.self)

    public func didSelect() {
        print("didSelect called")
    }

}

class TestCell: UITableViewCell, ItemCompatible {
    internal var item: TableItem?
}

class DifferentItem: TableItem {

    static var drawer = AnyCellDrawer(DifferentDrawer.self)
}

class DifferentDrawer: CellDrawer {
    static var type: NibClassType<DifferentCell> = CellType.class(DifferentCell.self)
    static func draw(_ cell: DifferentCell, with item: DifferentItem) {}
}

class DifferentCell: UITableViewCell { }

class TableViewDataSourceTests: XCTestCase {

    fileprivate var tableViewManager: TableViewManager!
    fileprivate var dataSource: TableViewKitDataSource { return tableViewManager.dataSource! }

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
        let cell = dataSource.tableView(self.tableViewManager.tableView, cellForRowAt: indexPath)

        expect(cell).to(beAnInstanceOf(TestCell.self))
    }

    func testDequeueCellAfterRegisterSection() {

        guard let section = tableViewManager.sections.first else {
            fatalError("Couldn't get the first section")
        }

        let otherItem = DifferentItem()
        section.items.append(otherItem)

        let indexPath = otherItem.indexPath!
        let drawer = type(of: otherItem).drawer
        let cell = drawer.cell(in: tableViewManager, with: otherItem as TableItem, for: indexPath)

        XCTAssertTrue(cell is DifferentCell)
    }

    func testNumberOfSections() {
        let count = dataSource.numberOfSections(in: self.tableViewManager.tableView)
        expect(count) == 2
    }

    func testNumberOfRowsInSection() {
        let count = dataSource.tableView(self.tableViewManager.tableView, numberOfRowsInSection: 0)
        expect(count) == 1
    }

    func testTitleForHeaderInSection() {
        let title = dataSource.tableView(self.tableViewManager.tableView, titleForHeaderInSection: 0)!
        let section = tableViewManager.sections.first!

        expect(HeaderFooterView.title(title)) == section.header
    }

    func testTitleForFooterInSection() {
        var title: String?

        title = dataSource.tableView(self.tableViewManager.tableView, titleForFooterInSection: 0)

        let section = tableViewManager.sections.first!
        expect(HeaderFooterView.title(title!)) == section.footer

        title = dataSource.tableView(self.tableViewManager.tableView, titleForFooterInSection: 1)
        expect(title).to(beNil())
    }

}
