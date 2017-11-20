import UIKit
import TableViewKit

class ViewController: UIViewController {

    fileprivate class CustomSection: TableSection {
        var items: ObservableArray<TableItem>

        weak var vc: ViewController!

        required init(vc: ViewController) {
            self.vc = vc
            self.items = []

            let array: [UIViewController.Type] = [Example1.self]
            let mappedItems = array.map({ (className) -> TableItem in
				
                let cItem = CustomItem(title: String(describing: className))
                cItem.onSelection = { item in
					let viewController = className.init(nibName: String(describing: className), bundle: nil)
					let navigationController = UINavigationController(rootViewController: viewController)
                    self.vc.present(navigationController, animated: true, completion: {
                        item.deselect(animated: false)
                    })
                }
                return cItem
            })

            self.items.insert(contentsOf: mappedItems, at: 0)
        }
    }

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableViewManager = TableViewManager(tableView: tableView, sections: [CustomSection(vc: self)])
        }
    }

    var tableViewManager: TableViewManager!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
