import Foundation
import UIKit
import TableViewKit

public class CustomDrawer: CellDrawer {
    
    static public var type = CellType.class(UITableViewCell.self)
    
    static public func draw(_ cell: UITableViewCell, with item: Any) {
        let item = item as! CustomItem
        cell.accessoryType = item.accessoryType
        cell.accessoryView = item.accessoryView
        cell.textLabel?.text = item.title
    }
}


public class CustomItem: Selectable, Item {
    
    public var title: String?
    
    public var onSelection: (Selectable) -> () = { _ in }
    
    public var cellStyle: UITableViewCellStyle = .default
    public var accessoryType: UITableViewCellAccessoryType = .none
    public var accessoryView: UIView?
    public var cellHeight: CGFloat? = UITableViewAutomaticDimension
    
    public var drawer: CellDrawer.Type = CustomDrawer.self
    
    public init() { }
    
    public convenience init(title: String) {
        self.init()
        self.title = title
    }
}
