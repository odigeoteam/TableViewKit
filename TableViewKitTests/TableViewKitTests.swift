import XCTest
import TableViewKit
import Nimble

@testable import TableViewKit

class TestReloadDrawer: CellDrawer {

    static internal var type = CellType.class(UITableViewCell.self)

    static internal func draw(_ cell: UITableViewCell, with item: Any) {
        // swiftlint:disable:next force_cast
        cell.textLabel?.text = (item as! TestReloadItem).title
    }
}

class TestReloadItem: Item {
    static internal var drawer = AnyCellDrawer(TestReloadDrawer.self)

    internal var title: String?
}

class EqualableItem: TestReloadItem, Equatable {

    init(title: String) {
        super.init()
        self.title = title
    }

    public static func == (lhs: EqualableItem, rhs: EqualableItem) -> Bool {
        return lhs.title == rhs.title
    }
}

class EquatableSection: NoHeaderFooterSection, Equatable {

    public static func == (lhs: EquatableSection, rhs: EquatableSection) -> Bool {
        return lhs === rhs
    }
}

class StatefulSection: HeaderFooterTitleSection, StaticStateful {

    enum State {
        case login, register
    }

    var currentState: StatefulSection.State = .login
    var states: [StatefulSection.State : [Item]] = [:]

    override init() {
        super.init()

        let loginItem = TestReloadItem()
        loginItem.title = "Login"
        states[.login] = [loginItem]

        let registerItem = TestReloadItem()
        registerItem.title = "Register"
        states[.register] = [registerItem]

        transition(to: currentState)
    }
}

