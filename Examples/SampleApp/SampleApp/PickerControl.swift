import Foundation
import UIKit
import TableViewKit

struct Constants {
    
    enum Frame {
        
        static let PickerHeight = 260.0
        static let PickerViewHeight = 216.0
        static let NavigationBarHeight = 44.0
        static let HeaderViewHeight = 44.0
    }
    
    enum Animation {
        
        static let Duration = 0.3
    }
}

public protocol PickerItemProtocol: class {
    
    var title: String { get }
    var value: Any { get }
    
    init(title: String, value: Any)
}

public enum PickerControlType {
    case single, multiColumn, date
}

public enum PickerControlDismissType {
    case none, select, cancel
}

open class PickerItem: PickerItemProtocol, CustomStringConvertible {
    
    open var title: String
    open var value: Any
    
    public required init(title: String, value: Any) {
        self.title = title
        self.value = value
    }
    
    open var description: String {
        return title
    }
}

public typealias SelectCallBack = (PickerControl, Any) -> ()
public typealias CancelCallBack = (PickerControl) -> ()

open class PickerControl: NSObject {
    
    fileprivate var type: PickerControlType
    fileprivate var dismissType: PickerControlDismissType
    
    // Single columns
    fileprivate var items: [PickerItemProtocol]!
    fileprivate var selection: PickerItemProtocol!
    
    // Multicolumn
    fileprivate var components: [[PickerItemProtocol]]!
    fileprivate var selections: [PickerItemProtocol?]!
    
    // Date
    fileprivate var dateSelection: Date?
    
    fileprivate var pickerView: UIPickerView?
    fileprivate var datePicker: UIDatePicker?
    
    fileprivate var overlayLayerView: UIView!
    fileprivate var pickerContainerView: UIView!
    fileprivate var navigationBar: UINavigationBar!
    
    open var headerView: UIView?
    open var cancelButtonItem: UIBarButtonItem!
    open var okButtonItem: UIBarButtonItem!
    
    open var title: String?
    open var selectCallback: SelectCallBack?
    open var cancelCallback: CancelCallBack?
    
    // MARK: Constructors
    
    public override init() {
        
        type = .single
        dismissType = .cancel
        
        items = []
        components = []
        
        overlayLayerView = UIView()
        overlayLayerView.isUserInteractionEnabled = true
        overlayLayerView.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        pickerContainerView = UIView()
        pickerContainerView.backgroundColor = UIColor.white
        
        super.init()
        
        pickerView = UIPickerView()
        pickerView?.dataSource = self
        pickerView?.delegate = self
        pickerView?.autoresizingMask = .flexibleWidth
        
        datePicker = UIDatePicker()
        datePicker?.autoresizingMask = .flexibleWidth
        datePicker?.addTarget(self, action: #selector(datePickerDidChangeValue), for: .valueChanged)
        
        navigationBar = UINavigationBar()
        
        cancelButtonItem = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: self, action: #selector(cancelButtonPressed))
        okButtonItem = UIBarButtonItem(title: NSLocalizedString("OK", comment: ""), style: .plain, target: self, action: #selector(selectButtonPressed))
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
                
                type = .multiColumn
                
                // Column items
                var components: [PickerItemProtocol] = []
                
                for element in array {
                    
                    if element is PickerItemProtocol {
                        components.append(element as! PickerItemProtocol)
                    }
                    else {
                        let item = PickerItem(title: String(describing: element), value: element)
                        components.append(item)
                    }
                }
                
                if components.count != 0 {
                    self.components.append(components)
                    self.selections = Array.init(repeating: nil, count: self.components.count)
                }
            }
            else {
                let item = PickerItem(title: String(describing: value), value: value)
                items.append(item)
            }
        }
        
        self.selectCallback = selectCallback
        self.cancelCallback = cancelCallback
    }
    
    public convenience init(datePickerMode: UIDatePickerMode, fromDate: Date, toDate: Date, minuteInterval: Int, selectCallback: SelectCallBack? = nil, cancelCallback: CancelCallBack? = nil) {
        
        self.init()
        
        type = .date
        
        datePicker?.minimumDate = fromDate
        datePicker?.maximumDate = toDate
        datePicker?.minuteInterval = minuteInterval
        datePicker?.datePickerMode = datePickerMode
        
        self.selectCallback = selectCallback
        self.cancelCallback = cancelCallback
    }
    
    // MARK: Public methods
    
