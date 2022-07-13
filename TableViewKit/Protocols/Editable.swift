import Foundation

/// A type that represent an item that can be edited
public protocol Editable: TableItem {

    /// The associated actions
    // swiftlint:disable:next line_length
    @available(*, deprecated, message: "'actions' was deprecated in iOS 13.0: Use 'configuration' and related APIs instead.")
    var actions: [UITableViewRowAction]? { get set }

    /// The associated leading configuration
    var trailingConfiguration: UISwipeActionsConfiguration? { get set }

    /// The associated leading configuration
    var leadingConfiguration: UISwipeActionsConfiguration? { get set }

}

public extension Editable {

    var actions: [UITableViewRowAction]? {
        get { return [] }
        // swiftlint:disable:next unused_setter_value
        set {}
    }

    var trailingConfiguration: UISwipeActionsConfiguration? {
        get { return nil }
        // swiftlint:disable:next unused_setter_value
        set {}
    }

    var leadingConfiguration: UISwipeActionsConfiguration? {
        get { return nil }
        // swiftlint:disable:next unused_setter_value
        set {}
    }

}
