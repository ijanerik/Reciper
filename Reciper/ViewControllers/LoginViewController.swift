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
    
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        checkForDismissScreen()
    }
    
    // Check if the user is logged in, then the screen can be dismissed
    func checkForDismissScreen() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Buttons to sign in Google/Facebook
    
    func initUI() {
        self.googleButton.layer.cornerRadius = 8
        self.facebookButton.layer.cornerRadius = 8
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
