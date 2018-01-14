//
//  SmallRecipeEntity.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 11-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import UIKit
import Firebase

struct SmallRecipeEntity : Codable {
    var id : String
    var title : String
    var time : Int
    var url : URL
    var type : String
    var image : URL?
    var servings : String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case time = "total-time"
        case type = "dish-type"
        case url
        case image = "small-image"
        case servings
    }
}

