import Foundation

/// A type that represent an item that can be edited
public protocol Editable: TableItem {

    /// The associated actions
    // swiftlint:disable:next line_length
    @available(*, deprecated, message: "'actions' was deprecated in iOS 13.0: Use 'configuration' and related APIs instead.")
    var actions: [UITableViewRowAction]? { get set }

    /// The associated configuration
    var configuration: UISwipeActionsConfiguration? { get set }
}

extension Editable {
    var actions: [UITableViewRowAction]? {
        get { return [] }
        set {}
    }

    var configuration: UISwipeActionsConfiguration? {
        get { return nil }
        set {}
    }
}
