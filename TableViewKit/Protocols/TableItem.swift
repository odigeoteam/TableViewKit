import Foundation

@available(*, deprecated, renamed: "TableItem")
public typealias Item = TableItem

/// A type that represent an item to be displayed
/// defining the `drawer` and the `height`
public protocol TableItem: class, AnyEquatable {

    /// The `drawer` of the item
    static var drawer: AnyCellDrawer { get }

    /// The `height` of the item
    var height: Height? { get }
}

public extension TableItem where Self: Equatable {
    func equals(_ other: Any?) -> Bool {
        if let other = other as? Self {
            return other == self
        }
        return false
    }
}

// swiftlint:disable:next identifier_name
private var ItemTableViewManagerKey: UInt8 = 0

extension TableItem {

    public internal(set) var manager: TableViewManager? {
        get {
            return objc_getAssociatedObject(self, &ItemTableViewManagerKey) as? TableViewManager
        }
        set(newValue) {
            objc_setAssociatedObject(self,
                                     &ItemTableViewManagerKey,
                                     newValue as AnyObject,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
}

extension TableItem {

    public func equals(_ other: Any?) -> Bool {
        if let other = other as AnyObject? {
            return other === self
        }
        return false
    }

    /// Dynamic height with an estimate value of 44.0
    public var height: Height? {
        return .dynamic(44.0)
    }

    /// Returns the `section` of the `item`
    ///
    /// - returns: The `section` of the `item` or `nil` if not present
    public var section: TableSection? {
        guard let indexPath = indexPath else { return nil }
        return manager?.sections[indexPath.section]
    }

    /// Returns the `indexPath` of the `item`
    ///
    /// - returns: The `indexPath` of the `item` or `nil` if not present
    public var indexPath: IndexPath? {
        guard let manager = manager else { return nil }
        for section in manager.sections {
            guard
                let sectionIndex = section.index,
                let rowIndex = section.items.index(of: self) else { continue }
            return IndexPath(row: rowIndex, section: sectionIndex)
        }
        return nil
    }

    /// Returns the `cell` of the `item`, if visibile
    var cell: UITableViewCell? {
        guard let indexPath = indexPath else { return nil }
        return manager?.tableView.cellForRow(at: indexPath)
    }

    /// Reload the `item` with an `animation`
    ///
    /// - parameter animation: A constant that indicates how the reloading is to be animated
    public func reload(with animation: UITableView.RowAnimation = .automatic) {
        guard let indexPath = indexPath else { return }
        let section = manager?.sections[indexPath.section]
        section?.items.callback?(.updates([indexPath.row]), animation)
    }

    /// Redraw the associated `cell` of the `item` without reloading it
    /// The `draw` method of `CellDrawer` get called if the `cell` is visible
    public func redraw() {
        guard let cell = cell else { return }
        Self.drawer.draw(cell, self)
    }

}

public extension Collection where Element == TableItem {
    /// Return the index of the `element` inside a collection of items
    func index(of element: TableItem) -> Index? {
        return index(where: { $0 === element })
    }
}
