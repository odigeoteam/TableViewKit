import Foundation

/// A type that represent an item that can be selected
public protocol Selectable: Item {
    
    /// Closure called once an item is selected from a selectRow.
    /// It will receive as parameter itself
    var onSelection: (Selectable) -> () { get set }
}

extension Selectable {

    /// Select the `item`
    ///
    /// - parameter manager: A `manager` where the `item` may have been added
    /// - parameter animated:       If the selection should be animated
    /// - parameter scrollPosition: The scrolling position
    public func select(in manager: TableViewManager, animated: Bool, scrollPosition: UITableViewScrollPosition = .none) {

        manager.tableView.selectRow(at: indexPath(in: manager), animated: animated, scrollPosition: scrollPosition)
        manager.tableView(manager.tableView, didSelectRowAt: indexPath(in: manager)!)
    }

    /// Deselect the `item`
    ///
    /// - parameter manager: A `manager` where the `item` may have been added
    /// - parameter animated:       If the selection should be animated
    public func deselect(in manager: TableViewManager, animated: Bool) {
        guard let indexPath = indexPath(in: manager) else { return }
        
        manager.tableView.deselectRow(at: indexPath, animated: animated)
    }

}
