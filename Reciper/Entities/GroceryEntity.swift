//
//  GroceryEntity.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 11-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import UIKit
import Firebase

struct GroceryEntity : Codable {
    var date : Date
    var recipeID : String
    var groceryIDs : [String]
    
    enum CodingKeys: String, CodingKey {
        case date
        case recipeID
        case groceryIDs
    }
    
    func getPlanner() -> PlannerEntity? {
        return nil
        // @TODO
    }
    
    func getRecipe() -> SmallRecipeEntity? {
        return nil
        // @TODO
    }
}

