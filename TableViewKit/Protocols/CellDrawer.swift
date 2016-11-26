import Foundation
import UIKit

/// The type of a cell (nib, class)
public typealias CellType<Cell: UITableViewCell> = NibClassType<Cell>

/// A type that can draw a cell
public protocol CellDrawer {
    associatedtype Cell: UITableViewCell
    associatedtype GenericItem

    /// Define the `type` of the cell
    static var type: CellType<Cell> { get }
    
    /// Returns the cell from the `manager`
    ///
    /// - parameter manager: The `manager` where the cell came from
    /// - parameter item:    The cell `item`
    /// - parameter indexPath:    Where the cell is located
    ///
    /// - returns: The the cell
    static func cell(in manager: TableViewManager, with item: GenericItem, for indexPath: IndexPath) -> Cell
    
    /// Draw the `cell` using the `item`
    ///
    /// - parameter cell: The `cell` that must be drawn
    /// - parameter item: The cell `item` that generated the drawer
    static func draw(_ cell: Cell, with item: GenericItem)

}

public extension CellDrawer {
    
    /// Returns a dequeued cell and set the item property if the cell conforms to ItemCompatible
    static func cell(in manager: TableViewManager, with item: GenericItem, for indexPath: IndexPath) -> Cell {
        
        let cell = manager.tableView.dequeueReusableCell(withIdentifier: self.type.reusableIdentifier, for: indexPath)
        cell.selectionStyle = item is Selectable ? .default : .none
        
        if let cell = cell as? ItemCompatible {
            cell.item = item as? Item
        }
        
        return cell as! Cell
    }
}

public struct CellDrawerOf {
    
    let _cell: (TableViewManager, Item, IndexPath) -> UITableViewCell
    let _draw: (UITableViewCell, Item) -> ()
    
    public init<Drawer: CellDrawer, GenericItem, Cell: UITableViewCell>(_ drawer: Drawer.Type) where Drawer.GenericItem == GenericItem, Drawer.Cell == Cell {
        switch drawer.type {
        case .class(let type):
            self.type = NibClassType<UITableViewCell>.class(type)
        case .nib(let nib, let type):
            self.type = NibClassType<UITableViewCell>.nib(nib, type)
        }
        self._cell = { manager, item, indexPath in drawer.cell(in: manager, with: item as! GenericItem, for: indexPath) }
        self._draw = { cell, item in drawer.draw(cell as! Cell, with: item as! GenericItem) }
    }
    
    public let type: CellType<UITableViewCell>
    
    public func cell(in manager: TableViewManager, with item: Item, for indexPath: IndexPath) -> UITableViewCell {
        return _cell(manager, item, indexPath)
    }
    
    
    public func draw(_ cell: UITableViewCell, with item: Item) {
        _draw(cell, item)
    }
    
}
