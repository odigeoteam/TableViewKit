//
//  AboutWireFrame.swift
//  TableViewKit+VIPER
//
//  Created by Nelson Dominguez Leon on 06/09/16.
//  Copyright © 2016 eDreams Odigeo. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

class AboutWireFrame: AboutWireFrameProtocol {
    
    fileprivate var viewController: AboutViewController?
    
    func presentAboutViewModule(_ navigationController: UINavigationController) {
        
        let presenter = AboutPresenter()
        let view = AboutViewController(style: .grouped)
        
        // Connections
        presenter.router = self
        presenter.view = view
        view.presenter = presenter
        
        navigationController.pushViewController(view, animated: true)
        viewController = view
    }
    
    func presentHelpCenter() {
        
        let webViewController = SFSafariViewController(url: URL(string: "https://www.edreams.com")!)
        viewController?.navigationController?.pushViewController(webViewController, animated: true)
    }
}
