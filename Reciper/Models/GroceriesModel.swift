//
//  HouseholdModel.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 13-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import Foundation
import Firebase

class GroceriesModel : FirebaseModel {
    static let shared = GroceriesModel()
    
    var user: User!
    
    var userModel: UserModel! = nil
    
    override init() {
        super.init()
        
        self.userModel = UserModel.shared
        
        self.ref = self.db.reference(withPath: "groceries")
    }
    
    func add(_ grocery: GroceryEntity) -> String {
        var newGrocery = grocery
        let houseRef = self.ref.child(userModel.currentHouseholdID()!)
        let groceryRef = houseRef.childByAutoId()
        newGrocery.id = groceryRef.key
        
        if let recipe = newGrocery.recipe {
            newGrocery.recipeID = recipe.id
        }
        
        if let planner = newGrocery.planner {
            newGrocery.plannerID = planner.id!
        }
        
        groceryRef.setValue(self.groceryToSnapshot(newGrocery))
        return groceryRef.key
    }
    
    func remove(_ grocery: GroceryEntity) {
        if let id = grocery.id {
            let houseRef = self.ref.child(userModel.currentHouseholdID()!)
            let groceryRef = houseRef.child(id)
            groceryRef.removeValue()
        }
    }
    
    func update(_ grocery: GroceryEntity) {
        if let id = grocery.id {
            let houseRef = self.ref.child(userModel.currentHouseholdID()!)
            let groceryRef = houseRef.child(id)
            groceryRef.setValue(self.groceryToSnapshot(grocery))
        }
    }
    
    /*
    func get(_ plannerID: String, _ observe: ObserveOrOnce, with: @escaping (PlannerEntity?) -> Void) {
        _ = self.check(self.ref.child(userModel.currentHouseholdID()!).child(plannerID), observe) { (plannerSnap) in
            with(self.plannerFromSnapshot(plannerSnap))
        }
    }
     */
    
    func all(_ observe: ObserveOrOnce = .once, with: @escaping ([String:[GroceryEntity]])->()) -> UInt {
        return self.check(self.ref.child(userModel.currentHouseholdID()!), observe) { (results) in
            let allGroceries = Array((results.value as? [String:Any] ?? [:]).keys)
            
            var groceries: [String:[GroceryEntity]] = ["":[]]
            
            for groceryID in allGroceries {
                let grocery = self.groceryFromSnapshot(results.childSnapshot(forPath: groceryID))
                if let grocery = grocery {
                    guard let plannerID = grocery.plannerID else {
                        groceries[""]!.append(grocery)
                        continue
                    }
                    if groceries[plannerID] == nil {
                        groceries[plannerID] = [grocery]
                    } else {
                        groceries[plannerID]!.append(grocery)
                    }
                }
            }
            
            with(groceries)
        }
    }
    
    
    func groceryFromSnapshot(_ snapshot: DataSnapshot) -> GroceryEntity? {
        guard let dict = snapshot.value as? [String: AnyObject] else {
            return nil
        }
        
        return GroceryEntity(id: dict["id"] as? String,
                             title: dict["title"] as! String,
                             plannerID: dict["planner"] as? String,
                             planner: nil,
                             recipeID: dict["recipe"] as? String,
                             recipe: nil,
                             done: dict["done"] as! Bool
        )
        
    }
    
    
    func groceryToSnapshot(_ grocery: GroceryEntity) -> Any {
        return [
            "id": grocery.id!,
            "title": grocery.title,
            "recipe": grocery.recipeID ?? "",
            "planner": grocery.plannerID ?? "",
            "done": grocery.done
        ]
    }
    
}




