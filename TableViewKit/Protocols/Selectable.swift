import Foundation

/// A type that represent an item that can be selected
public protocol Selectable: Item {

    /// Method called once an item is selected by a selectRow.
    func didSelect()
}

extension Selectable {

    /// Select the `item`
    ///
    /// - parameter animated:       If the selection should be animated
    /// - parameter scrollPosition: The scrolling position
    // swiftlint:disable:next line_length
    public func select(animated: Bool, scrollPosition: UITableViewScrollPosition = .none) {
        guard let tableView = manager?.tableView else { return }

        tableView.selectRow(at: indexPath, animated: animated, scrollPosition: scrollPosition)
        if let indexPath = indexPath {
            tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
        }
    }

    /// Deselect the `item`
    ///
    /// - parameter animated:       If the selection should be animated
    public func deselect(animated: Bool) {
        guard let tableView = manager?.tableView else { return }

        if let indexPath = indexPath {
            tableView.deselectRow(at: indexPath, animated: animated)
        }
    }

}
