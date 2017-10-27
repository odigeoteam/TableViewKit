import Foundation

/// A type that has an `item`.
/// When a UITableViewCell conforms to this protocol and
/// if the cell is initialiated by the TableViewManager,
/// the item will be setted automatically.
public protocol ItemCompatible: class {

    /// The associated item
    var item: TableItem? { get set }
}
