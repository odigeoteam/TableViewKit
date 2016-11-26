import UIKit

extension UITableView {
    
    /// Register a cell type for reuse
    ///
    /// - parameter type: The type of cell that must be registered
    public func register(_ type: NibClassType<UITableViewCell>) {
        switch type {
        case .class(let cellClass):
            self.register(cellClass, forCellReuseIdentifier: type.reusableIdentifier)
        case .nib(let nib, _):
            self.register(nib, forCellReuseIdentifier: type.reusableIdentifier)
        }
    }

    /// Register a header/footer type for reuse
    ///
    /// - parameter type: The type of header/footer that must be registered
    public func register(_ type: NibClassType<UITableViewHeaderFooterView>) {
        switch type {
        case .class(let cellClass):
            self.register(cellClass, forHeaderFooterViewReuseIdentifier: type.reusableIdentifier)
        case .nib(let nib, _):
            self.register(nib, forHeaderFooterViewReuseIdentifier: type.reusableIdentifier)
        }
    }
    
    public func moveRows(at indexPaths: [IndexPath], to newIndexPaths: [IndexPath]) {
        for (index, _) in indexPaths.enumerated() {
            moveRow(at: indexPaths[index], to: newIndexPaths[index])
        }
    }

}
