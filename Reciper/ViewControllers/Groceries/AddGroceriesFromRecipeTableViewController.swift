//
//  AddGroceriesFromRecipeTableViewController.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 22-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import UIKit

class AddGroceriesFromRecipeTableViewController: UITableViewController {

    
    
    var planner: PlannerEntity!
    var fullRecipe: FullRecipeEntity?
    
    var recipeAPIModel: RecipeAPIModel! = nil
    var groceriesModel: GroceriesModel! = nil
    
    var selecteds: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeAPIModel = RecipeAPIModel.shared
        groceriesModel = GroceriesModel.shared

        self.recipeAPIModel.getRecipe(recipeID: self.planner.recipe!.id,
                                    completion: { (fullRecipe) in
                                        DispatchQueue.main.async {
                                            self.fullRecipe = fullRecipe
                                            self.selecteds = [Bool].init(repeating: true, count: self.fullRecipe?.ingredients.count ?? 0)
                                            self.tableView.reloadData()
                                        }
        })
        
        self.tabBarItem.title = self.planner.recipe!.title
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fullRecipe?.ingredients.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)

        cell.textLabel?.text = self.fullRecipe!.ingredients[indexPath.row].label
        if self.selecteds[indexPath.row] == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func pressedCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressedDone(_ sender: UIBarButtonItem) {
        if let fullRecipe = self.fullRecipe?.ingredients {
            for (ingredient, shouldAdd) in zip(fullRecipe, self.selecteds) {
                if shouldAdd {
                    let grocery = GroceryEntity(id: nil,
                                                title: ingredient.label,
                                                plannerID: planner.id,
                                                planner: planner,
                                                recipeID: planner.recipe!.id,
                                                recipe: planner.recipe!,
                                                done: false)
                    _ = groceriesModel.add(grocery)
                }
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selecteds[indexPath.row] = !self.selecteds[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    

}
