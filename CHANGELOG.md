# Change Log
All notable changes to this project will be documented in this file.

---
## [Unreleased]

- Update to Swift 4.2 ([PR#42](https://github.com/odigeoteam/TableViewKit/pull/42))
- Improved initial slicing for diff algorithm ([PR#39](https://github.com/odigeoteam/TableViewKit/pull/39))
- Fixed ObservableArray setter ([PR#38](https://github.com/odigeoteam/TableViewKit/pull/38))
- Improved/Fixed examples ([PR#34](https://github.com/odigeoteam/TableViewKit/pull/34), [PR#35](https://github.com/odigeoteam/TableViewKit/pull/35))
- Added *prototype* cell type to use with Storyboard's prototype cells ([PR#36](https://github.com/odigeoteam/TableViewKit/pull/36))
- Added `TableViewKitViewController` as an inheritable View Controller as a helper ([PR#37](https://github.com/odigeoteam/TableViewKit/pull/37))

## [1.2.0]
### Added
- Official support to Swift 4
- Support for `TableItem` method `redraw()`
- Support for `scrollViewWillEndDragging`
- Support for item's `copy` and `paste` action via `ActionPerformable`
### Changed
- Deprecated `Item` in favour of `TableItem`
- Deprecated `Section` in favour of `TableSection`
- Optimize diff algorithm used by `ObservableArray` for common methods such as `insert(at:)`, `remove(at:)` etc...
- Fix a bug where `manager` was not set correctly on `Item` or `Section`
- Fix memory ownership of `ObservableArray` for Swift 4

## [1.1.0]
### Added
- Support `TableViewManager` as `manager` property of `Item` and `Section`
- Support `UIScrollViewDelegate` from `TableViewManager` via `scrollDelegate`

### Changed
- Move `UITableViewDataSource` and `UITableViewDelegate` implementations from `TableViewManager` to `TableViewKitDataSource` and `TableViewKitDelegate` which are now the properties: `dataSource` and `delegate`, respectively.
- Method `Item.section(in:)` has been renamed to `Item.section`
- Method `Item.indexPath(in:)` has been renamed to `Item.indexPath`
- Method `Item.reload(in:with:)` has been renamed to `Item.reload(with:)`
- Method `Item.select(in:animated:scrollPosition:)` has been renamed to `Item.select(animated:scrollPosition:)`
- Method `Item.select(in:animated:scrollPosition:)` has been renamed to `Item.select(animated:scrollPosition:)`
- Method `Item.deselect(in:animated:)` has been renamed to `Item.deselect(animated:)`
- Method `Section.index(in:)` has been renamed to `Section.index`
