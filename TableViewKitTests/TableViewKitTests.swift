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

class TestReloadItem: TableItem {
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
    var states: [StatefulSection.State: [TableItem]] = [:]

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

class TestRegisterPrototypeTableView: UITableView {

    var registedCell = false

    override func register(_ cellClass: Swift.AnyClass?, forCellReuseIdentifier identifier: String) {
        registedCell = true
    }

    override func register(_ nib: UINib?, forHeaderFooterViewReuseIdentifier identifier: String) {
        registedCell = true
    }

    override func register(_ aClass: Swift.AnyClass?, forHeaderFooterViewReuseIdentifier identifier: String) {
        registedCell = true
    }
}

class TableViewKitTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
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

    func testRegisterPrototypeCells() {
        let cellType = CellType<UITableViewCell>.prototype("testReuseIdentifier", UITableViewCell.self)

        let tableView = TestRegisterPrototypeTableView()
        tableView.register(cellType)

        expect(tableView.registedCell) == false
    }

    func testRegisterPrototypeHeaderFooter() {

        // swiftlint:disable:next line_length
        let headerFooterType = HeaderFooterType<UITableViewHeaderFooterView>.prototype("testReuseIdentifier", UITableViewHeaderFooterView.self)

        let tableView = TestRegisterPrototypeTableView()
        tableView.register(headerFooterType)

        expect(tableView.registedCell) == false
    }

    func testPrototypeClassTypeCells() {
        let type = CellType<UITableViewCell>.prototype("testReuseIdentifier", UITableViewCell.self)
        _ = type.cellType
    }

    func testPrototypeClassTypeHeaderFooter() {
        // swiftlint:disable:next line_length
        let type = HeaderFooterType<UITableViewHeaderFooterView>.prototype("testReuseIdentifier", UITableViewHeaderFooterView.self)
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

    func testTableViewKitViewControllerInit() {
        let tableView = UITableView()
        let viewController = TableViewKitViewController()
        viewController.tableView = tableView

        viewController.viewDidLoad()

        expect(viewController.tableViewManager).toNot(beNil())
        expect(viewController.tableView) == tableView
    }

}
