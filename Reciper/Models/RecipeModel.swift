//
//  RecipeModel.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 13-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import Foundation
import Firebase

class RecipeModel : FirebaseModel {
    static let shared = RecipeModel()
    
    var user: User!
    
    override init() {
        super.init()
        user = Auth.auth().currentUser!
        self.ref = self.db.reference(withPath: "recipes")
    }
    
    func add(_ recipe: SmallRecipeEntity) {
        ref.child(recipe.id).setValue(self.recipeToSnapshot(recipe))
    }
    
    func remove(_ recipe: SmallRecipeEntity) {
        self.ref.child(recipe.id).removeValue()
    }
    
    func get(_ recipeID: String, _ observe: ObserveOrOnce = .once, with: @escaping (SmallRecipeEntity?) -> Void) {
        self.check(self.ref.child(recipeID), observe) { (recipeSnap) in
            with(self.recipeFromSnapshot(recipeSnap))
        }
    }
    
    func getMany(_ recipeIDs: [String], with: @escaping ([SmallRecipeEntity]) -> Void) {
        var live = recipeIDs.count
        var results: [SmallRecipeEntity] = []
        
        for id in recipeIDs {
            self.get(id, .once, with: { (recipe) in
                if let recipe = recipe {
                    results.append(recipe)
                }
                
                live = live - 1
                if live == 0 {
                    with(results)
                }
            })
        }
    }
    
    
    func recipeFromSnapshot(_ snapshot: DataSnapshot) -> SmallRecipeEntity? {
        guard let dict = snapshot.value as? [String: AnyObject] else {
            return nil
        }
        
        return SmallRecipeEntity(id: dict["id"] as! String,
                                 title: dict["title"] as! String,
                                 time: dict["time"] as! Int,
                                 url: URL(string: dict["url"] as! String)!,
                                 type: dict["type"] as! String,
                                 image: URL(string: dict["image"] as! String),
                                 servings: dict["servings"] as! String)
    }
    
    
    func recipeToSnapshot(_ smallRecipe: SmallRecipeEntity) -> Any {
        return [
            "id": smallRecipe.id,
            "title": smallRecipe.title,
            "time": smallRecipe.time,
            "url": smallRecipe.url.absoluteString,
            "type": smallRecipe.type,
            "image": smallRecipe.image?.absoluteString ?? "",
            "servings": smallRecipe.servings
        ]
    }
    
}

