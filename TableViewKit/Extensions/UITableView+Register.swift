import UIKit

public extension UITableView {
    public func register(_ type: CellType) {
        switch type {
        case .class(let cellClass):
            self.register(cellClass, forCellReuseIdentifier: type.reusableIdentifier)
        case .nib(let nib, _):
            self.register(nib, forCellReuseIdentifier: type.reusableIdentifier)
        }
    }

    public func register(_ type: HeaderFooterType) {
        switch type {
        case .class(let cellClass):
            self.register(cellClass, forHeaderFooterViewReuseIdentifier: type.reusableIdentifier)
        case .nib(let nib, _):
            self.register(nib, forHeaderFooterViewReuseIdentifier: type.reusableIdentifier)
        }
    }
    
    func moveRows(at indexPaths: [IndexPath], to newIndexPaths: [IndexPath]) {
        for (index, _) in indexPaths.enumerated() {
            moveRow(at: indexPaths[index], to: newIndexPaths[index])
        }
    }

}
