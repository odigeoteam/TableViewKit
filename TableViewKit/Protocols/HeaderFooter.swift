//
//  HeaderFooter.swift
//  TableViewKit
//
//  Created by Alfredo Delli Bovi on 05/09/16.
//  Copyright © 2016 odigeo. All rights reserved.
//

import Foundation

public enum HeaderFooterView: ExpressibleByNilLiteral {
    case title(String)
    case view(HeaderFooter)
    case none
    
    public init(nilLiteral: ()) {
        self = .none
    }
}

public protocol HeaderFooter: class {
    var drawer: HeaderFooterDrawer.Type { get }
    var height: Height? { get }
}
