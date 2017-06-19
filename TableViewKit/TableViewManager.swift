import Foundation
import UIKit

/// An object that controls a `tableView`.
/// It controls how to display an array of sections, from the header, to its items, to the footer.
/// It automatically registers any related initial or new views/cells for reusability.
/// Any changes of the sections will be automatically animated and reflected.
open class TableViewManager {

    /// The `tableView` linked to this manager
    open let tableView: UITableView

    /// An array of sections
    open var sections: ObservableArray<Section>

    open var animation: UITableViewRowAnimation = .automatic

    open var dataSource: TableViewKitDataSource? { didSet { tableView.dataSource = dataSource } }
    open var delegate: TableViewKitDelegate? { didSet { tableView.delegate = delegate } }
    open var scrollDelegate: UIScrollViewDelegate? { didSet { delegate?.scrollDelegate = scrollDelegate } }

    var reusableIdentifiers: Set<String> = []

    /// Initialize a `TableViewManager` with a `tableView` and an initial array of sections
    ///
    /// - parameter tableView: A `tableView` that will be controlled by the `TableViewManager`
    /// - parameter sections: An array of sections
    public init(tableView: UITableView, sections: [Section] = []) {
        self.tableView = tableView
        self.sections = ObservableArray(array: sections)
        self.setupDelegates()
        self.setupSections()
    }

    private func setupDelegates() {
        self.delegate = TableViewKitDelegate(manager: self)
        self.dataSource = TableViewKitDataSource(manager: self)
    }

    private func setupSections() {
        sections.forEach { section in
            section.setup(in: self)
            section.register(in: self)
        }
        sections.callback = { [weak self] in self?.onSectionsUpdate(withChanges: $0) }
    }

    private func onSectionsUpdate(withChanges changes: ArrayChanges) {
        switch changes {
        case .inserts(let array):
            array.forEach { index in
                sections[index].setup(in: self)
                sections[index].register(in: self)
            }
            tableView.insertSections(IndexSet(array), with: animation)
        case .deletes(let array):
            tableView.deleteSections(IndexSet(array), with: animation)
        case .updates(let array):
            tableView.reloadSections(IndexSet(array), with: animation)
        case .moves(let array):
            let fromIndex = array.map { $0.0 }
            let toIndex = array.map { $0.1 }
            tableView.moveSections(from: fromIndex, to: toIndex)
        case .beginUpdates:
            if animation == .none {
                UIView.setAnimationsEnabled(false)
            }
            tableView.beginUpdates()
        case .endUpdates:
            tableView.endUpdates()
            if animation == .none {
                UIView.setAnimationsEnabled(true)
            }
        }
    }

}

extension TableViewManager {

    func register<Cell: UITableViewCell>(_ type: CellType<Cell>) {
        if !reusableIdentifiers.contains(type.reusableIdentifier) {
            tableView.register(type)
            reusableIdentifiers.insert(type.reusableIdentifier)
        }
    }
    func register<View: UITableViewHeaderFooterView>(_ type: HeaderFooterType<View>) {
        if !reusableIdentifiers.contains(type.reusableIdentifier) {
            tableView.register(type)
            reusableIdentifiers.insert(type.reusableIdentifier)
        }
    }

    func item(at indexPath: IndexPath) -> Item {
        return sections[indexPath.section].items[indexPath.row]
    }
}
