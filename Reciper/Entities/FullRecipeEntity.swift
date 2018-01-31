//
//  FullRecipeEntity.swift
//  Reciper
//
// The full recipe Entity class holds all the information about
//  the recipe including preperations and ingredients.
//
//  Created by Jan Erik van Woerden on 11-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import UIKit
import Firebase

struct FullRecipeEntity : Codable {
    var id : String
    var title : String
    var time : Int
    var url : URL
    var type : String
    var image : URL?
    var tags : [String]
    var servings : String
    
    var bigImage : URL?
    var ingredients : [IngredientEntity]
    var nutrition : [String: String]
    var preperation : [String]
    var kitchenappliances : [String]
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case time = "total-time"
        case type = "dish-type"
        case url
        case image = "small-image"
        case tags
        case servings
        
        case bigImage
        case ingredients
        case nutrition
        case preperation
        case kitchenappliances
    }
}

