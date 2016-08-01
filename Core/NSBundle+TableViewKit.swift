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
        
        if let bundlePath = NSBundle(forClass: TableViewManager.self).pathForResource("TableViewKit", ofType: "bundle") {
            return NSBundle(path: bundlePath)!
        }
        return NSBundle.mainBundle()
    }
}