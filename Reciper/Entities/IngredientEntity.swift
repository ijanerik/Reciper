//
//  IngredientEntity.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 11-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import UIKit
import Firebase

struct IngredientEntity : Codable {
    var label : String
    
    enum CodingKeys: String, CodingKey {
        case label = "default-label"
    }
}
