//
//  NSIndexSet+Array.swift
//  Pods
//
//  Created by Alfredo Delli Bovi on 08/08/16.
//
//

import Foundation

extension IndexSet {

    init(_ array: [Int]) {

        let mutable = NSMutableIndexSet()
        array.forEach {mutable.add($0)}
        self.init(mutable)
    }
}
