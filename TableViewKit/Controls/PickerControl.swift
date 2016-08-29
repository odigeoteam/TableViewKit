//
//  File.swift
//  TableViewKit
//
//  Created by Nelson Dominguez Leon on 27/06/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import Foundation
import UIKit

public protocol PickerItemProtocol: class {
    
    var title: String { get }
    var value: Any { get }
    
    init(title: String, value: Any)
}

public enum PickerControlType {
    case Single, MultiColumn, Date
}

public enum PickerControlDismissType {
    case None, Select, Cancel
}

public class PickerItem: PickerItemProtocol, CustomStringConvertible {
    
    public var title: String
    public var value: Any
    
    public required init(title: String, value: Any) {
        self.title = title
        self.value = value
    }
    
    public var description: String {
        return title
    }
}

public typealias SelectCallBack = (PickerControl, Any) -> ()
public typealias CancelCallBack = (PickerControl) -> ()

public class PickerControl: NSObject {
    
    private var type: PickerControlType
    private var dismissType: PickerControlDismissType
    
    // Single columns
    private var items: [PickerItemProtocol]!
    private var selection: PickerItemProtocol!
    
    // Multicolumn
    private var components: [[PickerItemProtocol]]!
    private var selections: [PickerItemProtocol!]!
    
    // Date
    private var dateSelection: NSDate?
    
    private var pickerView: UIPickerView?
    private var datePicker: UIDatePicker?
    
    private var overlayLayerView: UIView!
    private var pickerContainerView: UIView!
    private var navigationBar: UINavigationBar!
    
    public var headerView: UIView?
    public var cancelButtonItem: UIBarButtonItem!
    public var okButtonItem: UIBarButtonItem!
    
    public var title: String?
    public var selectCallback: SelectCallBack?
    public var cancelCallback: CancelCallBack?
    
    // MARK: Constructors
    
    public override init() {
        
        type = .Single
        dismissType = .Cancel
        
        items = []
        components = []
        
        overlayLayerView = UIView()
        overlayLayerView.userInteractionEnabled = true
        overlayLayerView.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        pickerContainerView = UIView()
        pickerContainerView.backgroundColor = UIColor.whiteColor()
        
        super.init()
        
        pickerView = UIPickerView()
        pickerView?.dataSource = self
        pickerView?.delegate = self
        pickerView?.autoresizingMask = .FlexibleWidth
        
        datePicker = UIDatePicker()
        datePicker?.autoresizingMask = .FlexibleWidth
        datePicker?.addTarget(self, action: #selector(datePickerDidChangeValue), forControlEvents: .ValueChanged)
        
        navigationBar = UINavigationBar()
        
        cancelButtonItem = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .Plain, target: self, action: #selector(cancelButtonPressed))
        okButtonItem = UIBarButtonItem(title: NSLocalizedString("OK", comment: ""), style: .Plain, target: self, action: #selector(selectButtonPressed))
    }
    
    public convenience init(elements: [AnyObject], selectCallback: SelectCallBack? = nil, cancelCallback: CancelCallBack? = nil) {
        
        self.init()
        
        for value in elements {
            
            // Each item is PickerItem
            if value is PickerItemProtocol {
                items.append(value as! PickerItemProtocol)
            }
            // We have a array
            else if let array = value as? [AnyObject] {
                
                type = .MultiColumn
                
                // Column items
                var components: [PickerItemProtocol] = []
                
                for element in array {
                    
                    if element is PickerItemProtocol {
                        components.append(element as! PickerItemProtocol)
                    }
                    else {
                        let item = PickerItem(title: String(element), value: element)
                        components.append(item)
                    }
                }
                
                if components.count != 0 {
                    self.components.append(components)
                    self.selections = Array.init(count: self.components.count, repeatedValue: nil)
                }
            }
            else {
                let item = PickerItem(title: String(value), value: value)
                items.append(item)
            }
        }
        
        self.selectCallback = selectCallback
        self.cancelCallback = cancelCallback
    }
    
    public convenience init(datePickerMode: UIDatePickerMode, fromDate: NSDate, toDate: NSDate, minuteInterval: Int, selectCallback: SelectCallBack? = nil, cancelCallback: CancelCallBack? = nil) {
        
        self.init()
        
        type = .Date
        
        datePicker?.minimumDate = fromDate
        datePicker?.maximumDate = toDate
        datePicker?.minuteInterval = minuteInterval
        datePicker?.datePickerMode = datePickerMode
        
        self.selectCallback = selectCallback
        self.cancelCallback = cancelCallback
    }
    
    // MARK: Public methods
    
    public func presentPickerOnView(view: UIView) {
        
        let hostFrame = view.window!.frame
        
        // Hide keyboard
        view.endEditing(true)
        
        overlayLayerView.alpha = 0
        overlayLayerView.frame = hostFrame
        view.window?.addSubview(overlayLayerView)
        
        // Add gesture
        if dismissType == .Select {
            let layerTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectButtonPressed))
            overlayLayerView.addGestureRecognizer(layerTapRecognizer)
        }
        else if dismissType == .Cancel {
            let layerTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(cancelButtonPressed))
            overlayLayerView.addGestureRecognizer(layerTapRecognizer)
        }
        
