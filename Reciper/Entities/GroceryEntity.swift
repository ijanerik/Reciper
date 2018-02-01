//
//  GroceryEntity.swift
//  Reciper
//
//  This struct holds all the information about a grocery
//
//  Created by Jan Erik van Woerden on 11-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import UIKit
import Firebase

struct GroceryEntity {
    var id: String?
    var title: String
    var plannerID: String?
    var recipeID: String?
    var done: Bool
    
    // Grabbed based on the planner ID.
    var planner: PlannerEntity?
    
    // Based on the recipe ID
    var recipe: SmallRecipeEntity?
}

