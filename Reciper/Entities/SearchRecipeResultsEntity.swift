//
//  SearchRecipeResultsEntity.swift
//  Reciper
//
//  The Entity class holds all the basic information about a search request to the API
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
    
    // All the resulted recipes
    var results : [SmallRecipeEntity]
}