        let extraHeight = headerView != nil ? CGFloat(Constants.Frame.HeaderViewHeight) : 0
        let pickerContainerSourceFrame = CGRectMake(0, CGRectGetHeight(hostFrame), CGRectGetWidth(hostFrame), CGFloat(Constants.Frame.PickerHeight) + extraHeight)
        pickerContainerView.frame = pickerContainerSourceFrame
        view.window?.addSubview(pickerContainerView)
        
        // Add toolbar
        navigationBar.frame = CGRectMake(0, 0, CGRectGetWidth(hostFrame), CGFloat(Constants.Frame.NavigationBarHeight))
        pickerContainerView.addSubview(navigationBar)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        spacer.width = 15
        
        let navigationItem = UINavigationItem()
        navigationItem.title = title
        navigationItem.leftBarButtonItems = [spacer, cancelButtonItem]
        navigationItem.rightBarButtonItems = [spacer, okButtonItem]
        navigationBar.pushNavigationItem(navigationItem, animated: false)
        
        if let headerView = headerView {
            
            headerView.frame = CGRectMake(0, CGRectGetMaxY(navigationBar.frame), CGRectGetWidth(hostFrame), CGFloat(Constants.Frame.NavigationBarHeight))
            pickerContainerView.addSubview(headerView)
        }
        
        let pickerViewFrame = CGRectMake(0, CGFloat(Constants.Frame.NavigationBarHeight) + extraHeight, CGRectGetWidth(hostFrame), CGFloat(Constants.Frame.PickerViewHeight))
        if type == .Single || type == .MultiColumn {
            pickerView?.frame = pickerViewFrame
            pickerContainerView.addSubview(pickerView!)
        }
        else if type == .Date {
            datePicker?.frame = pickerViewFrame
            pickerContainerView.addSubview(datePicker!)
        }
        
        UIView.animateWithDuration(Constants.Animation.Duration, animations: {
            self.overlayLayerView.alpha = 1.0
        })
        
