//
//  ActionBar.swift
//  TableViewKit
//
//  Created by Nelson Dominguez Leon on 22/06/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import Foundation
import UIKit

public enum Direction {
    case next
    case previous
}

public protocol ActionBarDelegate {
    
    func actionBar(actionBar: ActionBar, direction: Direction)
    func actionBar(actionBar: ActionBar, doneButtonPressed doneButtonItem: UIBarButtonItem)
}

public class ActionBar: UIToolbar {
    
    var navigationControl: UISegmentedControl!
    var actionBarDelegate: ActionBarDelegate!
    
    init(delegate: ActionBarDelegate) {
        
        super.init(frame: CGRectZero)
        
        sizeToFit()
        
        actionBarDelegate = delegate
        
        setup()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    private func setup() {
        
        let previousButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.init(rawValue: 105)!, target: self, action: #selector(previousHandler))
        let nextButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.init(rawValue: 106)!, target: self, action: #selector(nextHandler))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(handleActionBarDone))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        spacer.width = 40.0
        
        let flexible = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        
        items = [previousButtonItem, spacer, nextButtonItem, flexible, doneButton]
    }
    
    @objc func handleActionBarDone(item: UIBarButtonItem) {
        actionBarDelegate.actionBar(self, doneButtonPressed: item)
    }
    
    @objc func previousHandler(sender: UIBarButtonItem) {
        actionBarDelegate.actionBar(self, direction: .previous)
    }
    
    @objc func nextHandler(sender: UIBarButtonItem) {
        actionBarDelegate.actionBar(self, direction: .next)
    }
}