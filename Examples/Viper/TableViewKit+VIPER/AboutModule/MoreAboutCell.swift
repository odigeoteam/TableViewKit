import Foundation
import TableViewKit

class MoreAboutDrawer: CellDrawer {

    static public var type = CellType.class(UITableViewCell.self)

    static public func draw(_ cell: UITableViewCell, with item: MoreAboutItem) {
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = item.title
    }
}
