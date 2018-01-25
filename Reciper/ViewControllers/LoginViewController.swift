//
//  LoginViewController.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 10-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import UIKit

import Firebase
import GoogleSignIn
import FBSDKLoginKit

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressedGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func pressedFacebook(_ sender: UIButton) {
        // https://www.appcoda.com/firebase-facebook-login/
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                self.present(Alerts.simple(title: "Failed to login", text: error.localizedDescription), animated: false, completion: nil)
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                self.present(Alerts.simple(title: "Error", text: "Failed to get access token, to later"), animated: false, completion: nil)
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    self.present(Alerts.simple(title: "Login error", text: error.localizedDescription), animated: false, completion: nil)
                }
                
            })
            
        }
    }
    

}
