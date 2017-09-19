import Foundation
import UIKit
import TableViewKit

public protocol TableViewManagerCompatible {
    var tableViewManager: TableViewManager! { get }
}

protocol ActionManagerCompatible {
    var actionBarManager: TableViewManager! { get }
}

class Example1: UIViewController, TableViewManagerCompatible {
    fileprivate class FirstSection: TableSection, StaticStateful {
        var items: ObservableArray<TableItem> = []
        var states: [State: [TableItem]] = [:]

        enum State: Int {
            case preParty
            case onParty
            case afterParty
        }

        var currentState: State = .preParty

        let vc: Example1

        internal var header: HeaderFooterView = .view(CustomHeaderItem(title: "First Section"))
        internal var footer: HeaderFooterView = .view(CustomHeaderItem(title: "Section Footer\nHola"))

        required init(vc: Example1) {
            self.vc = vc

            let item = CustomItem(title: "Passengers")
            let item2 = CustomItem(title: "Testing")
            let item3 = CustomItem(title: "Testing 2")
            let dateItem = CustomItem(title: "Birthday")
            let selectionItem = CustomItem(title: "Selection")
            let textFieldItem = TextFieldItem(placeHolder: "Name", actionBarDelegate: vc.actionBarManager)
            textFieldItem.validation.add(rule: ExistRule())
            let textFieldItem2 = TextFieldItem(placeHolder: "Surname", actionBarDelegate: vc.actionBarManager)
            textFieldItem2.validation.add(rule: ExistRule())

            item.onSelection = { item in
                item.deselect(animated: true)
                self.vc.showPickerControl()
            }
            dateItem.accessoryType = .disclosureIndicator
            dateItem.onSelection = { item in
                item.deselect(animated: true)
                self.vc.showDatePickerControl()
            }
            selectionItem.accessoryType = .disclosureIndicator
            selectionItem.onSelection = { item in
                item.deselect(animated: true)
                self.vc.showPickerControl()
            }
            states[State.preParty] = [item, dateItem, selectionItem, textFieldItem, textFieldItem2]
            states[State.onParty] = [item2, selectionItem, dateItem, item3, textFieldItem2, textFieldItem]
            states[State.afterParty] = [item2]
            transition(to: currentState)
        }

    }

    fileprivate class SecondSection: TableSection {

        var items: ObservableArray<TableItem> = []

        internal var header: HeaderFooterView = .view(CustomHeaderItem(title: "Second Section"))

        let vc: Example1

        required init(vc: Example1) {
            self.vc = vc

            let total: [Int] = Array(1...100)
            let items = total.map({ (index) -> TableItem in
                if (index % 2 == 0) {
                    let item = TextFieldItem(placeHolder: "Textfield \(index)", actionBarDelegate: vc.actionBarManager)
                    return item
                } else {
                    let item = CustomItem(title: "Label  \(index)")
                    item.onSelection = { item in
                        item.deselect(animated: true)
                    }
                    return item
                }
            })
            self.items.insert(contentsOf: items, at: 0)
        }
    }

    fileprivate class ThirdSection: TableSection, Stateful {

        enum State {
            case all
            case selected(TableItem)
        }

        var items: ObservableArray<TableItem> = []
        var allItems: [TableItem] = []
        var currentState: State = .all

        let vc: TableViewManagerCompatible

        required init(vc: TableViewManagerCompatible) {
            self.vc = vc

            let total: [Int] = Array(1...10)
            self.allItems = total.map { (index) -> TableItem in
                let item = CustomItem(title: "Label  \(index)")
                item.onSelection = { item in
                    switch self.currentState {
                    case .all:
                        self.transition(to: .selected(item))
                    default:
                        self.transition(to: .all)
                    }
                    item.deselect(animated: true)
                }
                return item
            }
            self.transition(to: currentState)
        }

        func items(for state: State) -> [TableItem] {
            switch state {
            case .all:
                return allItems
            case .selected(let item):
                return [item]
            }
        }
    }

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableViewManager = TableViewManager(tableView: tableView)
        }
    }

    var tableViewManager: TableViewManager! {
        didSet {
            actionBarManager = ActionBarManager(manager: tableViewManager)
        }
    }
    var actionBarManager: ActionBarManager!
    var validator: ValidatorManager<String?> = ValidatorManager()

    var pickerControl: PickerControl?

    fileprivate var firstSection: FirstSection!

    override func viewDidLoad() {

        super.viewDidLoad()

        self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        self.tableView.sectionFooterHeight = UITableViewAutomaticDimension
        self.tableView.estimatedSectionHeaderHeight = 100
        self.tableView.estimatedSectionFooterHeight = 100

        firstSection = FirstSection(vc: self)
        tableViewManager.sections.append(firstSection)
        tableViewManager.sections.append(ThirdSection(vc: self))
        tableViewManager.sections.append(SecondSection(vc: self))

        // TODO think about a better way to handle self registration
        // In this way we do not take in consideration when the items changes
        tableViewManager.sections
            .flatMap { $0.items }
            .flatMap { $0 as? Validationable }
            .forEach { validator.add(validation: $0.validation) }

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Validate", style: .plain, target: self, action: #selector(validationAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done))
    }

    fileprivate func showPickerControl() {

        var elements = [PickerItem]()

        let options = ["Option 1", "Option 2", "Option 3"]
        options.forEach { elements.append(PickerItem(title: $0, value: $0)) }

        let pickerControl = PickerControl(elements: elements, selectCallback: { pickerControl, selectedElement in
            print(selectedElement)
            pickerControl.dismissPickerView()
            self.pickerControl = nil
        })
        pickerControl.presentPickerOnView(view)

        self.pickerControl = pickerControl
    }

    fileprivate func showDatePickerControl() {

        let toDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
        let pickerDateControl = PickerControl(datePickerMode: .date, fromDate: Date(), toDate: toDate, minuteInterval: 0, selectCallback: { pickerControl, date in

            pickerControl.dismissPickerView()
            print(date)

            self.pickerControl = nil

            }, cancelCallback: nil)
        pickerDateControl.presentPickerOnView(view)

        pickerControl = pickerDateControl
    }

    @objc fileprivate func validationAction() {
        firstSection.transition(to: firstSection.currentState == .preParty ? .onParty : .afterParty)
        guard let error = validator.errors.first else {
            print("No errors")
            return
        }
        print(error)
    }

    @objc fileprivate func done() {
        dismiss(animated: true, completion: nil)
    }

}
