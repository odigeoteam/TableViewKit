//
//  MoreAboutSection.swift
//  TableViewKit+VIPER
//
//  Created by Nelson Dominguez Leon on 07/09/16.
//  Copyright © 2016 eDreams Odigeo. All rights reserved.
//

import Foundation
import TableViewKit

class MoreAboutSection: Section {
    
    var items: ObservableArray<Item> = []
    var header: HeaderFooterView = .title("More about eDreams")
    let presenter: AboutPresenterProtocol?
    weak var manager: TableViewManager?
    
    required init(presenter: AboutPresenterProtocol?, manager: TableViewManager?) {
        
        self.presenter = presenter
        self.manager = manager
        
        let types: [MoreAboutItemType] = [.faq, .contact, .terms, .feedback, .share, .rate]
        for type in types {
            let moreAboutItem = MoreAboutItem(type: type)
            moreAboutItem.onSelection = { item in
                
                switch type {
                case .faq:
                    self.presenter?.showFaq()
                case .contact:
                    self.presenter?.showContactUs()
                case .terms:
                    self.presenter?.showTermsAndConditions()
                case .feedback:
                    self.presenter?.showFeedback()
                case .share:
                    self.presenter?.showShareApp()
                case .rate:
                    self.presenter?.showRateApp()
                }
                
                guard let manager = self.manager else { return }
                item.deselect(inManager: manager, animated: true)
            }
            items.append(moreAboutItem)
        }
    }
}
