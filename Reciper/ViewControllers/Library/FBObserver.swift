//
//  FBObserver.swift
//  Reciper
//
//  This object should be returned after a firebase call.
//  The object should make it easy to stop observing a FB object.
//
//  Created by Jan Erik van Woerden on 24-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import UIKit
import Firebase

class FBObserver {
    let ref: DatabaseReference
    let handle: UInt
    
    init(ref: DatabaseReference, handle: UInt) {
        self.ref = ref
        self.handle = handle
    }
    
    func unobserve() {
        self.ref.removeObserver(withHandle: self.handle)
    }
    
    static func removeMulti(_ observers: [FBObserver]) {
        for observer in observers {
            observer.unobserve()
        }
    }
}
