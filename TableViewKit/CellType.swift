import Foundation

public enum CellType {

    case nib(UINib, UITableViewCell.Type)
    case `class`(UITableViewCell.Type)

    public var reusableIdentifier: String {
        return String(describing: cellClass)
    }

    public var cellClass: UITableViewCell.Type {
        switch self {
        case .class(let cellClass):
            return cellClass
        case .nib(_, let cellClass):
            return cellClass
        }
    }
}
