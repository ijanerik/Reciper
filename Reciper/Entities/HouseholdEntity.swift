//
//  PlannerEntity.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 11-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import UIKit
import Firebase

struct HouseholdEntity : Codable {
    var id: String?
    var title: String
    var userIDs: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case userIDs
    }
}



