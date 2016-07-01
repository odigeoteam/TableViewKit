//
//  ODGPresenceValidator.swift
//  TableViewKit
//
//  Created by Nelson Dominguez Leon on 22/06/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import Foundation

public class ODGPresenceValidator: ODGValidator {
    
    public init() { }
    
    public func name() -> String {
        return "presence"
    }
    
    public func validate(object: AnyObject?, name: String, parameters: [String : AnyObject]?) -> NSError? {
        
        guard let object = object as? String where !object.isEmpty else {
            return NSError(domain: "ODGPresenceValidator", code: ODGValidatorErrorCode.Presence.rawValue, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("\(name) is empty", comment: "")])
        }
        
        return nil
    }
}