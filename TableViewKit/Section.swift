import Foundation
import UIKit

/// A type that represent a section to be displayed
/// containing `items`, a `header` and a `footer`
public protocol Section: class, AnyEquatable {

    /// A array containing the `items` of the section
    var items: ObservableArray<Item> { get set }

    /// The `header` of the section, none if not defined
    /// - Default: none
    var header: HeaderFooterView { get }
    /// The `footer` of the section, none if not defined
    var footer: HeaderFooterView { get }

    func index(in manager: TableViewManager) -> Int?
}

public extension Section where Self: Equatable {

    func equals(_ other: Any?) -> Bool {
        if let other = other as? Self {
            return other == self
        }
        return false
}
}

extension Section {

    /// Empty header
    public var header: HeaderFooterView { return nil }
    /// Empty footer
    public var footer: HeaderFooterView { return nil }
}

private var SectionTableViewManagerKey: UInt8 = 0

extension Section {

    public internal(set) var manager: TableViewManager? {
        get {
            return objc_getAssociatedObject(self, &SectionTableViewManagerKey) as? TableViewManager
        }
        set(newValue) {
            objc_setAssociatedObject(self, &SectionTableViewManagerKey, newValue as AnyObject, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
}

extension Section {

    public func equals(_ other: Any?) -> Bool {
        if let other = other as AnyObject? {
            return other === self
        }
        return false
    }

    /// Returns the `index` of the `section` in the specified `manager`
    ///
    /// - parameter manager: A `manager` where the `section` may have been added
    ///
    /// - returns: The `index` of the `section` or `nil` if not present
    public func index(in manager: TableViewManager) -> Int? {
        return manager.sections.index(of: self)
    }

    /// Register the section in the specified manager
    ///
    /// - parameter manager: A manager where the section may have been added
    internal func register(in manager: TableViewManager) {
        setup(in: manager)

        if case .view(let header) = header {
            manager.tableView.register(type(of: header).drawer.type)
        }
        if case .view(let footer) = footer {
            manager.tableView.register(type(of: footer).drawer.type)
        }
        items.forEach { item in
            item.manager = manager
            manager.tableView.register(type(of: item).drawer.type)
        }
    }

    /// Unregister the section
    internal func unregister() {
        self.manager = nil
        items.forEach { $0.manager = nil }
    }

    /// Setup the section internals
    ///
    /// - parameter manager: A manager where the section may have been added
    private func setup(in manager: TableViewManager) {
        self.manager = manager

        items.callback = { [weak self] change in
            if let weakSelf = self, let manager = weakSelf.manager {
                weakSelf.onItemsUpdate(withChanges: change, in: manager)
            }
        }
    }

    private func onItemsUpdate(withChanges changes: ArrayChanges<Item>, in manager: TableViewManager) {

        guard let sectionIndex = index(in: manager) else { return }
        let tableView = manager.tableView

        if case .inserts(_, let items) = changes {
            items.forEach { item in
                item.manager = manager
                manager.register(type(of: item).drawer.type)
            }
        }

        switch changes {
        case .inserts(let array, _):
            let indexPaths = array.map { IndexPath(item: $0, section: sectionIndex) }
            tableView.insertRows(at: indexPaths, with: manager.animation)
        case .deletes(let array, _):
            let indexPaths = array.map { IndexPath(item: $0, section: sectionIndex) }
            tableView.deleteRows(at: indexPaths, with: manager.animation)
        case .updates(let array):
            let indexPaths = array.map { IndexPath(item: $0, section: sectionIndex) }
            tableView.reloadRows(at: indexPaths, with: manager.animation)
        case .moves(let array):
            let fromIndexPaths = array.map { IndexPath(item: $0.0, section: sectionIndex) }
            let toIndexPaths = array.map { IndexPath(item: $0.1, section: sectionIndex) }
            tableView.moveRows(at: fromIndexPaths, to: toIndexPaths)
        case .beginUpdates:
            tableView.beginUpdates()
        case .endUpdates:
            tableView.endUpdates()
        }
    }
}

public extension Collection where Self.Iterator.Element == Section {
    /// Return the index of the `element` inside a collection of sections
    func index(of element: Section) -> Self.Index? {
        return index(where: { $0 === element })
    }
}
