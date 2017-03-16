import Foundation
import UIKit
import TableViewKit

class SelectionSection: Section {
    var items: ObservableArray<Item> = []
    weak var tableViewManager: TableViewManager!

    required init() { }
}

public protocol SelectionItemProtocol: Item {

    var value: Any { get }
    var selected: Bool { get set }

    init(title: String, value: Any, selected: Bool)
}

public enum SelectionType {
    case Single, Multiple
}

public class SelectionItem: SelectionItemProtocol {
    public static var drawer = AnyCellDrawer(CustomDrawer.self)

    public var title: String?

    public var value: Any
    public var selected: Bool

    public var onSelection: (Selectable) -> Void = { _ in }

    public var accessoryType: UITableViewCellAccessoryType = .none
    public var accessoryView: UIView?
    public var cellHeight: CGFloat? = UITableViewAutomaticDimension

    public required init(title: String, value: Any, selected: Bool = false) {
        self.value = value
        self.selected = selected
        self.title = title
    }
}

public class SelectionViewController: UITableViewController {

    private var tableViewManager: TableViewManager!
    private var selectionType: SelectionType!
    private var selectedItems: [SelectionItem]!

    public var items: [SelectionItem]!
    public var onSelection: (([SelectionItem]) -> Void)?

    private func commonInit() {

        selectionType = .Single
        items = []
        selectedItems = []
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }

    public init(style: UITableViewStyle, selectionType: SelectionType) {

        super.init(style: style)
        commonInit()
        self.selectionType = selectionType
    }

    required public init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        commonInit()
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    override public func viewDidLoad() {

        super.viewDidLoad()

        tableViewManager = TableViewManager(tableView: self.tableView)
        setupTaleViewItems()
    }

    public override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)

        onSelection?(selectedItems)
    }

    private func fillSelected() {

        selectedItems = items.filter { $0.selected == true }
    }

    private func setupTaleViewItems() {

        let section = SelectionSection()
        tableViewManager.sections.insert(section, at: 0)

        for element in items {

            element.onSelection = { item in
                self.toogleItemCheck(item: item as! SelectionItem)
            }
            element.accessoryType = element.selected ? .checkmark : .none
            section.items.append(element)
        }

        fillSelected()
    }

    private func toogleItemCheck(item: SelectionItem) {

        if selectionType == .Single {

            if let checkedItem = itemSelected() {
                checkedItem.selected = false
                checkedItem.accessoryType = .none
                checkedItem.reload(in: tableViewManager, with: .fade)
            }
        }

        item.selected = !item.selected
        item.accessoryType = item.accessoryType == .checkmark ? .none : .checkmark
        item.reload(in: tableViewManager, with: .fade)

        fillSelected()
    }

    private func itemSelected() -> SelectionItem? {

//        for section in tableViewManager.sections {
//            let checkedItems = section.items.filter { $0.accessoryType == .Checkmark }
//            if checkedItems.count != 0 {
//                return checkedItems.first as? SelectionItemProtocol
//            }
//        }
        return nil
    }
}
