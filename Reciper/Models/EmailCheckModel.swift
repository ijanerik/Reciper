//
//  FavoriteModel.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 13-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import Foundation
import Firebase

class EmailCheckModel : FirebaseModel {
    static let shared = EmailCheckModel()
    
    var userModel: UserModel! = nil
    
    override init() {
        super.init()
        
        userModel = UserModel.shared
        
        self.ref = self.db.reference(withPath: "emails")
        self.ref.keepSynced(true)
    }
    
    func setEmail() {
        if let email = self.userModel.user.email {
            self.ref.child(self.encodeEmail(email)).setValue(self.userModel.user.uid)
        }
    }
    
    func checkEmail(_ email: String, with: @escaping (String?) -> ()) {
        _ = self.check(self.ref.child(self.encodeEmail(email))) { (snapshot) in
            with(snapshot.value as? String)
        }
    }
    
    func encodeEmail(_ email: String) -> String {
        return email.replacingOccurrences(of: ".", with: "%20")
    }
}
