//
//  UserModel.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 13-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import Foundation
import Firebase

class UserModel : FirebaseModel {
    static let shared = UserModel()
    
    var user: User!
    
    var householdModel: HouseholdModel!
    
    var householdChanger = Event<String>()
    
    override init() {
        super.init()
        user = Auth.auth().currentUser!
        householdModel = HouseholdModel.shared
        
        self.ref = self.db.reference(withPath: "users").child(user.uid)
        self.ref.keepSynced(true)
        
        initUserObserver()
    }
    
    func initUserObserver() {
        // So if you login with another account you still can login
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.user = user
                
                self.ref.keepSynced(false)
                self.ref = self.db.reference(withPath: "users").child(self.user.uid)
                self.ref.keepSynced(true)
                
                self.userInit()
            }
        }
    }
    
    // Call this function when the users login to check if this is his first signup.
    func userInit() {
        _ = self.allHouseholdIDs(.once) { (households) in
            guard self.currentHouseholdID() == nil else {
                return
            }
            
            var newHouseholdID: String! = nil
            if households.isEmpty {
                let household = HouseholdEntity(id: nil, title: "Mijn househouden", userIDs: [])
                newHouseholdID = self.householdModel.addHousehold(household)
            } else {
                newHouseholdID = households[0]
            }
            self.setCurrentHousehold(newHouseholdID)
            EmailCheckModel.shared.setEmail()
        }
    }
    
    // Check if this is the users first signin
    func userExists(with: @escaping (Bool) -> ()) {
        _ = self.check(self.ref, .once) { (userSnap) in
            with(userSnap.exists())
        }
    }
    
    // Get current household of currently loggedin user
    func currentHouseholdID() -> String? {
        return UserDefaults.standard.string(forKey:"currentHousehold")
    }
    
    // Set current household of loggedin user.
    // Also call the householdChanger
    func setCurrentHousehold(_ householdID: String?) {
        if let id = householdID {
            UserDefaults.standard.set(id, forKey:"currentHousehold")
            householdChanger.emit(object: id)
        }
    }
    
    // Get all household ID's of currently loggedin user
    func allHouseholdIDs(_ observe: ObserveOrOnce = .once, with: @escaping ([String]) -> ()) -> FBObserver {
        return self.check(self.ref.child("households"), observe) { (results) in
            let households = results.value as? [String: Bool] ?? [:]
            with(Array(households.keys))
        }
    }
    
    // Get all household structs of loggedin user
    func allHouseholds(_ observe: ObserveOrOnce = .once, with: @escaping ([HouseholdEntity]) -> ()) -> FBObserver {
        return self.allHouseholdIDs(observe) { (results) in
            self.householdModel.getMany(results, with: with)
        }
    }
    
    // Add a listener to the household changer listener also first call the function.
    func addHouseholdChanger(_ with: @escaping (String) -> ()) {
        if let id = self.currentHouseholdID() {
            with(id)
        }
        householdChanger.listen(handler: with)
    }
}



