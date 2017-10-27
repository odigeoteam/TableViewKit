import Foundation
import TableViewKit

public class TextFieldCell: UITableViewCell, ItemCompatible, ActionBarDelegate {

    public var item: TableItem?

    public var textFieldItem: TextFieldItem {
        get {
            return item as! TextFieldItem
        }
    }

    @IBOutlet var textField: UITextField!

    override public func awakeFromNib() {

        super.awakeFromNib()

        selectionStyle = .none

        textField.addTarget(self, action: #selector(onTextChange), for: .editingChanged)
        textField.inputAccessoryView = ActionBar(delegate: self)

    }

    public func onTextChange(textField: UITextField) {
        textFieldItem.value = textField.text
    }

    public func actionBar(_ actionBar: ActionBar, direction: Direction) {
        textFieldItem.actionBarDelegate.actionBar(actionBar, direction: direction)
    }
    public func actionBar(_ actionBar: ActionBar, doneButtonPressed doneButtonItem: UIBarButtonItem) {
        textField.resignFirstResponder()
    }

    override open var isFirstResponder: Bool {
        get {
            return textField.isFirstResponder
        }
    }

    override open func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }

}

public class TextFieldDrawer: CellDrawer {

    public static let nib = UINib(nibName: String(describing: TextFieldCell.self), bundle: nil)
    public static let type = CellType.nib(TextFieldDrawer.nib, TextFieldCell.self)

    public static func draw(_ cell: TextFieldCell, with item: TextFieldItem) {
        cell.textField.placeholder = item.placeHolder
        cell.textField.text = item.value
    }
}

public class TextFieldItem: UIResponder, TableItem, ContentValidatable, Validationable {

    public static var drawer = AnyCellDrawer(TextFieldDrawer.self)

    public lazy var validation: Validation<String?> = {
        return Validation<String?>(forInput: self, withIdentifier: self)
    }()

    public var placeHolder: String?
    public var value: String?

    fileprivate let actionBarDelegate: ActionBarDelegate

    public init(placeHolder: String?, actionBarDelegate: ActionBarDelegate) {
        self.placeHolder = placeHolder
        self.actionBarDelegate = actionBarDelegate
    }

    public var validationContent: String? {
        get {
            return value
        }
    }

    override open var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
}
