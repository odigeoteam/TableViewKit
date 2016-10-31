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

    var type: MoreAboutItemType
    var title: String?
    
    var drawer: CellDrawer.Type = MoreAboutDrawer.self
    var onSelection: (Selectable) -> () = { _ in }
    
    var editingStyle: TableViewCellEditingStyle = .delete("Remove", { 
        print("Delete Cell")
    })
    
    var rowActions: [UITableViewRowAction]?
    
    init(type: MoreAboutItemType) {
        
        self.type = type
        self.title = type.title()
    }
}
