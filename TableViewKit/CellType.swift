import Foundation

/// The type of a cell (nib, class)
public enum CellType {

    /// If it must be loaded from a UINib
    case nib(UINib, UITableViewCell.Type)
    /// If it must be loaded from a Class
    case `class`(UITableViewCell.Type)

    
    /// The reusable identifier for the cell
    public var reusableIdentifier: String {
        return String(describing: cellClass)
    }

    /// The cell class
    public var cellClass: UITableViewCell.Type {
        switch self {
        case .class(let cellClass):
            return cellClass
        case .nib(_, let cellClass):
            return cellClass
        }
    }
}
