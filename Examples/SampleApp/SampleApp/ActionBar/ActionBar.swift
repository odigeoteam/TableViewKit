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

    func actionBar(_ actionBar: ActionBar, direction: Direction)
    func actionBar(_ actionBar: ActionBar, doneButtonPressed doneButtonItem: UIBarButtonItem)
}

open class ActionBar: UIToolbar {

    var navigationControl: UISegmentedControl!
    var actionBarDelegate: ActionBarDelegate!

    init(delegate: ActionBarDelegate) {

        super.init(frame: CGRect.zero)

        sizeToFit()

        actionBarDelegate = delegate

        setup()
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    fileprivate func setup() {

        let previousButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.init(rawValue: 105)!, target: self, action: #selector(previousHandler))
        let nextButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.init(rawValue: 106)!, target: self, action: #selector(nextHandler))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleActionBarDone))

        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = 40.0

        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        items = [previousButtonItem, spacer, nextButtonItem, flexible, doneButton]
    }

    @objc func handleActionBarDone(_ item: UIBarButtonItem) {
        actionBarDelegate.actionBar(self, doneButtonPressed: item)
    }

    @objc func previousHandler(_ sender: UIBarButtonItem) {
        actionBarDelegate.actionBar(self, direction: .previous)
    }

    @objc func nextHandler(_ sender: UIBarButtonItem) {
        actionBarDelegate.actionBar(self, direction: .next)
    }
}
