//
//  HeaderFooter.swift
//  TableViewKit
//
//  Created by Alfredo Delli Bovi on 05/09/16.
//  Copyright © 2016 odigeo. All rights reserved.
//

import Foundation

public protocol HeaderFooter: class {
    var drawer: HeaderFooterDrawer.Type { get }
    var height: ImmutableMutableHeight? { get }
}
