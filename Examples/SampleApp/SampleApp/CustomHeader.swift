import UIKit
import TableViewKit

public class CustomHeaderFooterView: UITableViewHeaderFooterView {

    @IBOutlet weak var label: UILabel!
}

public class CustomHeaderDrawer: HeaderFooterDrawer {

    public static let nib = UINib(nibName: String(describing: CustomHeaderFooterView.self), bundle: nil)
    static public var type = HeaderFooterType.nib(CustomHeaderDrawer.nib, CustomHeaderFooterView.self)

    static public func draw(_ view: CustomHeaderFooterView, with item: CustomHeaderItem) {
        view.label.text = item.title
    }
}

public class CustomHeaderItem: HeaderFooter {
    public static var drawer = AnyHeaderFooterDrawer(CustomHeaderDrawer.self)

    public var title: String?
    public var height: Height? = .dynamic(44.0)

    public init() { }

    public convenience init(title: String) {
        self.init()
        self.title = title
    }
}