        let pickerContainerDestinationFrame = CGRectMake(0, CGRectGetHeight(hostFrame) - CGFloat(Constants.Frame.PickerHeight) - extraHeight, CGRectGetWidth(hostFrame), CGFloat(Constants.Frame.PickerHeight) + extraHeight)
        UIView.animateWithDuration(Constants.Animation.Duration, delay: 0, options: [.CurveEaseOut], animations: {
            self.pickerContainerView.frame = pickerContainerDestinationFrame
        }, completion: nil)
    }
    
    public func dismissPickerView() {
        
        let pickerContainerDestinationFrame = CGRectMake(0, pickerContainerView.frame.origin.y + CGFloat(Constants.Frame.PickerHeight), pickerContainerView.frame.size.width, CGFloat(Constants.Frame.PickerHeight))
        
        UIView.animateWithDuration(Constants.Animation.Duration, animations: {
            self.overlayLayerView.alpha = 0
        }, completion: { finished in
            self.overlayLayerView.removeFromSuperview()
            if let gesture = self.overlayLayerView.gestureRecognizers?.first {
                self.overlayLayerView.removeGestureRecognizer(gesture)
            }
        })
        
        UIView.animateWithDuration(Constants.Animation.Duration, delay: 0, options: [.CurveEaseIn], animations: {
            self.pickerContainerView.frame = pickerContainerDestinationFrame
        }, completion: { finished in
            self.pickerContainerView.removeFromSuperview()
        })
    }
    
    public func selectValue(value: PickerItemProtocol) {
        
        if type != .Single {
            return
        }
        
        for index in 0 ..< items.count {
            let item = items[index]
            if item === value {
                pickerView?.selectRow(index, inComponent: 0, animated: false)
                break
            }
        }
    }
    
    public func selectValue(value: PickerItemProtocol, component: Int) {
        
        if type != .MultiColumn {
            return
        }
        
        let column = components[component]
        for index in 0 ..< column.count {
            let item = column[index]
            if item === value {
                pickerView?.selectRow(index, inComponent: component, animated: false)
                break
            }
        }
    }
    
    public func selectValue(index: Int) {
        
        if type != .Single {
            return
        }
        
        pickerView?.selectRow(index, inComponent: 0, animated: false)
    }
    
    public func selectValue(index: Int, component: Int) {
        
        if type != .MultiColumn {
            return
        }
        
        pickerView?.selectRow(index, inComponent: component, animated: false)
    }
    
    public func selectDate(date: NSDate) {
        
        if type != .Date {
            return
        }
        
        datePicker?.date = date
    }
    
    // MARK: Private methods
    
    private func updateSelection() {
        
        if type == .Single {
            
            if items.count == 0 {
                return
            }
            
            let index = pickerView!.selectedRowInComponent(0)
            let item = items[index]
            selection = item
        }
        else if type == .MultiColumn {
            
            if components.count == 0 {
                return
            }
            
            for columnIndex in 0 ..< pickerView!.numberOfComponents {
                let rowIndex = pickerView!.selectedRowInComponent(columnIndex)
                let item = components[columnIndex][rowIndex]
                selections[columnIndex] = item
            }
        }
        else if type == .Date {
            
            dateSelection = datePicker?.date
        }
    }
    
    // MARK: Selectors
    
    @objc func datePickerDidChangeValue() {
        
        dateSelection = datePicker?.date
    }
    
    @objc func cancelButtonPressed() {
        
        dismissPickerView()
    }
    
    @objc func selectButtonPressed() {
        
        updateSelection()
        
        if type == .Single {
            
            selectCallback?(self, selection)
        }
        else if type == .MultiColumn {
            
            selectCallback?(self, selections)
        }
        else if type == .Date {
            
            selectCallback?(self, dateSelection)
        }
        
        dismissPickerView()
    }
}

extension PickerControl: UIPickerViewDataSource {
    
    @objc public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        if type == .Single {
            return 1
        }
        else if type == .MultiColumn {
            return components.count
        }
        
        return 0
    }
    
    @objc public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if type == .Single {
            return items.count
        }
        else if type == .MultiColumn {
            let column = components[component]
            return column.count
        }
        
        return 0
    }
    
    @objc public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if type == .Single {
            
            let item = items[row]
            return item.title
        }
        else if type == .MultiColumn {
            
            let column = components[component]
            let item = column[row]
            return item.title
        }
        
        return nil
    }
}

extension PickerControl: UIPickerViewDelegate {
    
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        updateSelection()
    }
}

extension PickerControl: UIToolbarDelegate {
    
    public func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        
        return .Top
    }
}


