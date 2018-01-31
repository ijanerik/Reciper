//
//  PlannerEntity.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 11-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import UIKit
import Firebase

struct PlannerEntity : Codable {
    var id: String?
    var date : Date
    var recipeID : String
    
    // Based on the recipe ID
    var recipe: SmallRecipeEntity? = nil
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case recipeID
    }
}


