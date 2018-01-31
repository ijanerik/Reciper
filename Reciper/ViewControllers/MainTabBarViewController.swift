//
//  MainTabBarViewController.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 11-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        checkForLogin()
    }
    
    // Show the login screen when not logged in.
    func checkForLogin() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user == nil {
                self.performSegue(withIdentifier: "ToLogin", sender: nil)
            } else {
                if let VCs = self.viewControllers {
                    let VC = VCs[self.selectedIndex]
                    VC.viewDidLoad()
                    VC.viewDidAppear(true)
                }
            }
        }
    }

}
