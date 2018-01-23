//
//  FirebaseModel.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 13-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import Foundation
import Firebase

class FirebaseModel {
    enum ObserveOrOnce {
        case observe
        case once
        case observeWithCache // @TODO Give initial call with cached data
    }
    
    let db = Database.database()
    var ref: DatabaseReference!
    
    func check(_ ref : DatabaseReference, _ observe: ObserveOrOnce = .once, with: @escaping (DataSnapshot)->()) -> UInt {
        var handler: UInt = 0
        if observe == .observe || observe == .observeWithCache {
            handler = ref.observe(.value, with: with)
        } else {
            ref.observeSingleEvent(of: .value, with: with)
        }
        
        return handler
    }
}
