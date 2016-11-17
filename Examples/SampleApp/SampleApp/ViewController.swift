import UIKit
import TableViewKit


class ViewController: UIViewController, TableViewManagerCompatible {
    
    fileprivate class CustomSection: Section {
        var items: ObservableArray<Item>

        let vc: ViewController
        
        required init(vc: ViewController) {
            self.vc = vc
            self.items = []
            
            let array: [UIViewController.Type] = [Example1.self]
            let mappedItems = array.map({ (className) -> Item in                
                let viewController = className.init(nibName: String(describing: className), bundle: nil)

                let navigationController = UINavigationController.init(rootViewController: viewController)

                let item = CustomItem(title: "Example 1")
                item.onSelection = { _ in
                    self.vc.present(navigationController, animated: true, completion: {
                        item.deselect(in: self.vc.tableViewManager, animated: false)
                    })
                }
                return item
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


