//
//  FirebaseModel.swift
//  Reciper
//
// This a basic class that helps making Model classes easier with some helpfunctions.
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
    }
    
    let db = Database.database()
    var ref: DatabaseReference!
    
    func check(_ ref : DatabaseReference,
               _ observe: ObserveOrOnce = .once,
               with: @escaping (DataSnapshot)->()) -> FBObserver {
        var handler: UInt = 0
        if observe == .observe {
            handler = ref.observe(.value, with: with)
        } else {
            ref.observeSingleEvent(of: .value, with: with)
        }
        
        return FBObserver(ref: ref, handle: handler)
    }
}
