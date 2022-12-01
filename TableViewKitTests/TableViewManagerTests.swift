import XCTest
import Nimble

@testable import TableViewKit

class TableViewManagerTests: XCTestCase {

    var manager: TableViewManager!

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
        manager = nil
    }

    func testAddSection() {
        manager = TableViewManager(tableView: UITableView())

        let section = HeaderFooterTitleSection()
        manager.sections.append(section)

        expect(self.manager.sections.count) == 1
    }

    func testAddItem() {

        manager = TableViewManager(tableView: UITableView())

        let item: TableItem = TestItem()

        let section = HeaderFooterTitleSection()
        section.items.append(item)

        manager.sections.insert(section, at: 0)

        expect(section.items.count) == 1
        expect(item.section).notTo(beNil())

        section.items.remove(at: 0)
        section.items.append(item)

        section.items.replace(with: [TestItem(), item])
    }

    func testUpdateRow() {
        let item = TestReloadItem()
        item.title = "Before"

        let section = HeaderFooterTitleSection(items: [item])
        manager = TableViewManager(tableView: UITableView(), sections: [section])

        guard let indexPath = item.indexPath else { return }
        let dataSource = manager.dataSource!
        var cell = dataSource.tableView(manager.tableView, cellForRowAt: indexPath)

        expect(cell.textLabel?.text) == item.title

        item.title = "After"
        item.reload()

        cell = dataSource.tableView(manager.tableView, cellForRowAt: indexPath)

        expect(cell.textLabel?.text) == item.title
    }

    func testUpdateRowWithoutReload() {
        let item = TestReloadItem()
        item.title = "Before"

        let section = HeaderFooterTitleSection(items: [item])
        manager = TableViewManager(tableView: UITableView(), sections: [section])

        guard let indexPath = item.indexPath else { return }
        let dataSource = manager.dataSource!
        var cell = dataSource.tableView(manager.tableView, cellForRowAt: indexPath)

        expect(cell.textLabel?.text) == item.title

        item.title = "After"
        item.redraw()

        cell = dataSource.tableView(manager.tableView, cellForRowAt: indexPath)

        expect(cell.textLabel?.text) == item.title
    }

    func testMoveRows() {

        let tableView = UITableView()

        let item1 = TestItem()
        let item2 = TestItem()

        let section = NoHeaderFooterSection(items: [item1, item2])
        manager = TableViewManager(tableView: tableView, sections: [section])

        var indexPathItem1 = item1.indexPath
        var indexPathItem2 = item2.indexPath

        XCTAssertNotNil(indexPathItem1)
        XCTAssertNotNil(indexPathItem2)

        section.items.replace(with: [item2, item1])

        indexPathItem1 = item1.indexPath
        indexPathItem2 = item2.indexPath

        XCTAssert(indexPathItem2?.item == 0)
        XCTAssert(indexPathItem1?.item == 1)
    }

    func testMoveSections() {

        let tableView = UITableView()

        let section1 = NoHeaderFooterSection()
        let section2 = NoHeaderFooterSection()

        manager = TableViewManager(tableView: tableView, sections: [section1, section2])

        XCTAssert(section1.index == 0)
        XCTAssert(section2.index == 1)

        manager.sections.replace(with: [section2, section1])

        XCTAssert(section1.index == 1)
        XCTAssert(section2.index == 0)
    }

    func testNoCrashOnNonAddedItem() {
        manager = TableViewManager(tableView: UITableView(), sections: [HeaderFooterTitleSection()])

        let item: TableItem = TestReloadItem()
        item.reload(with: .automatic)

        let section = item.section
        expect(section).to(beNil())
    }

    func testRetainCycle() {
        manager = TableViewManager(tableView: UITableView())
        manager.sections.insert(HeaderFooterTitleSection(items: [TestItem()]), at: 0)

        weak var section: TableSection? = manager.sections.first
        weak var item: TableItem? = section!.items.first
        expect(section).toNot(beNil())
        expect(item).toNot(beNil())
        manager.sections.replace(with: [HeaderFooterTitleSection()])
        expect(section).to(beNil())
        expect(item).to(beNil())
    }

    func testConvenienceInit() {
        manager = TableViewManager(tableView: UITableView(), sections: [HeaderFooterTitleSection()])

        expect(self.manager.sections.count) == 1
    }

    func testManagerProperty() {
        let tableView = UITableView()

        let item1 = TestItem()
        XCTAssertNil(item1.manager)
        let section = NoHeaderFooterSection(items: [item1])
        XCTAssertNil(section.manager)

        manager = TableViewManager(tableView: tableView, sections: [section])
        XCTAssert(item1.manager === manager)
        XCTAssert(section.manager === manager)

        let section2 = NoHeaderFooterSection(items: [item1])
        manager.sections.append(section2)
        XCTAssert(section2.manager === manager)

        let item2 = TestItem()
        section.items.append(item2)
        XCTAssert(item2.manager === manager)

        let removedSection = manager.sections.removeLast()

        XCTAssert(removedSection === section2)
        XCTAssertNil(removedSection.manager)
        XCTAssertNil(removedSection.items[0].manager)

        manager.sections.append(removedSection)

        XCTAssertNotNil(removedSection.manager)
        XCTAssertNotNil(removedSection.items[0].manager)

        let removedFirstSection = manager.sections.removeFirst()

        XCTAssert(removedFirstSection === section)
        XCTAssertNil(removedFirstSection.manager)
        XCTAssertNil(removedFirstSection.items[0].manager)

    }

    func testZPositionForCell() throws {
        let zPosition: CGFloat = 4
        let sections = Array(
            repeating: HeaderFooterTitleSection(items: .init(repeating: TestItem(), count: 3)),
            count: 2
        )
        let tableManager = TableViewManagerMock(tableView: UITableView(), sections: sections)
        tableManager.zPositionForCellReturnValue = zPosition
        let dataSource = try XCTUnwrap(tableManager.dataSource)
        
        let cell = dataSource.tableView(tableManager.tableView, cellForRowAt: .init(row: 1, section: 1))
        
        XCTAssertEqual(tableManager.zPositionForCellCallsCount, 1)
        XCTAssertEqual(cell.layer.zPosition, zPosition)
    }

    func testZPositionForHeader() throws {
        // Given
        let zPosition: CGFloat = 4
        let tableManager = tableManagerForInstanciatedSections(itemsBySection: 3, numberOfSections: 2)
        tableManager.zPositionForHeaderReturnValue = zPosition
        let delegate = try XCTUnwrap(tableManager.delegate)
        // When
        let headerSection0 = try XCTUnwrap(delegate.tableView(tableManager.tableView, viewForHeaderInSection: 0))
        let headerSection1 = try XCTUnwrap(delegate.tableView(tableManager.tableView, viewForHeaderInSection: 1))
        // Then
        XCTAssertEqual(tableManager.zPositionForHeaderCallsCount, 2)
        XCTAssertEqual(headerSection0.layer.zPosition, zPosition)
        XCTAssertEqual(headerSection1.layer.zPosition, zPosition)
    }

    func testZPositionForFooter() throws {
        // Given
        let zPosition: CGFloat = 4
        let tableManager = tableManagerForInstanciatedSections(itemsBySection: 3, numberOfSections: 2)
        tableManager.zPositionForFooterReturnValue = zPosition
        let delegate = try XCTUnwrap(tableManager.delegate)
        // When
        let footerSection0 = try XCTUnwrap(delegate.tableView(tableManager.tableView, viewForFooterInSection: 0))
        let footerSection1 = try XCTUnwrap(delegate.tableView(tableManager.tableView, viewForFooterInSection: 1))
        // Then
        XCTAssertEqual(tableManager.zPositionForFooterCallsCount, 2)
        XCTAssertEqual(footerSection0.layer.zPosition, zPosition)
        XCTAssertEqual(footerSection1.layer.zPosition, zPosition)
    }

    private func tableManagerForInstanciatedSections(itemsBySection: Int, numberOfSections: Int) -> TableViewManagerMock {
        let sections = Array(
            repeating: ViewHeaderFooterSectionInstaciated(items: .init(repeating: TestItem(), count: itemsBySection)),
            count: numberOfSections
        )
        return TableViewManagerMock(tableView: UITableView(), sections: sections)
    }
}
