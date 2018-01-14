//
//  SearchRecipeResultsEntity.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 11-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import UIKit
import Firebase

struct SearchRecipeResultsEntity : Codable {
    // How many rows were skipped before giving back results
    var started : Int
    
    // Search term
    var searched : String
    
    var results : [SmallRecipeEntity]
}
