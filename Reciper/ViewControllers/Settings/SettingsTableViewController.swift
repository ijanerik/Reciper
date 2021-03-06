//
//  SettingsTableViewController.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 11-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import UIKit
import Firebase

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func pressedLogout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            
            // Set to nil to set again on login
            UserDefaults.standard.set(nil, forKey:"currentHousehold")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
