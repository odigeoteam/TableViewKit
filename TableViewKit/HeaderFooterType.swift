import Foundation

public enum HeaderFooterType {

    case nib(UINib, UITableViewHeaderFooterView.Type)
    case `class`(UITableViewHeaderFooterView.Type)

    public var reusableIdentifier: String {
        return String(describing: cellClass)
    }

    public var cellClass: UITableViewHeaderFooterView.Type {
        switch self {
        case .class(let cellClass):
            return cellClass
        case .nib(_, let cellClass):
            return cellClass
        }
    }
}
