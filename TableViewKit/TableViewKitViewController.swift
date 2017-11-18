import UIKit

/// Helper for using TableViewKit inheriting from a UITableViewController
/// It can be used with a XIB file or Storyboards
open class TableViewKitViewController: UITableViewController {
	
	open var tableViewManager: TableViewManager!

    override open func viewDidLoad() {
		super.viewDidLoad()
		tableViewManager = TableViewManager(tableView: tableView)
    }

}
