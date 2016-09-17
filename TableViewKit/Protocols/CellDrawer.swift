import Foundation
import UIKit

/// The type of a cell (nib, class)
public typealias CellType = NibClassType<UITableViewCell>

/// A type that can draw a cell
public protocol CellDrawer {

    /// Define the `type` of the cell
    static var type: CellType { get }
    
    /// Returns the cell from the `manager`
    ///
    /// - parameter manager: The `manager` where the cell came from
    /// - parameter item:    The cell `item`
    /// - parameter indexPath:    Where the cell is located
    ///
    /// - returns: The the cell
    static func cell(in manager: TableViewManager, with item: Item, for indexPath: IndexPath) -> UITableViewCell
    
    /// Draw the `cell` using the `item`
    ///
    /// - parameter cell: The `cell` that must be drawn
    /// - parameter item: The cell `item` that generated the drawer
    static func draw(_ cell: UITableViewCell, with item: Any)

}

public extension CellDrawer {
    
    /// Returns a dequeued cell and set the item property if the cell conforms to ItemCompatible
    static func cell(in manager: TableViewManager, with item: Item, for indexPath: IndexPath) -> UITableViewCell {
        
        let cell = manager.tableView.dequeueReusableCell(withIdentifier: self.type.reusableIdentifier, for: indexPath)
        
        if let cell = cell as? ItemCompatible {
            cell.item = item
        }
        
        return cell
    }
}
