//
//  TextFieldCell.swift
//  ExampleTableViewKit
//
//  Created by Alfredo Delli Bovi on 28/07/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import Foundation
import TableViewKit

public class TextFieldCell: BaseCell {
    
    public var textFieldItem: TextFieldItem {
        get {
            return item as! TextFieldItem
        }
    }
    
    @IBOutlet var textField: UITextField!
    
    override public func awakeFromNib() {
        
        super.awakeFromNib()
        
        selectionStyle = .None
        responder = textField
        
        textField.addTarget(self, action: #selector(onTextChange), forControlEvents: .EditingChanged)
        textField.inputAccessoryView = actionBar
    }
    
    public func onTextChange(textField: UITextField) {
        textFieldItem.value = textField.text
    }

}

public class TextFieldDrawer: CellDrawer {
    
    public static let nib = UINib(nibName: String(TextFieldCell.self), bundle: nil)
    public static let cellType = CellType.Nib(TextFieldDrawer.nib, TextFieldCell.self)
    
    public static func draw(cell: BaseCell, withItem item: Any) {
        
        let textCell = cell as! TextFieldCell
        let textItem = item as! TextFieldItem
        
        textCell.textField.placeholder = textItem.placeHolder
        textCell.textField.text = textItem.value
    }
}

public class TextFieldItem: ItemProtocol, ContentValidatable, Validationable {
        
    public var drawer: CellDrawer.Type = TextFieldDrawer.self
    
    public lazy var validation: Validation<String?> = {
        return Validation<String?>(forInput: self, withIdentifier: self)
    }()
    
    public var placeHolder: String?
    public var value: String?
    
    public init(placeHolder: String?) {
        self.placeHolder = placeHolder
    }
    
    public var validationContent: String? {
        get {
            return value
        }
    }
}
