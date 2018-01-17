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
    
    let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        user = Auth.auth().currentUser!
        self.ref = self.db.reference(withPath: "planner").child(user.uid)
    }
    
    func add(_ planner: PlannerEntity) -> String {
        var newPlanner = planner
        let dateShort = dateFormatter.string(from: newPlanner.date)
        let dateRef = self.ref.child(dateShort)
        let plannerRef = dateRef.childByAutoId()
        newPlanner.id = plannerRef.key
        
        plannerRef.setValue(self.plannerToSnapshot(newPlanner))
        return plannerRef.key
    }
    
    func remove(_ planner: PlannerEntity) {
        if let id = planner.id {
            let dateShort = "09-10-1995"
            self.ref.child(dateShort).child(id).removeValue()
        }
    }
    
    func get(_ plannerID: String, _ observe: ObserveOrOnce, with: @escaping (PlannerEntity?) -> Void) {
        self.check(self.ref.child(plannerID), observe) { (plannerSnap) in
            with(self.plannerFromSnapshot(plannerSnap))
        }
    }
    
    func all(_ observe: ObserveOrOnce = .once, with: @escaping ([String:[PlannerEntity]])->()) {
        self.check(self.ref, observe) { (results) in
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
    
    
    func plannerFromSnapshot(_ snapshot: DataSnapshot) -> PlannerEntity? {
        guard let dict = snapshot.value as? [String: AnyObject] else {
            return nil
        }
        
        return PlannerEntity(id: dict["id"] as? String,
                             date: dateFormatter.date(from: dict["date"] as! String)!,
                             recipeID: dict["recipe"] as! String)
    }
    
    
    func plannerToSnapshot(_ planner: PlannerEntity) -> Any {
        
        return [
            "id": planner.id!,
            "date": dateFormatter.string(from: planner.date),
            "recipe": planner.recipeID
        ]
    }
    
}



