//
//  GroceryEntity.swift
//  Reciper
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
    var planner: PlannerEntity?
    var recipeID: String?
    var recipe: SmallRecipeEntity?
    var done: Bool
}

