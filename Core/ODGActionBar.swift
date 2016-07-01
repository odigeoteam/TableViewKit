//
//  ODGActionBar.swift
//  TableViewKit
//
//  Created by Nelson Dominguez Leon on 22/06/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import Foundation
import UIKit

public protocol ODGActionBarDelegate {
    
    func actionBar(actionBar: ODGActionBar, navigationControlValueChanged navigationControl: UISegmentedControl)
    func actionBar(actionBar: ODGActionBar, doneButtonPressed doneButtonItem: UIBarButtonItem)
}

public class ODGActionBar: UIToolbar {
    
    var navigationControl: UISegmentedControl!
    var actionBarDelegate: ODGActionBarDelegate!
    
    init(delegate: ODGActionBarDelegate) {
        
        super.init(frame: CGRectZero)
        
        sizeToFit()
        
        actionBarDelegate = delegate
        
        setup()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    private func setup() {
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(handleActionBarDone))
        
        navigationControl = UISegmentedControl(items: ["Previous", "Next"])
        navigationControl.momentary = true
        navigationControl.addTarget(self, action: #selector(handleActionBarPreviousNext), forControlEvents: .ValueChanged)
        navigationControl.setDividerImage(UIImage(), forLeftSegmentState: .Normal, rightSegmentState: .Normal, barMetrics: .Default)
        
        navigationControl.setImage(UIImage(named: "UIButtonBarArrowLeft"), forSegmentAtIndex: 0)
        navigationControl.setWidth(50.0, forSegmentAtIndex: 0)
        navigationControl.setImage(UIImage(named: "UIButtonBarArrowRight"), forSegmentAtIndex: 1)
        navigationControl.setWidth(50.0, forSegmentAtIndex: 1)
        
        navigationControl.setBackgroundImage(UIImage(named: "Transparent"), forState: .Normal, barMetrics: .Default)
        
        let prevNextWrapper = UIBarButtonItem(customView: navigationControl)
        let flexible = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        
        items = [prevNextWrapper, flexible, doneButton]
    }
    
    @objc func handleActionBarDone(item: UIBarButtonItem) {
        
        actionBarDelegate.actionBar(self, doneButtonPressed: item)
    }
    
    @objc func handleActionBarPreviousNext() {
        
        actionBarDelegate.actionBar(self, navigationControlValueChanged: navigationControl)
    }
}