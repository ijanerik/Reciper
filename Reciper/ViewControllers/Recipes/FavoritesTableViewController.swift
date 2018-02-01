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
    var plannerModel: PlannerModel!
    
    var indicator: SimpleLoader!
    
    var recipes: [SmallRecipeEntity] = []
    var planningDate: Date?
    
    var favoritesObserverHandler: FBObserver?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoriteModel = FavoriteModel.shared
        recipeModel = RecipeModel.shared
        userModel = UserModel.shared
        plannerModel = PlannerModel.shared
        
        indicator = SimpleLoader(self)
        
        initObserver()
    }
    
    // Initialize the observer who watches all the data from the groceries in Firebase
    func initObserver() {
        userModel.addHouseholdChanger { (_) in
            self.recipes = []
            self.indicator.start()
            self.favoritesObserverHandler?.unobserve()
            self.tableView.reloadData()
            
            self.favoritesObserverHandler = self.favoriteModel.allRecipes(.observe) { (results) in
                self.recipes = results
                self.indicator.stop()
                self.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recipes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteRecipe", for: indexPath)
        let newCell = cell as! FavoriteRecipeTableViewCell

        let recipe = self.recipes[indexPath.row]
        newCell.delegate = self
        newCell.update(recipe)
        
        if let imageUrl = recipe.image {
            RecipeAPIModel.shared.fetchImage(url: imageUrl, completion: { (image) in
                DispatchQueue.main.async {
                    if let cellToUpdate = self.tableView.cellForRow(at: indexPath) {
                        let newCell = cellToUpdate as! FavoriteRecipeTableViewCell
                        newCell.updateImage(image)
                    }
                }
            })
        }

        return newCell
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
        } else if segue.identifier == "AddToPlanner" {
            let controller = segue.destination as! AddToPlannerTableViewController
            controller.recipe = (sender as! SmallRecipeEntity)
        } else if segue.identifier == "SearchRecipe" {
            let resultsController = segue.destination as! RecipeResultsTableViewController
            resultsController.planningDate = planningDate
            
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
        }
    }

}

extension FavoritesTableViewController: FavoriteRecipeCellDelegate {
    func addToPlannerTapped(sender: FavoriteRecipeTableViewCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            if let planningDate = self.planningDate {
                let planner = PlannerEntity(id: nil,
                                            date: planningDate,
                                            recipeID: self.recipes[indexPath.row].id,
                                            recipe: nil)
                let _ = self.plannerModel.add(planner)
                self.performSegue(withIdentifier: "unwindToPlanner", sender: self)
            } else {
                performSegue(withIdentifier: "AddToPlanner", sender: recipes[indexPath.row])
            }
        }
    }
}
