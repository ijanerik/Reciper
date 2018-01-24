//
//  simpleAlert.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 23-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import UIKit

class Alerts {
    
    static func simple(title: String, text: String) -> UIAlertController {
        let alertController = UIAlertController(title: title,
                                                message: text,
                                                preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        return alertController
    }
}
