//
//  ODGEmailValidator.swift
//  TableViewKit
//
//  Created by Nelson Dominguez Leon on 22/06/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import Foundation

public class ODGEmailValidator: ODGValidator {
    
    public init() { }
    
    public func name() -> String {
        return "email"
    }
    
    public func validate(object: AnyObject?, name: String, parameters: [String : AnyObject]?) -> NSError? {
        
        if let email = object as? String {
            
            let error = NSError(domain: "ODGEmailValidator", code: ODGValidatorErrorCode.Email.rawValue, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("\(name) has not a valid format", comment: "")])
            let regex = try! NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}", options: [.CaseInsensitive])
            if regex.firstMatchInString(email, options: [], range: NSMakeRange(0, email.characters.count)) == nil {
                return error
            }
        }
        return nil
    }
}