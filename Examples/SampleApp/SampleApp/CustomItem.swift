import Foundation
import UIKit
import TableViewKit

public class CustomDrawer: CellDrawer {
    
    public static var type = CellType.class(UITableViewCell.self)
    
    public static func draw(_ cell: UITableViewCell, with item: CustomItem) {
        cell.accessoryType = item.accessoryType
        cell.accessoryView = item.accessoryView
        cell.textLabel?.text = item.title
    }
}


public class CustomItem: Selectable, Item {
    public static var drawer = AnyCellDrawer(CustomDrawer.self)

    public var title: String?
    
    public var onSelection: (Selectable) -> () = { _ in }
    
    public var cellStyle: UITableViewCellStyle = .default
    public var accessoryType: UITableViewCellAccessoryType = .none
    public var accessoryView: UIView?
    public var cellHeight: CGFloat? = UITableViewAutomaticDimension
    
    
    public init() { }
    
    public convenience init(title: String) {
        self.init()
        self.title = title
    }
    
    public func didSelect() {
        onSelection(self)
    }
}
