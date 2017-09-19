import XCTest
import TableViewKit
import Nimble

class NoHeaderFooterSection: TableSection {
    var items: ObservableArray<TableItem> = []

    convenience init(items: [TableItem]) {
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

class ViewHeaderFooterSection: TableSection {
    var items: ObservableArray<TableItem> = []

    internal var header: HeaderFooterView = .view(ViewHeaderFooter(title: "First Section"))
    internal var footer: HeaderFooterView = .view(ViewHeaderFooter(title: "Section Footer\nHola"))

    convenience init(items: [TableItem]) {
        self.init()
        self.items.insert(contentsOf: items, at: 0)
    }
}

class NoHeigthItem: TableItem {
    static internal var drawer = AnyCellDrawer(TestDrawer.self)

    internal var height: Height?
}

class StaticHeigthItem: TableItem {
    static let testStaticHeightValue: CGFloat = 20.0
    static internal var drawer = AnyCellDrawer(TestDrawer.self)

    internal var height: Height? = .static(20.0)
}

class SelectableItem: Selectable, TableItem {
    static internal var drawer = AnyCellDrawer(TestDrawer.self)

    public var check: Int = 0

    public init() {}

    func didSelect() {
        check += 1
    }
}

class ActionableItem: ActionPerformable, TableItem {
    static internal var drawer = AnyCellDrawer(TestDrawer.self)

    public var check: Int = 0

    public init() {}

    func canPerformAction(_ action: ItemAction) -> Bool {
        return true
    }

    func performAction(_ action: ItemAction) {
        check += 1
    }
}

class EditableItem: SelectableItem, Editable {
    public var actions: [UITableViewRowAction]?
}

class TableViewDelegateTests: XCTestCase {

    fileprivate var tableViewManager: TableViewManager!
    fileprivate var delegate: TableViewKitDelegate { return tableViewManager.delegate! }

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

        height = delegate.tableView(tableViewManager.tableView, estimatedHeightForHeaderInSection: 0)
        expect(height) > 0.0

        height = delegate.tableView(tableViewManager.tableView, estimatedHeightForHeaderInSection: 1)
        expect(height) == tableViewManager.tableView.estimatedSectionHeaderHeight
    }

    func testHeightForHeader() {
        var height: CGFloat

        height = delegate.tableView(tableViewManager.tableView, heightForHeaderInSection: 0)
        expect(height) == UITableViewAutomaticDimension
    }

    func testEstimatedHeightForFooter() {
        var height: CGFloat

        height = delegate.tableView(tableViewManager.tableView, estimatedHeightForFooterInSection: 0)
        expect(height) > 0.0

        height = delegate.tableView(tableViewManager.tableView, estimatedHeightForFooterInSection: 1)
        expect(height) == tableViewManager.tableView.estimatedSectionFooterHeight

        height = delegate.tableView(tableViewManager.tableView, estimatedHeightForFooterInSection: 2)
        expect(height) == 44.0
    }

    func testHeightForFooter() {
        var height: CGFloat

        height = delegate.tableView(tableViewManager.tableView, heightForFooterInSection: 0)
        expect(height) == UITableViewAutomaticDimension

        height = delegate.tableView(tableViewManager.tableView, heightForFooterInSection: 2)
        expect(height) == UITableViewAutomaticDimension
    }

    func testEstimatedHeightForRowAtIndexPath() {
        var height: CGFloat
        var indexPath: IndexPath

        indexPath = IndexPath(row: 0, section: 0)
        height = delegate.tableView(tableViewManager.tableView, estimatedHeightForRowAt: indexPath)
        expect(height) == 44.0

        indexPath = IndexPath(row: 0, section: 1)
        height = delegate.tableView(tableViewManager.tableView, estimatedHeightForRowAt: indexPath)
        expect(height) == tableViewManager.tableView.estimatedRowHeight

        indexPath = IndexPath(row: 1, section: 1)
        height = delegate.tableView(tableViewManager.tableView, estimatedHeightForRowAt: indexPath)
        expect(height) == 20.0
    }

    func testHeightForRowAtIndexPath() {
        var height: CGFloat
        var indexPath: IndexPath

        indexPath = IndexPath(row: 0, section: 0)
        height = delegate.tableView(tableViewManager.tableView, heightForRowAt: indexPath)
        expect(height) == UITableViewAutomaticDimension

        indexPath = IndexPath(row: 0, section: 1)
        height = delegate.tableView(tableViewManager.tableView, heightForRowAt: indexPath)
        expect(height) == tableViewManager.tableView.rowHeight

        indexPath = IndexPath(row: 1, section: 1)
        height = delegate.tableView(tableViewManager.tableView, heightForRowAt: indexPath)
        expect(height) == StaticHeigthItem.testStaticHeightValue
    }

    func testSelectRow() {
        var indexPath: IndexPath

        indexPath = IndexPath(row: 0, section: 0)
        delegate.tableView(tableViewManager.tableView, didSelectRowAt: indexPath)

        let section = tableViewManager.sections[0]
        indexPath = IndexPath(row: section.items.count, section: 0)
        let item = SelectableItem()
        section.items.append(item)

        delegate.tableView(tableViewManager.tableView, didSelectRowAt: indexPath)
        expect(item.check) == 1

        item.select(animated: true)
        expect(item.check) == 2

        item.deselect(animated: true)
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

        let indexPath = editableItem.indexPath!
        let actions = delegate.tableView(tableViewManager.tableView, editActionsForRowAt: indexPath)
        XCTAssertNotNil(actions)
        XCTAssert(actions!.count == 1)
    }

    func testViewForHeaderInSection() {
        let view = delegate.tableView(self.tableViewManager.tableView, viewForHeaderInSection: 0)
        expect(view).to(beNil())
    }

    func testViewForFooterInSection() {
        var view: UIView?
        view = delegate.tableView(self.tableViewManager.tableView, viewForFooterInSection: 0)
        expect(view).to(beNil())

        view = delegate.tableView(self.tableViewManager.tableView, viewForFooterInSection: 1)
        expect(view).to(beNil())

        view = delegate.tableView(self.tableViewManager.tableView, viewForFooterInSection: 2)
        expect(view).toNot(beNil())

    }

    func testShouldShowMenuForRow() {
        let section = tableViewManager.sections.first!
        let firstRow = IndexPath(row: 0, section: 0)
        var result = delegate.tableView(tableViewManager.tableView, shouldShowMenuForRowAt: firstRow)

        expect(result).to(beFalse())

        let actionableItem = ActionableItem()

        section.items.replace(with: [actionableItem])

        result = delegate.tableView(tableViewManager.tableView, shouldShowMenuForRowAt: firstRow)
        expect(result).to(beTrue())

    }

    func testCanPerformActionForRow() {
        let selector = #selector(UIResponderStandardEditActions.copy(_:))
        let section = tableViewManager.sections.first!
        let firstRow = IndexPath(row: 0, section: 0)
        var result = delegate.tableView(tableViewManager.tableView,
                                        canPerformAction: selector,
                                        forRowAt: firstRow,
                                        withSender: nil)

        expect(result).to(beFalse())

        let actionableItem = ActionableItem()
        section.items.replace(with: [actionableItem])
        result = delegate.tableView(tableViewManager.tableView,
                                    canPerformAction: selector,
                                    forRowAt: firstRow,
                                    withSender: nil)
        expect(result).to(beTrue())
    }

    func testPerformActionForRow() {
        let selector = #selector(UIResponderStandardEditActions.copy(_:))
        let section = tableViewManager.sections.first!
        let firstRow = IndexPath(row: 0, section: 0)

        let actionableItem = ActionableItem()
        section.items.replace(with: [actionableItem])
        delegate.tableView(tableViewManager.tableView,
                                    performAction: selector,
                                    forRowAt: firstRow,
                                    withSender: nil)
        expect(actionableItem.check) == 1
    }
}
