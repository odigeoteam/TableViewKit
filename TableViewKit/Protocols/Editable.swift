import Foundation

/// A type that represent an item that can be edited
public protocol Editable: Item {
    
    /// The associated actions
    var actions: [UITableViewRowAction]? { get set }
}
