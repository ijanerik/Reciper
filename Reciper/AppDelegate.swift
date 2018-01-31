//
//  AppDelegate.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 10-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import UIKit

import Firebase
import GoogleSignIn

import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Cache for faster reuse of images
        let temporaryDirectory = NSTemporaryDirectory()
        let urlCache = URLCache(memoryCapacity: 25000000,
                                diskCapacity: 50000000, diskPath: temporaryDirectory)
        URLCache.shared = urlCache
        
        // Configuration of Firebase and the Google login
        FirebaseApp.configure()
        //Database.database().isPersistenceEnabled = true
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    
    // When coming back from Facebook/Google with signin code.
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])-> Bool {
        let googleHandled = GIDSignIn.sharedInstance().handle(url,
                                            sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                            annotation: [:])
        let facebookHandled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, options: options)
        return (facebookHandled || googleHandled)
    }
    
    
    // Google Sign in
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if error != nil {
            print("Error")
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print("Error")
                return
            }
        }
    }
}

