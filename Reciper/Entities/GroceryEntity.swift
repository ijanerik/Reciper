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
    var title : String
    var plannerID : String
    var recipeID : String
    var done : Bool
    
    enum CodingKeys: String, CodingKey {
        case title
        case plannerID
        case recipeID
        case done
    }
    
}

