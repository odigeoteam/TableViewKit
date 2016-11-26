import Foundation


/// A type that represent an item to be displayed
/// defining the `drawer` and the `height`
public protocol Item: class, AnyEquatable {
    
    /// The `drawer` of the item
    static var drawer: CellDrawerOf { get }
    
    /// The `height` of the item
    var height: Height? { get }
}

public extension Item where Self: Equatable {
    func equals(_ other: Any?) -> Bool {
        if let other = other as? Self {
            return other == self
        }
        return false
    }
}

extension Item {
    
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

    /// Returns the `section` of the `item` in the specified `manager`
    ///
    /// - parameter manager: A `manager` where the `item` may have been added
    ///
    /// - returns: The `section` of the `item` or `nil` if not present
    public func section(in manager: TableViewManager) -> Section? {
        guard let indexPath = self.indexPath(in: manager) else { return nil }
        return manager.sections[indexPath.section]
    }

    /// Returns the `indexPath` of the `item` in the specified `manager`
    ///
    /// - parameter manager: A `manager` where the `item` may have been added
    ///
    /// - returns: The `indexPath` of the `item` or `nil` if not present
    public func indexPath(in manager: TableViewManager) -> IndexPath? {
        for section in manager.sections {
            guard
                let sectionIndex = section.index(in: manager),
                let rowIndex = section.items.index(of: self) else { continue }
            return IndexPath(row: rowIndex, section: sectionIndex)
        }
        return nil
    }

    /// Reload the `item` in the specified `manager` with an `animation`
    ///
    /// - parameter manager: A `manager` where the `item` may have been added
    /// - parameter animation: A constant that indicates how the reloading is to be animated
    ///
    /// - returns: The `section` of the `item` or `nil` if not present
    public func reload(in manager: TableViewManager, with animation: UITableViewRowAnimation = .automatic) {
        guard let indexPath = self.indexPath(in: manager) else { return }
        let section = manager.sections[indexPath.section]
        section.items.callback?(.updates([indexPath.row]))
    }

}

public extension Collection where Self.Iterator.Element == Item {
    /// Return the index of the `element` inside a collection of items
    func index(of element: Item) -> Self.Index? {
        return index(where: { $0 === element })
    }
}