class TestRegisterNibCell: UITableViewCell { }
class TestRegisterHeaderFooterView: UITableViewHeaderFooterView { }

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

        expect(tableViewManager.sections.count) == 1
    }

    func testAddItem() {

        let tableViewManager = TableViewManager(tableView: UITableView())

        let item: Item = TestItem()

        let section = HeaderFooterTitleSection()
        section.items.append(item)

        tableViewManager.sections.insert(section, at: 0)

        expect(section.items.count) == 1
        expect(item.section(in: tableViewManager)).notTo(beNil())

        section.items.remove(at: 0)
        section.items.append(item)

        section.items.replace(with: [TestItem(), item])
    }

    func testEqualableItem() {

        let item1 = EqualableItem(title: "Item1")
        let item2 = EqualableItem(title: "Item1")

        XCTAssert(item1.equals(item2))
        XCTAssert(item1.equals("Item3") == false)
    }

    func testEqualableSection() {

        let section1 = EquatableSection()
        let section2 = EquatableSection()

        XCTAssert(section1.equals(section1))
        XCTAssert(section1.equals(section2) == false)
        XCTAssert(section2.equals(nil) == false)
    }

    func testEqualItem() {

        let item1 = TestItem()
        let item2 = TestItem()

        XCTAssert(item1.equals(item2) == false)
        XCTAssert(item1.equals(nil) == false)
    }

    func testEqualSection() {

        let section1 = NoHeaderFooterSection()
        let section2 = NoHeaderFooterSection()

        XCTAssert(section1.equals(section2) == false)
        XCTAssert(section1.equals(nil) == false)
    }

    func testRetainCycle() {
        let tableViewManager = TableViewManager(tableView: UITableView())
        tableViewManager.sections.insert(HeaderFooterTitleSection(items: [TestItem()]), at: 0)

        weak var section: Section? = tableViewManager.sections.first
        weak var item: Item? = section!.items.first
        expect(section).toNot(beNil())
        expect(item).toNot(beNil())
        tableViewManager.sections.replace(with: [HeaderFooterTitleSection()])
        expect(section).to(beNil())
        expect(item).to(beNil())
    }

    func testConvenienceInit() {
        let tableViewManager = TableViewManager(tableView: UITableView(), sections: [HeaderFooterTitleSection()])

        expect(tableViewManager.sections.count) == 1
    }

    func testUpdateRow() {

        let item = TestReloadItem()
        item.title = "Before"

        let section = HeaderFooterTitleSection(items: [item])
        let tableViewManager = TableViewManager(tableView: UITableView(), sections: [section])

        guard let indexPath = item.indexPath(in: tableViewManager) else { return }
		let dataSource = tableViewManager.tableView.dataSource as! TableViewKitDataSource
        var cell = dataSource.tableView(tableViewManager.tableView, cellForRowAt: indexPath)

        expect(cell.textLabel?.text) == item.title

        item.title = "After"
        item.reload(in: tableViewManager)

        cell = dataSource.tableView(tableViewManager.tableView, cellForRowAt: indexPath)

        expect(cell.textLabel?.text) == item.title
    }

    func testMoveRows() {

        let tableView = UITableView()

        let item1 = TestItem()
        let item2 = TestItem()

        let section = NoHeaderFooterSection(items: [item1, item2])
        let tableViewManager = TableViewManager(tableView: tableView, sections: [section])

        var indexPathItem1 = item1.indexPath(in: tableViewManager)
        var indexPathItem2 = item2.indexPath(in: tableViewManager)

        XCTAssertNotNil(indexPathItem1)
        XCTAssertNotNil(indexPathItem2)

        section.items.replace(with: [item2, item1])

        indexPathItem1 = item1.indexPath(in: tableViewManager)
        indexPathItem2 = item2.indexPath(in: tableViewManager)

        XCTAssert(indexPathItem2?.item == 0)
        XCTAssert(indexPathItem1?.item == 1)
    }

    func testMoveSections() {

        let tableView = UITableView()

        let section1 = NoHeaderFooterSection()
        let section2 = NoHeaderFooterSection()

        let tableViewManager = TableViewManager(tableView: tableView, sections: [section1, section2])

        XCTAssert(section1.index(in: tableViewManager) == 0)
        XCTAssert(section2.index(in: tableViewManager) == 1)

        tableViewManager.sections.replace(with: [section2, section1])

        XCTAssert(section1.index(in: tableViewManager) == 1)
        XCTAssert(section2.index(in: tableViewManager) == 0)
    }

    func testNoCrashOnNonAddedItem() {
        let tableViewManager = TableViewManager(tableView: UITableView(), sections: [HeaderFooterTitleSection()])

        let item: Item = TestReloadItem()
        item.reload(in: tableViewManager, with: .automatic)

        let section = item.section(in: tableViewManager)
        expect(section).to(beNil())
    }

    func testRegisterNibCells() {

        let testBundle = Bundle(for: TableViewKitTests.self)
        // swiftlint:disable:next line_length
        let cellType = CellType<UITableViewCell>.nib(UINib(nibName: String(describing: TestRegisterNibCell.self), bundle: testBundle), TestRegisterNibCell.self)

        let tableView = UITableView()
        tableView.register(cellType)

        let cell = tableView.dequeueReusableCell(withIdentifier: cellType.reusableIdentifier)

        expect(cell).toNot(beNil())
    }

    func testRegisterNibHeaderFooter() {

        let testBundle = Bundle(for: TableViewKitTests.self)
        let nib = UINib(nibName: String(describing: TestRegisterHeaderFooterView.self), bundle: testBundle)
        let headerFooterType = HeaderFooterType<UITableViewHeaderFooterView>.nib(nib, TestRegisterHeaderFooterView.self)

        let tableView = UITableView()
        tableView.register(headerFooterType)

        // swiftlint:disable:next line_length
        let headerFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerFooterType.reusableIdentifier)
        expect(headerFooterView).toNot(beNil())
    }

	func testNibClassTypeCells() {
		let testBundle = Bundle(for: TableViewKitTests.self)
        let nib = UINib(nibName: String(describing: TestRegisterNibCell.self), bundle: testBundle)
		let type = CellType<TestRegisterNibCell>.nib(nib, TestRegisterNibCell.self)
		_ = type.cellType
	}

	func testNibClassTypeHeaderFooter() {
		let testBundle = Bundle(for: TableViewKitTests.self)
        let nib = UINib(nibName: String(describing: TestRegisterHeaderFooterView.self), bundle: testBundle)
		let type = HeaderFooterType<TestRegisterHeaderFooterView>.nib(nib, TestRegisterHeaderFooterView.self)
		_ = type.headerFooterType
	}

    func testLoginState() {

        let section = StatefulSection()
        XCTAssert(section.items.count == 1)

        let loginItem = section.items.first as? TestReloadItem
        XCTAssert(loginItem?.title == "Login")
    }

    func testRegisterState() {

        let section = StatefulSection()
        section.transition(to: .register)

        XCTAssert(section.items.count == 1)

        let registerItem = section.items.first as? TestReloadItem
        XCTAssert(registerItem?.title == "Register")
    }
}
