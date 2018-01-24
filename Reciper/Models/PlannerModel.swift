//
//  HouseholdModel.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 13-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import Foundation
import Firebase

class PlannerModel : FirebaseModel {
    static let shared = PlannerModel()
    
    var user: User!
    var recipeModel: RecipeModel! = nil
    var userModel: UserModel! = nil
    
    let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        recipeModel = RecipeModel.shared
        userModel = UserModel.shared
        
        user = Auth.auth().currentUser!
        self.ref = self.db.reference(withPath: "planner")
    }
    
    func add(_ planner: PlannerEntity) -> String {
        var newPlanner = planner
        let dateShort = dateFormatter.string(from: newPlanner.date)
        let dateRef = self.ref.child(userModel.currentHouseholdID()!).child(dateShort)
        let plannerRef = dateRef.childByAutoId()
        newPlanner.id = plannerRef.key
        
        plannerRef.setValue(self.plannerToSnapshot(newPlanner))
        return plannerRef.key
    }
    
    func remove(_ planner: PlannerEntity) {
        if let id = planner.id {
            let dateShort = dateFormatter.string(from: planner.date)
            self.ref.child(userModel.currentHouseholdID()!).child(dateShort).child(id).removeValue()
        }
    }

    
    func all(_ observe: ObserveOrOnce = .once, with: @escaping ([String:[PlannerEntity]])->()) -> FBObserver {
         return self.check(self.ref.child(userModel.currentHouseholdID()!), observe) { (results) in
            let allDatesStrings = Array((results.value as? [String:Any] ?? [:]).keys)
            
            var allDates: [String:[PlannerEntity]] = [:]
            
            
            for date in allDatesStrings {
                var allEntitiesDate: [PlannerEntity] = []
                
                let allPlannerIDs = Array((results.childSnapshot(forPath: date).value as? [String: Any] ?? [:]).keys)
                for plannerID in allPlannerIDs {
                    let plannerSnap = results.childSnapshot(forPath: date).childSnapshot(forPath: plannerID)
                    let planner = self.plannerFromSnapshot(plannerSnap)
                    if let planner = planner {
                        allEntitiesDate.append(planner)
                    }
                }
                
                allDates[date] = allEntitiesDate
            }
            with(allDates)
        }
    }
    
    func allWithRecipe(_ observe: ObserveOrOnce = .once, with: @escaping ([String:[PlannerEntity]])->()) -> FBObserver {
        return self.all(observe) { (results) in
            var returnResults: [String:[PlannerEntity]] = [:]
            var left = 0
            for (date, planners) in results {
                returnResults[date] = []
                for planner in planners {
                    left += 1
                    _ = self.recipeModel.get(planner.recipeID, with: { (recipe) in
                        var newPlanner = planner
                        newPlanner.recipe = recipe
                        
                        returnResults[date]!.append(newPlanner)
                        left -= 1
                        if left == 0 {
                            with(returnResults)
                        }
                    })
                }
            }
        }
    }
    
    
    func plannerFromSnapshot(_ snapshot: DataSnapshot) -> PlannerEntity? {
        guard let dict = snapshot.value as? [String: AnyObject] else {
            return nil
        }
        
        return PlannerEntity(id: dict["id"] as? String,
                             date: dateFormatter.date(from: dict["date"] as! String)!,
                             recipeID: dict["recipe"] as! String,
                             recipe: nil)

    }
    
    
    func plannerToSnapshot(_ planner: PlannerEntity) -> Any {
        
        return [
            "id": planner.id!,
            "date": dateFormatter.string(from: planner.date),
            "recipe": planner.recipeID
        ]
    }
    
}



