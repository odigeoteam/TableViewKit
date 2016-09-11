//
//  TextFieldCell.swift
//  ExampleTableViewKit
//
//  Created by Alfredo Delli Bovi on 28/07/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import Foundation
import TableViewKit

public class TextFieldCell: BaseCell, ActionBarDelegate {
    
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
    
    public func actionBar(_ actionBar: ActionBar, direction: Direction) -> IndexPath? {
        return textFieldItem.actionBar(actionBar, direction: direction)
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
    public static let cellType = CellType.nib(TextFieldDrawer.nib, TextFieldCell.self)
    
    public static func
        draw(_ cell: BaseCell, withItem item: Any) {
        
        let textCell = cell as! TextFieldCell
        let textItem = item as! TextFieldItem
        
        textCell.textField.placeholder = textItem.placeHolder
        textCell.textField.text = textItem.value
    }
}

public class TextFieldItem: UIResponder, Item, ContentValidatable, Validationable {
        
    public var drawer: CellDrawer.Type = TextFieldDrawer.self
    
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

extension TextFieldItem: ActionBarDelegate {

    public func actionBar(_ actionBar: ActionBar, direction: Direction) -> IndexPath? {
        return actionBarDelegate.actionBar(actionBar, direction: direction)
    }

    public func actionBar(_ actionBar: ActionBar, doneButtonPressed doneButtonItem: UIBarButtonItem) { }

}
