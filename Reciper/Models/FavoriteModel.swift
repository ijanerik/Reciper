//
//  FavoriteModel.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 13-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import Foundation
import Firebase

class FavoriteModel : FirebaseModel {
    static let shared = FavoriteModel()
    
    var user: User!
    var recipeModel: RecipeModel!
    
    override init() {
        super.init()
        user = Auth.auth().currentUser!
        recipeModel = RecipeModel.shared
        
        self.ref = self.db.reference(withPath: "favorites").child(user.uid)
        self.ref.keepSynced(true)
        
        // So if you login with another account you still can loggin
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.user = user
                self.ref.keepSynced(false)
                self.ref = self.db.reference(withPath: "favorites").child(self.user.uid)
                self.ref.keepSynced(true)
            }
        }
    }
    
    func add(_ recipe: SmallRecipeEntity) {
        self.ref.child(recipe.id).setValue(true)
    }
    
    func remove(_ recipe: SmallRecipeEntity) {
        self.ref.child(recipe.id).removeValue()
    }
    
    func all(_ observe: ObserveOrOnce = .once, with: @escaping ([String])->()) -> FBObserver {
        return self.check(self.ref, observe) { (results) in
            let favorites = results.value as? [String: Bool] ?? [:]
            with(Array(favorites.keys))
        }
    }
    
    func allRecipes(_ observe: ObserveOrOnce = .once, with: @escaping ([SmallRecipeEntity])->()) -> FBObserver {
        return self.all(observe) { (results) in
            self.recipeModel.getMany(results, with: with)
        }
    }
    
    func get(_ recipe: SmallRecipeEntity, _ observe: ObserveOrOnce = .once, with: @escaping (Bool)->()) -> FBObserver {
        return self.check(self.ref.child(recipe.id), observe) { (results) in
            if let bool = results.value as? Bool, bool == true {
                with(true)
            } else {
                with(false)
            }
        }
    }
}
