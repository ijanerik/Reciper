//
//  HouseholdModel.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 13-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import Foundation
import Firebase

class HouseholdModel : FirebaseModel {
    static let shared = HouseholdModel()
    
    var user: User!
    
    var userRef: DatabaseReference!
    
    override init() {
        super.init()
        user = Auth.auth().currentUser!
        self.ref = self.db.reference(withPath: "households")
        self.userRef = self.db.reference(withPath: "users").child(user.uid).child("households")
    }
    
    func addHousehold(_ household: HouseholdEntity) -> String {
        var newHousehold = household
        let houseHoldRef = ref.childByAutoId()
        newHousehold.id = houseHoldRef.key
        
        newHousehold.userIDs.append(user.uid)
        houseHoldRef.setValue(self.householdToSnapshot(newHousehold))
        
        self.userRef.child(houseHoldRef.key).setValue(true)
        return houseHoldRef.key
    }
    
    func addUser(_ household: HouseholdEntity, user: User) {
        // @TODO add user to household
    }
    
    func removeUser(_ household: HouseholdEntity, user: User) {
        // @TODO add user to household
    }
    
    func removeHousehold(_ household: HouseholdEntity) {
        if let id = household.id {
            self.ref.child(id).removeValue()
        }
    }
    
    func get(_ householdID: String, _ observe: ObserveOrOnce, with: @escaping (HouseholdEntity?) -> Void) {
        self.check(self.ref.child(householdID), observe) { (householdSnap) in
            with(self.householdFromSnapshot(householdSnap))
        }
    }
    
    func getMany(_ householdIDs: [String], with: @escaping ([HouseholdEntity]) -> Void) {
        var live = householdIDs.count
        var results: [HouseholdEntity] = []
        
        for id in householdIDs {
            self.get(id, .once, with: { (household) in
                if let household = household {
                    results.append(household)
                }
                
                live = live - 1
                if live == 0 {
                    with(results)
                }
            })
        }
    }
    
    
    func householdFromSnapshot(_ snapshot: DataSnapshot) -> HouseholdEntity? {
        guard let dict = snapshot.value as? [String: AnyObject] else {
            return nil
        }
        
        var users: [String] = []
        
        for user in dict["users"] as! [String:Bool] {
            users.append(user.key)
        }
        
        return HouseholdEntity(id: dict["id"] as? String,
                               title: dict["title"] as! String,
                               userIDs: users)
    }
    
    
    func householdToSnapshot(_ household: HouseholdEntity) -> Any {
        var users: [String: Bool] = [:]
        for userID in household.userIDs {
            users[userID] = true
        }
        
        return [
            "id": household.id!,
            "title": household.title,
            "users": users
        ]
    }
    
}