    open func presentPickerOnView(_ view: UIView) {
        
        let hostFrame = view.window!.frame
        
        // Hide keyboard
        view.endEditing(true)
        
        overlayLayerView.alpha = 0
        overlayLayerView.frame = hostFrame
        view.window?.addSubview(overlayLayerView)
        
        // Add gesture
        if dismissType == .select {
            let layerTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectButtonPressed))
            overlayLayerView.addGestureRecognizer(layerTapRecognizer)
        }
        else if dismissType == .cancel {
            let layerTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(cancelButtonPressed))
            overlayLayerView.addGestureRecognizer(layerTapRecognizer)
        }
        
        let extraHeight = headerView != nil ? CGFloat(Constants.Frame.HeaderViewHeight) : 0
        let pickerContainerSourceFrame = CGRect(x: 0, y: hostFrame.height, width: hostFrame.width, height: CGFloat(Constants.Frame.PickerHeight) + extraHeight)
        pickerContainerView.frame = pickerContainerSourceFrame
        view.window?.addSubview(pickerContainerView)
        
        // Add toolbar
        navigationBar.frame = CGRect(x: 0, y: 0, width: hostFrame.width, height: CGFloat(Constants.Frame.NavigationBarHeight))
        pickerContainerView.addSubview(navigationBar)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = 15
        
        let navigationItem = UINavigationItem()
        navigationItem.title = title
        navigationItem.leftBarButtonItems = [spacer, cancelButtonItem]
        navigationItem.rightBarButtonItems = [spacer, okButtonItem]
        navigationBar.pushItem(navigationItem, animated: false)
        
        if let headerView = headerView {
            
            headerView.frame = CGRect(x: 0, y: navigationBar.frame.maxY, width: hostFrame.width, height: CGFloat(Constants.Frame.NavigationBarHeight))
            pickerContainerView.addSubview(headerView)
        }
        
        let pickerViewFrame = CGRect(x: 0, y: CGFloat(Constants.Frame.NavigationBarHeight) + extraHeight, width: hostFrame.width, height: CGFloat(Constants.Frame.PickerViewHeight))
        if type == .single || type == .multiColumn {
            pickerView?.frame = pickerViewFrame
            pickerContainerView.addSubview(pickerView!)
        }
        else if type == .date {
            datePicker?.frame = pickerViewFrame
            pickerContainerView.addSubview(datePicker!)
        }
        
        UIView.animate(withDuration: Constants.Animation.Duration, animations: {
            self.overlayLayerView.alpha = 1.0
        })
        
        let pickerContainerDestinationFrame = CGRect(x: 0, y: hostFrame.height - CGFloat(Constants.Frame.PickerHeight) - extraHeight, width: hostFrame.width, height: CGFloat(Constants.Frame.PickerHeight) + extraHeight)
        UIView.animate(withDuration: Constants.Animation.Duration, delay: 0, options: [.curveEaseOut], animations: {
            self.pickerContainerView.frame = pickerContainerDestinationFrame
        }, completion: nil)
    }
    
    open func dismissPickerView() {
        
        let pickerContainerDestinationFrame = CGRect(x: 0, y: pickerContainerView.frame.origin.y + CGFloat(Constants.Frame.PickerHeight), width: pickerContainerView.frame.size.width, height: CGFloat(Constants.Frame.PickerHeight))
        
        UIView.animate(withDuration: Constants.Animation.Duration, animations: {
            self.overlayLayerView.alpha = 0
        }, completion: { finished in
            self.overlayLayerView.removeFromSuperview()
            if let gesture = self.overlayLayerView.gestureRecognizers?.first {
                self.overlayLayerView.removeGestureRecognizer(gesture)
            }
        })
        
        UIView.animate(withDuration: Constants.Animation.Duration, delay: 0, options: [.curveEaseIn], animations: {
            self.pickerContainerView.frame = pickerContainerDestinationFrame
        }, completion: { finished in
            self.pickerContainerView.removeFromSuperview()
        })
    }
    
    open func selectValue(_ value: PickerItemProtocol) {
        
        if type != .single {
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
    
    open func selectValue(_ value: PickerItemProtocol, component: Int) {
        
        if type != .multiColumn {
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
    
    open func selectValue(_ index: Int) {
        
        if type != .single {
            return
        }
        
        pickerView?.selectRow(index, inComponent: 0, animated: false)
    }
    
    open func selectValue(_ index: Int, component: Int) {
        
        if type != .multiColumn {
            return
        }
        
        pickerView?.selectRow(index, inComponent: component, animated: false)
    }
    
    open func selectDate(_ date: Date) {
        
        if type != .date {
            return
        }
        
        datePicker?.date = date
    }
    
    // MARK: Private methods
    
    fileprivate func updateSelection() {
        
        if type == .single {
            
            if items.count == 0 {
                return
            }
            
            let index = pickerView!.selectedRow(inComponent: 0)
            let item = items[index]
            selection = item
        }
        else if type == .multiColumn {
            
            if components.count == 0 {
                return
            }
            
            for columnIndex in 0 ..< pickerView!.numberOfComponents {
                let rowIndex = pickerView!.selectedRow(inComponent: columnIndex)
                let item = components[columnIndex][rowIndex]
                selections[columnIndex] = item
            }
        }
        else if type == .date {
            
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
        
        if type == .single {
            
            selectCallback?(self, selection)
        }
        else if type == .multiColumn {
            
            selectCallback?(self, selections)
        }
        else if type == .date {
            
            selectCallback?(self, dateSelection)
        }
        
        dismissPickerView()
    }
}

extension PickerControl: UIPickerViewDataSource {
    
    @objc public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        if type == .single {
            return 1
        }
        else if type == .multiColumn {
            return components.count
        }
        
        return 0
    }
    
    @objc public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if type == .single {
            return items.count
        }
        else if type == .multiColumn {
            let column = components[component]
            return column.count
        }
        
        return 0
    }
    
    @objc public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if type == .single {
            
            let item = items[row]
            return item.title
        }
        else if type == .multiColumn {
            
            let column = components[component]
            let item = column[row]
            return item.title
        }
        
        return nil
    }
}

extension PickerControl: UIPickerViewDelegate {
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        updateSelection()
    }
}

extension PickerControl: UIToolbarDelegate {
    
    public func position(for bar: UIBarPositioning) -> UIBarPosition {
        
        return .top
    }
}


