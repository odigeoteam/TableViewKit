//
//  NSBundle+TableViewKit.swift
//  Pods
//
//  Created by Nelson Dominguez Leon on 01/08/16.
//
//

import Foundation

extension NSBundle {
    
    public class func tableViewKitBundle() -> NSBundle {
        let bundle = NSBundle(forClass: TableViewManager.self)
        if let bundlePath = bundle.pathForResource("TableViewKit", ofType: "bundle") {
            return NSBundle(path: bundlePath)!
        }
        return bundle
    }
}