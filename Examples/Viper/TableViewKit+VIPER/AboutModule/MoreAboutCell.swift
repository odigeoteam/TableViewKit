import Foundation
import TableViewKit

class MoreAboutDrawer: CellDrawer {
    
    static open var type = CellType.class(UITableViewCell.self)
    
    static open func draw(_ cell: UITableViewCell, with item: MoreAboutItem) {
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = item.title
    }
}
