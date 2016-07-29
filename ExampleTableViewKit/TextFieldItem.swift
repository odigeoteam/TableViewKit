//
//  TextFieldCell.swift
//  ExampleTableViewKit
//
//  Created by Alfredo Delli Bovi on 28/07/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import Foundation
import TableViewKit

class TextFieldCell: TableViewCell {
    
    var textFieldItem: TextFieldItem {
        get {
            return item as! TextFieldItem
        }
    }
    
    @IBOutlet var textField: UITextField!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        selectionStyle = .None
        responder = textField
        
        textField.addTarget(self, action: #selector(onTextChange), forControlEvents: UIControlEvents.EditingChanged)
        textField.inputAccessoryView = actionBar
    }
    
    func onTextChange(textField: UITextField) {
        textFieldItem.value = textField.text
    }

}

class TextFieldItem: TableViewItem, ContentValidatable, Validationable {

    lazy var validation: Validation<String?> = {
        return Validation<String?>(forInput: self, withIdentifier: self)
    }()
    
    var placeHolder: String?
    var value: String?
    
    override init() {
        super.init()
        drawer = TextFieldDrawer()
        cellHeight = 51
    }
    
    var validationContent: String? {
        get {
            return value
        }
    }
}

class TextFieldDrawer: TableViewDrawerCellProtocol {
    
    static let nib = UINib(nibName: String(TextFieldCell.self), bundle: NSBundle.mainBundle())
    let cell = TableViewCellType.Nib(TextFieldDrawer.nib, TextFieldCell.self)
    
    func draw(cell cell: TableViewCell, withItem item: TableViewItemProtocol) {

        let textCell = cell as! TextFieldCell
        let textItem = item as! TextFieldItem
        
        textCell.textField.placeholder = textItem.placeHolder
        textCell.textField.text = textItem.value
    }
}