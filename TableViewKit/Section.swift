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
        if case .view(let header) = header {
            manager.register(header.drawer.type)
        }
        if case .view(let footer) = footer {
            manager.register(footer.drawer.type)
        }
        items.forEach {
            manager.register($0.drawer.type)
        }
    }

    /// Setup the section internals
    ///
    /// - parameter manager: A manager where the section may have been added
    internal func setup(in manager: TableViewManager) {
        items.callback = { [weak self, weak manager] change in
            if let manager = manager {
                self?.onItemsUpdate(withChanges: change, in: manager)
            }
        }
    }
    
    private func onItemsUpdate(withChanges changes: ArrayChanges, in manager: TableViewManager) {
        
        guard let sectionIndex = index(in: manager) else { return }
        let tableView = manager.tableView
        
        switch changes {
        case .inserts(let array):
            let indexPaths = array.map { row -> IndexPath in
                manager.register(items[row].drawer.type)
                return IndexPath(item: row, section: sectionIndex)
            }
            tableView.insertRows(at: indexPaths, with: manager.animation)
        case .deletes(let array):
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
