//
//  HeaderFooter.swift
//  TableViewKit
//
//  Created by Alfredo Delli Bovi on 05/09/16.
//  Copyright © 2016 odigeo. All rights reserved.
//

import Foundation

public enum HeaderFooterView: ExpressibleByNilLiteral, Equatable {
    case title(String)
    case view(HeaderFooter)
    case none
    
    public init(nilLiteral: ()) {
        self = .none
    }
}
public func == (lhs: HeaderFooterView, rhs: HeaderFooterView) -> Bool {
    switch (lhs, rhs) {
    case (.none, .none):
        return true
    case (.view(let lhs), .view(let rhs)):
        return lhs === rhs
    case (.title(let lhs), .title(let rhs)):
        return lhs == rhs
    default:
        return false
    }
}

public protocol HeaderFooter: class {
    var drawer: HeaderFooterDrawer.Type { get }
    var height: ImmutableMutableHeight? { get }
}
