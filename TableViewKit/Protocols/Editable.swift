import Foundation

public protocol Editable: Item {
    var actions: [UITableViewRowAction]? { get set }
}
