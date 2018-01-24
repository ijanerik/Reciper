//
//  FavoritesTableViewController.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 13-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController {
    
    var favoriteModel: FavoriteModel!
    var recipeModel: RecipeModel!
    var userModel: UserModel!
    
    var recipes: [SmallRecipeEntity] = []
    
    var favoritesObserverHandler: FBObserver?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoriteModel = FavoriteModel.shared
        recipeModel = RecipeModel.shared
        userModel = UserModel.shared

        
        userModel.addHouseholdChanger { (_) in
            self.recipes = []
            self.favoritesObserverHandler?.unobserve()
            self.tableView.reloadData()
            
            self.favoritesObserverHandler = self.favoriteModel.allRecipes(.observe) { (results) in
                self.recipes = results
                self.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.recipes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteRecipe", for: indexPath)

        cell.textLabel?.text = self.recipes[indexPath.row].title

        return cell
    }

    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.favoriteModel.remove(self.recipes[indexPath.row])
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ToSingleRecipe") {
            let recipeController = segue.destination as! RecipeViewController
            recipeController.smallRecipe = self.recipes[tableView.indexPathForSelectedRow!.row]
        } else if segue.identifier == "ToAddToPlanner" {
            let controller = segue.destination as! AddToPlannerTableViewController
            controller.recipe = self.recipes[tableView.indexPathForSelectedRow!.row]
        }
    }

}
