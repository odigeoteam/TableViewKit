//
//  CustomHeader.swift
//  Pods
//
//  Created by Alfredo Delli Bovi on 04/09/16.
//
//

import UIKit
import TableViewKit

public class CustomHeaderFooterView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var label: UILabel!
}


public class CustomHeaderDrawer: HeaderFooterDrawer {
    
    public static let nib = UINib(nibName: String(CustomHeaderFooterView.self), bundle: nil)
    static public var headerFooterType = HeaderFooterType.Nib(CustomHeaderDrawer.nib, CustomHeaderFooterView.self)
    
    static public func draw(view: UITableViewHeaderFooterView, withItem item: Any) {
        let item = item as! CustomHeaderItem
        let view = view as! CustomHeaderFooterView
        view.label.text = item.title
    }
}


public class CustomHeaderItem: HeaderFooter {
    
    public var title: String?
    public var height: ImmutableMutableHeight? = ImmutableMutableHeight.mutable(44.0)
    
    public var drawer: HeaderFooterDrawer.Type = CustomHeaderDrawer.self
    
    public init() { }
    
    public convenience init(title: String) {
        self.init()
        self.title = title
    }
}
