//
//  NSIndexSet+Array.swift
//  Pods
//
//  Created by Alfredo Delli Bovi on 08/08/16.
//
//

import Foundation

extension NSIndexSet {
    
    convenience init(_ array: [Int]) {
        
        let mutable = NSMutableIndexSet()
        array.forEach{mutable.addIndex($0)}
        self.init(indexSet: mutable)
    }
}