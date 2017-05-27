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

class CustomHeaderFooterView: UITableViewHeaderFooterView {
    var label: UILabel = UILabel()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CustomHeaderDrawer: HeaderFooterDrawer {

    static public var type = HeaderFooterType.class(CustomHeaderFooterView.self)

    static public func draw(_ view: CustomHeaderFooterView, with item: ViewHeaderFooter) {
        view.label.text = item.title
    }
}

class ViewHeaderFooter: HeaderFooter {

    public var title: String?
    public var height: Height? = .dynamic(44.0)
    static public var drawer = AnyHeaderFooterDrawer(CustomHeaderDrawer.self)

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
    static internal var drawer = AnyCellDrawer(TestDrawer.self)

    internal var height: Height?
}

class StaticHeigthItem: Item {
    static let testStaticHeightValue: CGFloat = 20.0
    static internal var drawer = AnyCellDrawer(TestDrawer.self)

    internal var height: Height? = .static(20.0)
}

class SelectableItem: Selectable, Item {
    static internal var drawer = AnyCellDrawer(TestDrawer.self)

    public var check: Int = 0

    public init() {}

    func didSelect() {
        check += 1
    }
}

class EditableItem: SelectableItem, Editable {
    public var actions: [UITableViewRowAction]?
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

        height = tableViewManager.tableView(tableViewManager.tableView, estimatedHeightForHeaderInSection: 0)
        expect(height) > 0.0

        height = tableViewManager.tableView(tableViewManager.tableView, estimatedHeightForHeaderInSection: 1)
        expect(height) == tableViewManager.tableView.estimatedSectionHeaderHeight
    }

    func testHeightForHeader() {
        var height: CGFloat

        height = tableViewManager.tableView(tableViewManager.tableView, heightForHeaderInSection: 0)
        expect(height) == UITableViewAutomaticDimension
    }

    func testEstimatedHeightForFooter() {
        var height: CGFloat

        height = tableViewManager.tableView(tableViewManager.tableView, estimatedHeightForFooterInSection: 0)
        expect(height) > 0.0

        height = tableViewManager.tableView(tableViewManager.tableView, estimatedHeightForFooterInSection: 1)
        expect(height) == tableViewManager.tableView.estimatedSectionFooterHeight

        height = tableViewManager.tableView(tableViewManager.tableView, estimatedHeightForFooterInSection: 2)
        expect(height) == 44.0
    }

    func testHeightForFooter() {
        var height: CGFloat

        height = tableViewManager.tableView(tableViewManager.tableView, heightForFooterInSection: 0)
        expect(height) == UITableViewAutomaticDimension

        height = tableViewManager.tableView(tableViewManager.tableView, heightForFooterInSection: 2)
        expect(height) == UITableViewAutomaticDimension
    }

    func testEstimatedHeightForRowAtIndexPath() {
        var height: CGFloat
        var indexPath: IndexPath

        indexPath = IndexPath(row: 0, section: 0)
        height = tableViewManager.tableView(tableViewManager.tableView, estimatedHeightForRowAt: indexPath)
        expect(height) == 44.0

        indexPath = IndexPath(row: 0, section: 1)
        height = tableViewManager.tableView(tableViewManager.tableView, estimatedHeightForRowAt: indexPath)
        expect(height) == tableViewManager.tableView.estimatedRowHeight

        indexPath = IndexPath(row: 1, section: 1)
        height = tableViewManager.tableView(tableViewManager.tableView, estimatedHeightForRowAt: indexPath)
        expect(height) == 20.0
    }

    func testHeightForRowAtIndexPath() {
        var height: CGFloat
        var indexPath: IndexPath

        indexPath = IndexPath(row: 0, section: 0)
        height = tableViewManager.tableView(tableViewManager.tableView, heightForRowAt: indexPath)
        expect(height) == UITableViewAutomaticDimension

        indexPath = IndexPath(row: 0, section: 1)
        height = tableViewManager.tableView(tableViewManager.tableView, heightForRowAt: indexPath)
        expect(height) == tableViewManager.tableView.rowHeight

        indexPath = IndexPath(row: 1, section: 1)
        height = tableViewManager.tableView(tableViewManager.tableView, heightForRowAt: indexPath)
        expect(height) == StaticHeigthItem.testStaticHeightValue
    }

    func testSelectRow() {
        var indexPath: IndexPath

        indexPath = IndexPath(row: 0, section: 0)
        tableViewManager.tableView(tableViewManager.tableView, didSelectRowAt: indexPath)

        let section = tableViewManager.sections[0]
        indexPath = IndexPath(row: section.items.count, section: 0)
        let item = SelectableItem()
        section.items.append(item)

        tableViewManager.tableView(tableViewManager.tableView, didSelectRowAt: indexPath)
        expect(item.check) == 1

        item.select(in: tableViewManager, animated: true)
        expect(item.check) == 2

        item.deselect(in: tableViewManager, animated: true)
        expect(item.check) == 2
    }

    func testEditableRows() {
        let section = tableViewManager.sections.first!
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete", handler: { _, _ in
            print("DeleteAction")
        })
        let editableItem = EditableItem()
        editableItem.actions = [deleteAction]
        section.items.append(editableItem)

        let sectionIndex = section.index(in: tableViewManager)!
        let rows = tableViewManager.tableView(tableViewManager.tableView, numberOfRowsInSection: sectionIndex)
        XCTAssert(rows == 2)

        let indexPath = editableItem.indexPath(in: tableViewManager)!
        let actions = tableViewManager.tableView(tableViewManager.tableView, editActionsForRowAt: indexPath)
        XCTAssertNotNil(actions)
        XCTAssert(actions!.count == 1)
    }
}
