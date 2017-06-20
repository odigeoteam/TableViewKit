# Change Log
All notable changes to this project will be documented in this file.

---

## [Unreleased]
### Added
- Support `UIScrollViewDelegate` from `TableViewManager` via `scrollDelegate`

### Changed
- Move `UITableViewDataSource` and `UITableViewDelegate` implementations from `TableViewManager` to `TableViewKitDataSource` and `TableViewKitDelegate` which are now the properties: `dataSource` and `delegate`, respectively.
