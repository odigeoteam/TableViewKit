import Foundation
import TableViewKit

enum MoreAboutItemType {
    
    case faq, contact, terms, feedback, share, rate
    
    func title() -> String {
        switch self {
        case .faq:
            return "FAQ"
        case .contact:
            return "Contact Us"
        case .terms:
            return "Terms and Conditions"
        case .feedback:
            return "Send us your feedback"
        case .share:
            return "Share the app"
        case .rate:
            return "Rate the app"
        }
    }
}

class MoreAboutItem: Item, Selectable, Editable {
    public static var drawer = CellDrawerOf(MoreAboutDrawer.self)

    var type: MoreAboutItemType
    var title: String?
    
    var onSelection: (Selectable) -> () = { _ in }
    
    var actions: [UITableViewRowAction]?
    weak var manager: TableViewManager?
    let presenter: AboutPresenterProtocol?

    init(type: MoreAboutItemType, presenter: AboutPresenterProtocol?, manager: TableViewManager?) {
        self.presenter = presenter
        self.manager = manager
        self.type = type
        self.title = type.title()
    }
    
    func didSelect() {
        switch type {
        case .faq:
            presenter?.showFaq()
        case .contact:
            presenter?.showContactUs()
        case .terms:
            presenter?.showTermsAndConditions()
        case .feedback:
            presenter?.showFeedback()
        case .share:
            presenter?.showShareApp()
        case .rate:
            presenter?.showRateApp()
        }
        
        if let manager = manager {
            deselect(in: manager, animated: true)
        }
    }
}
