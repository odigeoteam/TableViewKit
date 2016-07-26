//
//  Validation.swift
//  TableViewKit
//
//  Created by Nelson Dominguez Leon on 22/06/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import Foundation

public class Validation {
    
    public class func validate(object: AnyObject?, name: String, validators: [Validator]) -> [NSError] {
        
        var errors: [NSError] = []
        
        for validator in validators {
            if let error = validator.validate(object, name: name, parameters: nil) {
                errors.append(error)
            }
        }
        
        return errors
    }
}