# ODGTableViewKit

ODGTableViewKit allows to manage the content of any `UITableView`, and use the `Strategy` pattern for draw cells.

## Usage

First, you need to create a instance of `ODGTableViewManager` and pass your tableView in the constructor.

``` swift
override func viewDidLoad() {
        
   super.viewDidLoad()
        
   tableViewManager = ODGTableViewManager(tableView: self.tableView, delegate: nil)
        
   let section = ODGTableViewSection(headerTitle: "Section title")
   section.footerTitle = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
   tableViewManager.addSection(section)
   
   let item = ODGTableViewItem(title: "Item 1", subtitle: nil)
   item.image = UIImage(named: "image")
   item.accessoryType = .DisclosureIndicator
   item.selectionHandler = { item in
       item.deselectRowAnimated(true)
   }
   section.addItem(item)
}
```
## Requirements
* Xcode 7 or higher
* iOS 8.0 or higher

## Installation
### - Cocoapods
The recommended approach for installing `ODGTableViewKit` is via the [CocoaPods](http://cocoapods.org/) package manager, as it provides flexible dependency management and dead simple installation.
For best results, it is recommended that you install via CocoaPods >= **1.0.0**

Install CocoaPods if not already available:

``` bash
$ [sudo] gem install cocoapods
```

Change to the directory of your Xcode project:

``` bash
$ cd /path/to/MyProject
$ touch Podfile
$ edit Podfile
```

Edit your Podfile and add ODGTableViewKit:

``` bash
platform :ios, '8.0'
use_frameworks!

target 'MyProject' do
	pod 'ODGTableViewKit', '~> 0.1'
end
```

Install into your Xcode project:

``` bash
$ pod install
```

Open your project in Xcode from the .xcworkspace file (not the usual project file)

``` bash
$ open MyProject.xcworkspace
```
## Demo
To build the demo you need to execute in the root directory.
``` bash
$ pod install
$ open TableViewKit.xcworkspace
```

## Examples
Create a custom item and custom cell

### 1. Inherits from `ODGTableViewCell`
``` swift
class CustomCell: ODGTableViewCell {
    
}
```
### 2. Inherits from `ODGTableViewDrawerCell` and `ODGTableViewItem`
``` swift
class CustomItem: ODGTableViewItem {

    override init() {
        super.init()
        // Specify the drawer used in this item
        drawer = CustomDrawer()
    }
}

class CustomDrawer: ODGTableViewDrawerCell {
    // Specify the type of the cell you want to use
    override func cellClass() -> ODGTableViewCell.Type {
        return CustomCell.self
    }
}
```
### 3. If you've made the design of the cell in xib, you need to include this line of code
``` swift
tableViewManager.registerCell(CustomCell.self)
```
## Contact
iOS Mobile Team
ios-dev@odigeo.com
